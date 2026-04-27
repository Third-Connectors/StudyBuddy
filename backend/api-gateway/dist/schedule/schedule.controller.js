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
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ScheduleController = void 0;
const common_1 = require("@nestjs/common");
const platform_express_1 = require("@nestjs/platform-express");
const swagger_1 = require("@nestjs/swagger");
const schedule_service_1 = require("./schedule.service");
const jwt_auth_guard_1 = require("../auth/guards/jwt-auth.guard");
let ScheduleController = class ScheduleController {
    constructor(scheduleService) {
        this.scheduleService = scheduleService;
    }
    async uploadSchedule(req, file) {
        return this.scheduleService.uploadSchedule(req.user.userId, file);
    }
    async getSchedules(req) {
        return this.scheduleService.getSchedules(req.user.userId);
    }
    async addSchedule(req, scheduleData) {
        return this.scheduleService.addSchedule(req.user.userId, scheduleData);
    }
    async updateSchedule(scheduleId, scheduleData) {
        return this.scheduleService.updateSchedule(scheduleId, scheduleData);
    }
    async deleteSchedule(scheduleId) {
        return this.scheduleService.deleteSchedule(scheduleId);
    }
    async generateOptimized(req, data) {
        return this.scheduleService.generateOptimizedSchedule(req.user.userId, data);
    }
};
exports.ScheduleController = ScheduleController;
__decorate([
    (0, common_1.Post)('upload'),
    (0, swagger_1.ApiOperation)({ summary: 'Upload schedule image for OCR' }),
    (0, swagger_1.ApiConsumes)('multipart/form-data'),
    (0, common_1.UseInterceptors)((0, platform_express_1.FileInterceptor)('file')),
    __param(0, (0, common_1.Request)()),
    __param(1, (0, common_1.UploadedFile)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, Object]),
    __metadata("design:returntype", Promise)
], ScheduleController.prototype, "uploadSchedule", null);
__decorate([
    (0, common_1.Get)(),
    (0, swagger_1.ApiOperation)({ summary: 'Get user schedules' }),
    __param(0, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], ScheduleController.prototype, "getSchedules", null);
__decorate([
    (0, common_1.Post)(),
    (0, swagger_1.ApiOperation)({ summary: 'Add new schedule' }),
    __param(0, (0, common_1.Request)()),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, Object]),
    __metadata("design:returntype", Promise)
], ScheduleController.prototype, "addSchedule", null);
__decorate([
    (0, common_1.Put)(':scheduleId'),
    (0, swagger_1.ApiOperation)({ summary: 'Update schedule' }),
    __param(0, (0, common_1.Param)('scheduleId')),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, Object]),
    __metadata("design:returntype", Promise)
], ScheduleController.prototype, "updateSchedule", null);
__decorate([
    (0, common_1.Delete)(':scheduleId'),
    (0, swagger_1.ApiOperation)({ summary: 'Delete schedule' }),
    __param(0, (0, common_1.Param)('scheduleId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], ScheduleController.prototype, "deleteSchedule", null);
__decorate([
    (0, common_1.Post)('generate-optimized'),
    (0, swagger_1.ApiOperation)({ summary: 'Generate optimized study schedule' }),
    __param(0, (0, common_1.Request)()),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, Object]),
    __metadata("design:returntype", Promise)
], ScheduleController.prototype, "generateOptimized", null);
exports.ScheduleController = ScheduleController = __decorate([
    (0, swagger_1.ApiTags)('Schedule Scanner'),
    (0, common_1.Controller)('schedule'),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard),
    (0, swagger_1.ApiBearerAuth)(),
    __metadata("design:paramtypes", [schedule_service_1.ScheduleService])
], ScheduleController);
//# sourceMappingURL=schedule.controller.js.map