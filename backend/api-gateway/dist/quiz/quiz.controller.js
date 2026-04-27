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
exports.QuizController = void 0;
const common_1 = require("@nestjs/common");
const swagger_1 = require("@nestjs/swagger");
const quiz_service_1 = require("./quiz.service");
const jwt_auth_guard_1 = require("../auth/guards/jwt-auth.guard");
let QuizController = class QuizController {
    constructor(quizService) {
        this.quizService = quizService;
    }
    async getQuizzes(filters) {
        return this.quizService.getQuizzes(filters);
    }
    async getQuizById(quizId) {
        return this.quizService.getQuizById(quizId);
    }
    async getQuizQuestions(quizId) {
        return this.quizService.getQuizQuestions(quizId);
    }
    async submitQuiz(req, quizId, answers, timeSpentSeconds) {
        return this.quizService.submitQuiz(quizId, req.user.userId, answers, timeSpentSeconds);
    }
    async getQuizHistory(req) {
        return this.quizService.getQuizHistory(req.user.userId);
    }
};
exports.QuizController = QuizController;
__decorate([
    (0, common_1.Get)(),
    (0, swagger_1.ApiOperation)({ summary: 'Get list of quizzes' }),
    __param(0, (0, common_1.Query)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], QuizController.prototype, "getQuizzes", null);
__decorate([
    (0, common_1.Get)(':quizId'),
    (0, swagger_1.ApiOperation)({ summary: 'Get quiz by ID' }),
    __param(0, (0, common_1.Param)('quizId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], QuizController.prototype, "getQuizById", null);
__decorate([
    (0, common_1.Get)(':quizId/questions'),
    (0, swagger_1.ApiOperation)({ summary: 'Get quiz questions' }),
    __param(0, (0, common_1.Param)('quizId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], QuizController.prototype, "getQuizQuestions", null);
__decorate([
    (0, common_1.Post)(':quizId/submit'),
    (0, swagger_1.ApiOperation)({ summary: 'Submit quiz answers' }),
    __param(0, (0, common_1.Request)()),
    __param(1, (0, common_1.Param)('quizId')),
    __param(2, (0, common_1.Body)('answers')),
    __param(3, (0, common_1.Body)('timeSpentSeconds')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String, Array, Number]),
    __metadata("design:returntype", Promise)
], QuizController.prototype, "submitQuiz", null);
__decorate([
    (0, common_1.Get)('history'),
    (0, swagger_1.ApiOperation)({ summary: 'Get user quiz history' }),
    __param(0, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], QuizController.prototype, "getQuizHistory", null);
exports.QuizController = QuizController = __decorate([
    (0, swagger_1.ApiTags)('Quiz'),
    (0, common_1.Controller)('quiz'),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard),
    (0, swagger_1.ApiBearerAuth)(),
    __metadata("design:paramtypes", [quiz_service_1.QuizService])
], QuizController);
//# sourceMappingURL=quiz.controller.js.map