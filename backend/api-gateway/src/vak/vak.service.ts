import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { HttpService } from '@nestjs/axios';
import { ConfigService } from '@nestjs/config';
import { firstValueFrom } from 'rxjs';

import { VakResult } from './entities/vak-result.entity';

@Injectable()
export class VakService {
  constructor(
    @InjectRepository(VakResult)
    private vakRepository: Repository<VakResult>,
    private httpService: HttpService,
    private configService: ConfigService,
  ) {}

  /**
   * Get VAK questions (from MongoDB or hardcoded)
   */
  async getQuestions(): Promise<any[]> {
    // TODO: Fetch from MongoDB
    return this._getHardcodedQuestions();
  }

  /**
   * Submit VAK answers and get result
   */
  async submitAnswers(userId: string, answers: any[]): Promise<VakResult> {
    // Call ML Service for KNN classification
    try {
      const mlServiceUrl = this.configService.get<string>('ML_SERVICE_URL');
      const response = await firstValueFrom(
        this.httpService.post(`${mlServiceUrl}/vak/classify`, {
          userId,
          answers,
        }),
      );

      const resultData = response.data.result;

      // Save to PostgreSQL
      const vakResult = this.vakRepository.create({
        userId,
        visualScore: resultData.visualScore,
        auditoryScore: resultData.auditoryScore,
        kinestheticScore: resultData.kinestheticScore,
        dominantStyle: resultData.dominantStyle,
        confidenceScore: resultData.confidence,
        completedAt: new Date(),
        answers,
      });

      return this.vakRepository.save(vakResult);
    } catch (error) {
      // Fallback: Local calculation
      return this._calculateResultLocally(userId, answers);
    }
  }

  /**
   * Get user's VAK result
   */
  async getUserResult(userId: string): Promise<VakResult | null> {
    return this.vakRepository.findOne({
      where: { userId },
      order: { completedAt: 'DESC' },
    });
  }

  /**
   * Check if user can recalibrate (once per semester)
   */
  async canRecalibrate(userId: string): Promise<boolean> {
    const lastResult = await this.getUserResult(userId);

    if (!lastResult) {
      return true;
    }

    // Check if > 4 months ago (one semester)
    const monthsSince = this._getMonthsDifference(lastResult.completedAt, new Date());
    return monthsSince >= 4;
  }

  /**
   * Calculate VAK result locally (fallback)
   */
  private _calculateResultLocally(userId: string, answers: any[]): VakResult {
    let visualScore = 0;
    let auditoryScore = 0;
    let kinestheticScore = 0;

    for (const answer of answers) {
      switch (answer.selectedOption.toUpperCase()) {
        case 'A':
          visualScore++;
          break;
        case 'B':
          auditoryScore++;
          break;
        case 'C':
          kinestheticScore++;
          break;
      }
    }

    const total = answers.length;
    visualScore = visualScore / total;
    auditoryScore = auditoryScore / total;
    kinestheticScore = kinestheticScore / total;

    const scores = {
      visual: visualScore,
      auditory: auditoryScore,
      kinesthetic: kinestheticScore,
    };

    const dominantStyle = Object.entries(scores)
      .reduce((a, b) => (a[1] > b[1] ? a : b))[0];

    const maxScore = scores[dominantStyle as keyof typeof scores];
    const avgScore = (visualScore + auditoryScore + kinestheticScore) / 3;
    const confidence = Math.max(0, Math.min(1, (maxScore - avgScore) * 3));

    const vakResult = this.vakRepository.create({
      userId,
      visualScore,
      auditoryScore,
      kinestheticScore,
      dominantStyle,
      confidenceScore: confidence,
      completedAt: new Date(),
      answers,
    });

    return this.vakRepository.save(vakResult);
  }

  /**
   * Get months difference between two dates
   */
  private _getMonthsDifference(date1: Date, date2: Date): number {
    const months = (date2.getFullYear() - date1.getFullYear()) * 12;
    return months - date1.getMonth() + date2.getMonth();
  }

  /**
   * Hardcoded VAK questions
   */
  private _getHardcodedQuestions(): any[] {
    return [
      {
        id: 1,
        question: 'Ketika mempelajari sesuatu yang baru, aku lebih suka...',
        optionA: 'Melihat gambar, diagram, atau video',
        optionB: 'Mendengarkan penjelasan dari guru/teman',
        optionC: 'Langsung mencoba/praktik sendiri',
      },
      {
        id: 2,
        question: 'Saat aku harus mengikuti petunjuk, aku lebih suka...',
        optionA: 'Membaca petunjuk tertulis',
        optionB: 'Mendengarkan penjelasan lisan',
        optionC: 'Langsung mencoba sambil belajar',
      },
      // Add remaining 18 questions...
    ];
  }
}
