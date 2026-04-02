import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';

@Injectable()
export class QuizService {
  constructor(
    @InjectModel('Quiz') private quizModel: Model<any>,
    @InjectModel('QuizResult') private resultModel: Model<any>,
  ) {}

  async getQuizzes(filters: any) {
    const quizzes = await this.quizModel.find({ isPublished: true, ...filters }).limit(50);
    return { quizzes };
  }

  async getQuizById(quizId: string) {
    const quiz = await this.quizModel.findById(quizId);
    return { quiz };
  }

  async getQuizQuestions(quizId: string) {
    const quiz = await this.quizModel.findById(quizId);
    return { questions: quiz?.questions || [] };
  }

  async submitQuiz(quizId: string, userId: string, answers: number[], timeSpentSeconds: number) {
    // Calculate score
    const quiz = await this.quizModel.findById(quizId);
    if (!quiz) throw new Error('Quiz not found');

    let correctCount = 0;
    quiz.questions.forEach((q: any, index: number) => {
      if (answers[index] === q.correctIndex) correctCount++;
    });

    const score = Math.round((correctCount / quiz.questions.length) * 100);
    const xpEarned = Math.round((score / 100) * quiz.xpReward);

    // Save result
    const result = await this.resultModel.create({
      quizId,
      userId,
      answers,
      correctCount,
      score,
      xpEarned,
      timeSpentSeconds,
      completedAt: new Date(),
    });

    // Update quiz stats
    await this.quizModel.findByIdAndUpdate(quizId, {
      $inc: { attempts: 1 },
    });

    return { result };
  }

  async getQuizHistory(userId: string) {
    const results = await this.resultModel.find({ userId }).sort({ completedAt: -1 }).limit(50);
    return { results };
  }
}
