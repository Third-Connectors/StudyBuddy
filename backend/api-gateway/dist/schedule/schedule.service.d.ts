import { ConfigService } from '@nestjs/config';
import { HttpService } from '@nestjs/axios';
export declare class ScheduleService {
    private httpService;
    private configService;
    constructor(httpService: HttpService, configService: ConfigService);
    uploadSchedule(userId: string, file: any): Promise<{
        result: {
            rawText: string;
            extractedSchedules: any[];
        };
    }>;
    getSchedules(userId: string): Promise<{
        schedules: any[];
    }>;
    addSchedule(userId: string, scheduleData: any): Promise<{
        schedule: any;
    }>;
    updateSchedule(scheduleId: string, scheduleData: any): Promise<{
        schedule: any;
    }>;
    deleteSchedule(scheduleId: string): Promise<{
        success: boolean;
    }>;
    generateOptimizedSchedule(userId: string, data: any): Promise<any>;
}
