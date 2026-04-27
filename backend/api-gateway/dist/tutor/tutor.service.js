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
exports.TutorService = void 0;
const common_1 = require("@nestjs/common");
const config_1 = require("@nestjs/config");
const mongoose_1 = require("@nestjs/mongoose");
const mongoose_2 = require("mongoose");
const axios_1 = require("@nestjs/axios");
let TutorService = class TutorService {
    constructor(sessionModel, httpService, configService) {
        this.sessionModel = sessionModel;
        this.httpService = httpService;
        this.configService = configService;
    }
    async chat(userId, sessionId, message, subject) {
        const geminiApiKey = this.configService.get('GEMINI_API_KEY');
        return {
            message: {
                id: `msg_${Date.now()}`,
                content: 'Pertanyaan bagus! Mari kita pikirkan bersama-sama.',
                isUser: false,
                timestamp: new Date(),
            },
        };
    }
    async createSession(userId, title, subject) {
        const session = await this.sessionModel.create({
            userId,
            title,
            subject,
            messages: [],
            isActive: true,
        });
        return { session };
    }
    async getSessions(userId) {
        const sessions = await this.sessionModel
            .find({ userId })
            .sort({ lastMessageAt: -1 })
            .limit(20);
        return { sessions };
    }
    async getSessionById(sessionId) {
        const session = await this.sessionModel.findById(sessionId);
        return { session };
    }
    async deleteSession(sessionId) {
        await this.sessionModel.findByIdAndDelete(sessionId);
        return { success: true };
    }
};
exports.TutorService = TutorService;
exports.TutorService = TutorService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, mongoose_1.InjectModel)('TutorSession')),
    __metadata("design:paramtypes", [mongoose_2.Model,
        axios_1.HttpService,
        config_1.ConfigService])
], TutorService);
//# sourceMappingURL=tutor.service.js.map