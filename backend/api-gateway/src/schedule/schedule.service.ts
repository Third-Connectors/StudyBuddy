import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { HttpService } from '@nestjs/axios';
import { firstValueFrom } from 'rxjs';

@Injectable()
export class ScheduleService {
  constructor(
    private httpService: HttpService,
    private configService: ConfigService,
  ) {}

  async uploadSchedule(userId: string, file: any) {
    // Process with Gemini Vision API
    const geminiApiKey = this.configService.get<string>('GEMINI_API_KEY');

    // TODO: Implement actual OCR processing
    return {
      result: {
        rawText: 'Jadwal pelajaran...',
        extractedSchedules: [],
      },
    };
  }

  async getSchedules(userId: string) {
    // TODO: Fetch from MongoDB
    return { schedules: [] };
  }

  async addSchedule(userId: string, scheduleData: any) {
    // TODO: Save to MongoDB
    return { schedule: { id: 'sch_1', ...scheduleData } };
  }

  async updateSchedule(scheduleId: string, scheduleData: any) {
    // TODO: Update in MongoDB
    return { schedule: { id: scheduleId, ...scheduleData } };
  }

  async deleteSchedule(scheduleId: string) {
    // TODO: Delete from MongoDB
    return { success: true };
  }

  async generateOptimizedSchedule(userId: string, data: any) {
    // Call ML Service for Genetic Algorithm optimization
    const mlServiceUrl = this.configService.get<string>('ML_SERVICE_URL');

    try {
      const response = await firstValueFrom(
        this.httpService.post(`${mlServiceUrl}/schedule/optimize`, {
          userId,
          ...data,
        }),
      );

      return (response as any).data;
    } catch (error) {
      // Fallback: Simple scheduling
      return { schedules: [] };
    }
  }
}
