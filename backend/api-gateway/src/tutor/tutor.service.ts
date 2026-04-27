import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { HttpService } from '@nestjs/axios';
import { firstValueFrom } from 'rxjs';

import { ITutorSession } from '../config/database/mongodb-schema';

@Injectable()
export class TutorService {
  constructor(
    @InjectModel('TutorSession') private sessionModel: Model<ITutorSession>,
    private httpService: HttpService,
    private configService: ConfigService,
  ) {}

  async chat(userId: string, sessionId: string, message: string, subject?: string) {
    // Call Gemini API through backend or directly
    const geminiApiKey = this.configService.get<string>('GEMINI_API_KEY');

    // TODO: Implement conversation history management
    // For now, simple single-turn conversation

    return {
      message: {
        id: `msg_${Date.now()}`,
        content: 'Pertanyaan bagus! Mari kita pikirkan bersama-sama.',
        isUser: false,
        timestamp: new Date(),
      },
    };
  }

  async createSession(userId: string, title: string, subject: string) {
    const session = await this.sessionModel.create({
      userId,
      title,
      subject,
      messages: [],
      isActive: true,
    });

    return { session };
  }

  async getSessions(userId: string) {
    const sessions = await this.sessionModel
      .find({ userId })
      .sort({ lastMessageAt: -1 })
      .limit(20);

    return { sessions };
  }

  async getSessionById(sessionId: string) {
    const session = await this.sessionModel.findById(sessionId);
    return { session };
  }

  async deleteSession(sessionId: string) {
    await this.sessionModel.findByIdAndDelete(sessionId);
    return { success: true };
  }
}
