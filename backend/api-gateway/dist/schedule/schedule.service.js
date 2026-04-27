"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ScheduleService = void 0;
const common_1 = require("@nestjs/common");
const config_1 = require("@nestjs/config");
const axios_1 = require("@nestjs/axios");
const rxjs_1 = require("rxjs");
let ScheduleService = class ScheduleService {
    constructor(httpService, configService) {
        this.httpService = httpService;
        this.configService = configService;
    }
    async uploadSchedule(userId, file) {
        const geminiApiKey = this.configService.get('GEMINI_API_KEY');
        return {
            result: {
                rawText: 'Jadwal pelajaran...',
                extractedSchedules: [],
            },
        };
    }
    async getSchedules(userId) {
        return { schedules: [] };
    }
    async addSchedule(userId, scheduleData) {
        return { schedule: { id: 'sch_1', ...scheduleData } };
    }
    async updateSchedule(scheduleId, scheduleData) {
        return { schedule: { id: scheduleId, ...scheduleData } };
    }
    async deleteSchedule(scheduleId) {
        return { success: true };
    }
    async generateOptimizedSchedule(userId, data) {
        const mlServiceUrl = this.configService.get('ML_SERVICE_URL');
        try {
            const response = await (0, rxjs_1.firstValueFrom)(this.httpService.post(`${mlServiceUrl}/schedule/optimize`, {
                userId,
                ...data,
            }));
            return response.data;
        }
        catch (error) {
            return { schedules: [] };
        }
    }
};
exports.ScheduleService = ScheduleService;
exports.ScheduleService = ScheduleService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [axios_1.HttpService,
        config_1.ConfigService])
], ScheduleService);
//# sourceMappingURL=schedule.service.js.map