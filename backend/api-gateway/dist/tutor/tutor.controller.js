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
exports.TutorController = void 0;
const common_1 = require("@nestjs/common");
const swagger_1 = require("@nestjs/swagger");
const tutor_service_1 = require("./tutor.service");
const jwt_auth_guard_1 = require("../auth/guards/jwt-auth.guard");
let TutorController = class TutorController {
    constructor(tutorService) {
        this.tutorService = tutorService;
    }
    async chat(req, sessionId, message, subject) {
        return this.tutorService.chat(req.user.userId, sessionId, message, subject);
    }
    async createSession(req, title, subject) {
        return this.tutorService.createSession(req.user.userId, title, subject);
    }
    async getSessions(req) {
        return this.tutorService.getSessions(req.user.userId);
    }
    async getSessionById(sessionId) {
        return this.tutorService.getSessionById(sessionId);
    }
    async deleteSession(sessionId) {
        return this.tutorService.deleteSession(sessionId);
    }
};
exports.TutorController = TutorController;
__decorate([
    (0, common_1.Post)('chat'),
    (0, swagger_1.ApiOperation)({ summary: 'Send message to AI tutor' }),
    __param(0, (0, common_1.Request)()),
    __param(1, (0, common_1.Body)('sessionId')),
    __param(2, (0, common_1.Body)('message')),
    __param(3, (0, common_1.Body)('subject')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String, String, String]),
    __metadata("design:returntype", Promise)
], TutorController.prototype, "chat", null);
__decorate([
    (0, common_1.Post)('sessions'),
    (0, swagger_1.ApiOperation)({ summary: 'Create new tutor session' }),
    __param(0, (0, common_1.Request)()),
    __param(1, (0, common_1.Body)('title')),
    __param(2, (0, common_1.Body)('subject')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String, String]),
    __metadata("design:returntype", Promise)
], TutorController.prototype, "createSession", null);
__decorate([
    (0, common_1.Get)('sessions'),
    (0, swagger_1.ApiOperation)({ summary: 'Get user tutor sessions' }),
    __param(0, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], TutorController.prototype, "getSessions", null);
__decorate([
    (0, common_1.Get)('sessions/:sessionId'),
    (0, swagger_1.ApiOperation)({ summary: 'Get session by ID' }),
    __param(0, (0, common_1.Param)('sessionId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], TutorController.prototype, "getSessionById", null);
__decorate([
    (0, common_1.Delete)('sessions/:sessionId'),
    (0, swagger_1.ApiOperation)({ summary: 'Delete session' }),
    __param(0, (0, common_1.Param)('sessionId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], TutorController.prototype, "deleteSession", null);
exports.TutorController = TutorController = __decorate([
    (0, swagger_1.ApiTags)('AI Tutor'),
    (0, common_1.Controller)('tutor'),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard),
    (0, swagger_1.ApiBearerAuth)(),
    __metadata("design:paramtypes", [tutor_service_1.TutorService])
], TutorController);
//# sourceMappingURL=tutor.controller.js.map