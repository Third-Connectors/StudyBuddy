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
exports.UserStat = void 0;
const typeorm_1 = require("typeorm");
const user_entity_1 = require("./user.entity");
let UserStat = class UserStat {
};
exports.UserStat = UserStat;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)('uuid'),
    __metadata("design:type", String)
], UserStat.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'user_id' }),
    __metadata("design:type", String)
], UserStat.prototype, "userId", void 0);
__decorate([
    (0, typeorm_1.OneToOne)(() => user_entity_1.User, (user) => user.stats, { onDelete: 'CASCADE' }),
    (0, typeorm_1.JoinColumn)({ name: 'user_id' }),
    __metadata("design:type", user_entity_1.User)
], UserStat.prototype, "user", void 0);
__decorate([
    (0, typeorm_1.Column)({ default: 0 }),
    __metadata("design:type", Number)
], UserStat.prototype, "xp", void 0);
__decorate([
    (0, typeorm_1.Column)({ default: 1 }),
    __metadata("design:type", Number)
], UserStat.prototype, "level", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'quizzes_completed', default: 0 }),
    __metadata("design:type", Number)
], UserStat.prototype, "quizzesCompleted", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'quizzes_passed', default: 0 }),
    __metadata("design:type", Number)
], UserStat.prototype, "quizzesPassed", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'average_score', type: 'decimal', precision: 5, scale: 2, default: 0 }),
    __metadata("design:type", Number)
], UserStat.prototype, "averageScore", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'study_streak_days', default: 0 }),
    __metadata("design:type", Number)
], UserStat.prototype, "studyStreakDays", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'total_study_minutes', default: 0 }),
    __metadata("design:type", Number)
], UserStat.prototype, "totalStudyMinutes", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'jsonb', default: [] }),
    __metadata("design:type", Array)
], UserStat.prototype, "badges", void 0);
__decorate([
    (0, typeorm_1.CreateDateColumn)({ name: 'created_at' }),
    __metadata("design:type", Date)
], UserStat.prototype, "createdAt", void 0);
__decorate([
    (0, typeorm_1.UpdateDateColumn)({ name: 'updated_at' }),
    __metadata("design:type", Date)
], UserStat.prototype, "updatedAt", void 0);
exports.UserStat = UserStat = __decorate([
    (0, typeorm_1.Entity)('user_stats')
], UserStat);
//# sourceMappingURL=user-stat.entity.js.map