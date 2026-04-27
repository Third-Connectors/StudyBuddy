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
exports.VakResult = void 0;
const typeorm_1 = require("typeorm");
let VakResult = class VakResult {
};
exports.VakResult = VakResult;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)('uuid'),
    __metadata("design:type", String)
], VakResult.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'user_id' }),
    __metadata("design:type", String)
], VakResult.prototype, "userId", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'visual_score', type: 'decimal', precision: 5, scale: 4 }),
    __metadata("design:type", Number)
], VakResult.prototype, "visualScore", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'auditory_score', type: 'decimal', precision: 5, scale: 4 }),
    __metadata("design:type", Number)
], VakResult.prototype, "auditoryScore", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'kinesthetic_score', type: 'decimal', precision: 5, scale: 4 }),
    __metadata("design:type", Number)
], VakResult.prototype, "kinestheticScore", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'dominant_style' }),
    __metadata("design:type", String)
], VakResult.prototype, "dominantStyle", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'confidence_score', type: 'decimal', precision: 5, scale: 4, nullable: true }),
    __metadata("design:type", Number)
], VakResult.prototype, "confidenceScore", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'completed_at' }),
    __metadata("design:type", Date)
], VakResult.prototype, "completedAt", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'jsonb' }),
    __metadata("design:type", Object)
], VakResult.prototype, "answers", void 0);
__decorate([
    (0, typeorm_1.CreateDateColumn)({ name: 'created_at' }),
    __metadata("design:type", Date)
], VakResult.prototype, "createdAt", void 0);
exports.VakResult = VakResult = __decorate([
    (0, typeorm_1.Entity)('vak_results')
], VakResult);
//# sourceMappingURL=vak-result.entity.js.map