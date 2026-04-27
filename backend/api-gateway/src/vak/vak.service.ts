import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { HttpService } from '@nestjs/axios';
import { ConfigService } from '@nestjs/config';
import { firstValueFrom } from 'rxjs';

import { VakResult } from './entities/vak-result.entity';
import { VakQuestion } from './entities/vak-question.entity';

@Injectable()
export class VakService {
  constructor(
    @InjectRepository(VakResult)
    private vakRepository: Repository<VakResult>,
    @InjectRepository(VakQuestion)
    private vakQuestionRepository: Repository<VakQuestion>,
    private httpService: HttpService,
    private configService: ConfigService,
  ) {}

  async getQuestions(): Promise<VakQuestion[]> {
    const questions = await this.vakQuestionRepository.find({
      order: { id: 'ASC' },
    });

    if (questions.length === 0) {
      // Auto-seed if database is empty
      await this.seedQuestions();
      return this.vakQuestionRepository.find({
        order: { id: 'ASC' },
      });
    }

    return questions;
  }

  /**
   * Seed hardcoded questions into the database
   */
  async seedQuestions(): Promise<void> {
    const questions = this._getHardcodedQuestions();
    for (const q of questions) {
      const entity = this.vakQuestionRepository.create({
        id: q.id,
        question: q.question,
        optionA: q.optionA,
        optionB: q.optionB,
        optionC: q.optionC,
      });
      await this.vakQuestionRepository.save(entity);
    }
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

      const resultData = (response as any).data.result;

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
  private async _calculateResultLocally(userId: string, answers: any[]): Promise<VakResult> {
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
   * Hardcoded VAK questions — 20-question psychometric survey.
   *
   * Designed for Indonesian high school students (SMA/MA/SMK).
   * Option A = Visual, Option B = Auditory, Option C = Kinesthetic.
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
      {
        id: 3,
        question: 'Ketika aku punya waktu luang, aku biasanya...',
        optionA: 'Menonton video atau membaca buku bergambar',
        optionB: 'Mendengarkan musik atau podcast',
        optionC: 'Berolahraga atau melakukan aktivitas fisik',
      },
      {
        id: 4,
        question: 'Aku paling mudah mengingat...',
        optionA: 'Apa yang aku lihat',
        optionB: 'Apa yang aku dengar',
        optionC: 'Apa yang aku lakukan',
      },
      {
        id: 5,
        question: 'Ketika belajar untuk ujian, aku lebih suka...',
        optionA: 'Membuat catatan berwarna dan mind map',
        optionB: 'Diskusi dengan teman atau membaca keras-keras',
        optionC: 'Mengerjakan latihan soal berulang-ulang',
      },
      {
        id: 6,
        question: 'Di kelas, aku lebih suka guru yang...',
        optionA: 'Menggunakan banyak gambar dan slide presentasi',
        optionB: 'Menjelaskan dengan detail dan jelas',
        optionC: 'Memberikan banyak praktik dan eksperimen',
      },
      {
        id: 7,
        question: 'Ketika aku tersesat di tempat baru, aku...',
        optionA: 'Melihat peta atau tanda-tanda visual',
        optionB: 'Bertanya pada orang sekitar',
        optionC: 'Coba jalan terus sampai menemukan jalan',
      },
      {
        id: 8,
        question: 'Aku paling suka tugas yang...',
        optionA: 'Banyak gambar dan ilustrasi',
        optionB: 'Ada diskusi presentasi',
        optionC: 'Ada praktik atau eksperimen',
      },
      {
        id: 9,
        question: 'Ketika membeli barang baru, aku...',
        optionA: 'Melihat gambar dan spesifikasi',
        optionB: 'Mendengarkan review dari orang lain',
        optionC: 'Langsung mencoba barangnya',
      },
      {
        id: 10,
        question: 'Aku lebih suka pelajaran yang...',
        optionA: 'Banyak diagram dan gambar (seperti Biologi)',
        optionB: 'Banyak diskusi dan cerita (seperti Sejarah)',
        optionC: 'Banyak praktikum (seperti Kimia/Fisika)',
      },
      {
        id: 11,
        question: 'Ketika menjelaskan sesuatu, aku sering...',
        optionA: 'Menggambar atau menunjukkan',
        optionB: 'Menjelaskan dengan kata-kata',
        optionC: 'Mendemonstrasikan langsung',
      },
      {
        id: 12,
        question: 'Aku terganggu ketika...',
        optionA: 'Tempat berantakan atau tidak rapi',
        optionB: 'Ada suara bising',
        optionC: 'Harus duduk diam terlalu lama',
      },
      {
        id: 13,
        question: 'Ketika belajar bahasa baru, aku lebih suka...',
        optionA: 'Melihat tulisan dan gambar',
        optionB: 'Mendengarkan dan mengulang',
        optionC: 'Praktik langsung berbicara',
      },
      {
        id: 14,
        question: 'Aku lebih mudah paham dengan...',
        optionA: 'Video tutorial',
        optionB: 'Podcast atau rekaman suara',
        optionC: 'Tutorial praktik langsung',
      },
      {
        id: 15,
        question: 'Ketika bermain game, aku lebih suka...',
        optionA: 'Game dengan grafis bagus',
        optionB: 'Game dengan cerita menarik',
        optionC: 'Game yang butuh keterampilan fisik',
      },
      {
        id: 16,
        question: 'Ruangan belajarku biasanya...',
        optionA: 'Banyak poster dan catatan di dinding',
        optionB: 'Sering diputar musik atau audio',
        optionC: 'Banyak alat praktik atau benda untuk disentuh',
      },
      {
        id: 17,
        question: 'Ketika menghadapi masalah, aku...',
        optionA: 'Membuat daftar atau diagram',
        optionB: 'Curhat atau diskusi dengan orang lain',
        optionC: 'Langsung action mencari solusi',
      },
      {
        id: 18,
        question: 'Aku lebih suka presentasi yang...',
        optionA: 'Banyak slide dan visual',
        optionB: 'Penjelasan detail dari presenter',
        optionC: 'Ada demo atau praktik langsung',
      },
      {
        id: 19,
        question: 'Ketika menghafal, aku biasanya...',
        optionA: 'Menulis ulang atau membuat catatan visual',
        optionB: 'Membaca keras-keras atau mendengarkan',
        optionC: 'Sambil bergerak atau melakukan sesuatu',
      },
      {
        id: 20,
        question: 'Teman-temanku bilang aku...',
        optionA: 'Peka terhadap tampilan dan warna',
        optionB: 'Pendengar yang baik',
        optionC: 'Aktif dan suka bergerak',
      },
    ];
  }
}
