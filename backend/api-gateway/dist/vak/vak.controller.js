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
exports.VakController = void 0;
const common_1 = require("@nestjs/common");
const swagger_1 = require("@nestjs/swagger");
const vak_service_1 = require("./vak.service");
const jwt_auth_guard_1 = require("../auth/guards/jwt-auth.guard");
let VakController = class VakController {
    constructor(vakService) {
        this.vakService = vakService;
    }
    async getQuestions() {
        return { questions: await this.vakService.getQuestions() };
    }
    async submitAnswers(req, answers) {
        const result = await this.vakService.submitAnswers(req.user.userId, answers);
        return { result };
    }
    async getUserResult(req) {
        const result = await this.vakService.getUserResult(req.user.userId);
        return { result };
    }
    async canRecalibrate(req) {
        const canRecalibrate = await this.vakService.canRecalibrate(req.user.userId);
        return { canRecalibrate };
    }
};
exports.VakController = VakController;
__decorate([
    (0, common_1.Get)('questions'),
    (0, swagger_1.ApiOperation)({ summary: 'Get VAK assessment questions' }),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], VakController.prototype, "getQuestions", null);
__decorate([
    (0, common_1.Post)('submit'),
    (0, swagger_1.ApiOperation)({ summary: 'Submit VAK answers and get result' }),
    __param(0, (0, common_1.Request)()),
    __param(1, (0, common_1.Body)('answers')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, Array]),
    __metadata("design:returntype", Promise)
], VakController.prototype, "submitAnswers", null);
__decorate([
    (0, common_1.Get)('result'),
    (0, swagger_1.ApiOperation)({ summary: 'Get user VAK result' }),
    __param(0, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], VakController.prototype, "getUserResult", null);
__decorate([
    (0, common_1.Get)('result/can-recalibrate'),
    (0, swagger_1.ApiOperation)({ summary: 'Check if user can recalibrate VAK' }),
    __param(0, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], VakController.prototype, "canRecalibrate", null);
exports.VakController = VakController = __decorate([
    (0, swagger_1.ApiTags)('VAK Assessment'),
    (0, common_1.Controller)('vak'),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard),
    (0, swagger_1.ApiBearerAuth)(),
    __metadata("design:paramtypes", [vak_service_1.VakService])
], VakController);
//# sourceMappingURL=vak.controller.js.map