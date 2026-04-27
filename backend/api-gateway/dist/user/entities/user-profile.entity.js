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
exports.UserProfile = void 0;
const typeorm_1 = require("typeorm");
const user_entity_1 = require("./user.entity");
let UserProfile = class UserProfile {
};
exports.UserProfile = UserProfile;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)('uuid'),
    __metadata("design:type", String)
], UserProfile.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'user_id' }),
    __metadata("design:type", String)
], UserProfile.prototype, "userId", void 0);
__decorate([
    (0, typeorm_1.OneToOne)(() => user_entity_1.User, (user) => user.profile, { onDelete: 'CASCADE' }),
    (0, typeorm_1.JoinColumn)({ name: 'user_id' }),
    __metadata("design:type", user_entity_1.User)
], UserProfile.prototype, "user", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'phone_number', nullable: true }),
    __metadata("design:type", String)
], UserProfile.prototype, "phoneNumber", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'date_of_birth', type: 'date', nullable: true }),
    __metadata("design:type", Date)
], UserProfile.prototype, "dateOfBirth", void 0);
__decorate([
    (0, typeorm_1.Column)({ nullable: true }),
    __metadata("design:type", String)
], UserProfile.prototype, "gender", void 0);
__decorate([
    (0, typeorm_1.Column)({ nullable: true }),
    __metadata("design:type", String)
], UserProfile.prototype, "address", void 0);
__decorate([
    (0, typeorm_1.Column)({ nullable: true }),
    __metadata("design:type", String)
], UserProfile.prototype, "city", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'province', nullable: true }),
    __metadata("design:type", String)
], UserProfile.prototype, "province", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'postal_code', nullable: true }),
    __metadata("design:type", String)
], UserProfile.prototype, "postalCode", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'parent_name', nullable: true }),
    __metadata("design:type", String)
], UserProfile.prototype, "parentName", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'parent_phone', nullable: true }),
    __metadata("design:type", String)
], UserProfile.prototype, "parentPhone", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'learning_style', nullable: true }),
    __metadata("design:type", String)
], UserProfile.prototype, "learningStyle", void 0);
__decorate([
    (0, typeorm_1.CreateDateColumn)({ name: 'created_at' }),
    __metadata("design:type", Date)
], UserProfile.prototype, "createdAt", void 0);
__decorate([
    (0, typeorm_1.UpdateDateColumn)({ name: 'updated_at' }),
    __metadata("design:type", Date)
], UserProfile.prototype, "updatedAt", void 0);
exports.UserProfile = UserProfile = __decorate([
    (0, typeorm_1.Entity)('profiles')
], UserProfile);
//# sourceMappingURL=user-profile.entity.js.map