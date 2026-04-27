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
exports.QuizService = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("@nestjs/mongoose");
const mongoose_2 = require("mongoose");
let QuizService = class QuizService {
    constructor(quizModel, resultModel) {
        this.quizModel = quizModel;
        this.resultModel = resultModel;
    }
    async getQuizzes(filters) {
        const quizzes = await this.quizModel.find({ isPublished: true, ...filters }).limit(50);
        return { quizzes };
    }
    async getQuizById(quizId) {
        const quiz = await this.quizModel.findById(quizId);
        return { quiz };
    }
    async getQuizQuestions(quizId) {
        const quiz = await this.quizModel.findById(quizId);
        return { questions: quiz?.questions || [] };
    }
    async submitQuiz(quizId, userId, answers, timeSpentSeconds) {
        const quiz = await this.quizModel.findById(quizId);
        if (!quiz)
            throw new Error('Quiz not found');
        let correctCount = 0;
        quiz.questions.forEach((q, index) => {
            if (answers[index] === q.correctIndex)
                correctCount++;
        });
        const score = Math.round((correctCount / quiz.questions.length) * 100);
        const xpEarned = Math.round((score / 100) * quiz.xpReward);
        const result = await this.resultModel.create({
            quizId,
            userId,
            answers,
            correctCount,
            score,
            xpEarned,
            timeSpentSeconds,
            completedAt: new Date(),
        });
        await this.quizModel.findByIdAndUpdate(quizId, {
            $inc: { attempts: 1 },
        });
        return { result };
    }
    async getQuizHistory(userId) {
        const results = await this.resultModel.find({ userId }).sort({ completedAt: -1 }).limit(50);
        return { results };
    }
};
exports.QuizService = QuizService;
exports.QuizService = QuizService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, mongoose_1.InjectModel)('Quiz')),
    __param(1, (0, mongoose_1.InjectModel)('QuizResult')),
    __metadata("design:paramtypes", [mongoose_2.Model,
        mongoose_2.Model])
], QuizService);
//# sourceMappingURL=quiz.service.js.map