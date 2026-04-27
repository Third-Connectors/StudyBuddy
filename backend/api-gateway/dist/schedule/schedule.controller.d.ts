import { ScheduleService } from './schedule.service';
export declare class ScheduleController {
    private scheduleService;
    constructor(scheduleService: ScheduleService);
    uploadSchedule(req: any, file: any): Promise<{
        result: {
            rawText: string;
            extractedSchedules: any[];
        };
    }>;
    getSchedules(req: any): Promise<{
        schedules: any[];
    }>;
    addSchedule(req: any, scheduleData: any): Promise<{
        schedule: any;
    }>;
    updateSchedule(scheduleId: string, scheduleData: any): Promise<{
        schedule: any;
    }>;
    deleteSchedule(scheduleId: string): Promise<{
        success: boolean;
    }>;
    generateOptimized(req: any, data: any): Promise<any>;
}
