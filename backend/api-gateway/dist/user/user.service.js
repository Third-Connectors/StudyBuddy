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
exports.UserService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const user_entity_1 = require("./entities/user.entity");
const user_profile_entity_1 = require("./entities/user-profile.entity");
const user_stat_entity_1 = require("./entities/user-stat.entity");
let UserService = class UserService {
    constructor(userRepository, profileRepository, statsRepository) {
        this.userRepository = userRepository;
        this.profileRepository = profileRepository;
        this.statsRepository = statsRepository;
    }
    async findById(id) {
        return this.userRepository.findOne({
            where: { id },
            relations: ['profile', 'stats'],
        });
    }
    async getProfile(userId) {
        const user = await this.userRepository.findOne({
            where: { id: userId },
            relations: ['profile', 'stats'],
        });
        if (!user) {
            throw new common_1.NotFoundException('User not found');
        }
        return {
            id: user.id,
            email: user.email,
            name: user.name,
            role: user.role,
            schoolName: user.schoolName,
            gradeLevel: user.gradeLevel,
            profileImageUrl: user.profileImageUrl,
            profile: user.profile,
            stats: user.stats,
        };
    }
    async updateProfile(userId, updateUserDto) {
        const user = await this.userRepository.findOne({ where: { id: userId } });
        if (!user) {
            throw new common_1.NotFoundException('User not found');
        }
        if (updateUserDto.name)
            user.name = updateUserDto.name;
        if (updateUserDto.schoolName)
            user.schoolName = updateUserDto.schoolName;
        if (updateUserDto.gradeLevel)
            user.gradeLevel = updateUserDto.gradeLevel;
        if (updateUserDto.profileImageUrl)
            user.profileImageUrl = updateUserDto.profileImageUrl;
        await this.userRepository.save(user);
        let profile = await this.profileRepository.findOne({ where: { userId } });
        if (!profile) {
            profile = this.profileRepository.create({ userId });
        }
        if (updateUserDto.phoneNumber)
            profile.phoneNumber = updateUserDto.phoneNumber;
        if (updateUserDto.dateOfBirth)
            profile.dateOfBirth = new Date(updateUserDto.dateOfBirth);
        if (updateUserDto.gender)
            profile.gender = updateUserDto.gender;
        if (updateUserDto.address)
            profile.address = updateUserDto.address;
        if (updateUserDto.city)
            profile.city = updateUserDto.city;
        if (updateUserDto.province)
            profile.province = updateUserDto.province;
        if (updateUserDto.postalCode)
            profile.postalCode = updateUserDto.postalCode;
        if (updateUserDto.parentName)
            profile.parentName = updateUserDto.parentName;
        if (updateUserDto.parentPhone)
            profile.parentPhone = updateUserDto.parentPhone;
        if (updateUserDto.learningStyle)
            profile.learningStyle = updateUserDto.learningStyle;
        await this.profileRepository.save(profile);
        return this.getProfile(userId);
    }
    async getStats(userId) {
        let stats = await this.statsRepository.findOne({ where: { userId } });
        if (!stats) {
            stats = this.statsRepository.create({
                userId,
                xp: 0,
                level: 1,
                quizzesCompleted: 0,
                quizzesPassed: 0,
                averageScore: 0,
                studyStreakDays: 0,
                totalStudyMinutes: 0,
                badges: [],
            });
            await this.statsRepository.save(stats);
        }
        return stats;
    }
    async addXp(userId, xpAmount) {
        let stats = await this.statsRepository.findOne({ where: { userId } });
        if (!stats) {
            stats = this.statsRepository.create({
                userId,
                xp: 0,
                level: 1,
                quizzesCompleted: 0,
                quizzesPassed: 0,
                averageScore: 0,
                studyStreakDays: 0,
                totalStudyMinutes: 0,
                badges: [],
            });
        }
        stats.xp += xpAmount;
        const newLevel = Math.floor(Math.sqrt(stats.xp / 100)) + 1;
        if (newLevel > stats.level) {
            stats.level = newLevel;
        }
        await this.statsRepository.save(stats);
        return stats;
    }
    async updateQuizStats(userId, score, passed) {
        let stats = await this.statsRepository.findOne({ where: { userId } });
        if (!stats) {
            stats = this.statsRepository.create({
                userId,
                xp: 0,
                level: 1,
                quizzesCompleted: 0,
                quizzesPassed: 0,
                averageScore: 0,
                studyStreakDays: 0,
                totalStudyMinutes: 0,
                badges: [],
            });
        }
        stats.quizzesCompleted += 1;
        if (passed) {
            stats.quizzesPassed += 1;
        }
        const totalScore = stats.averageScore * (stats.quizzesCompleted - 1) + score;
        stats.averageScore = totalScore / stats.quizzesCompleted;
        await this.statsRepository.save(stats);
        return stats;
    }
};
exports.UserService = UserService;
exports.UserService = UserService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(user_entity_1.User)),
    __param(1, (0, typeorm_1.InjectRepository)(user_profile_entity_1.UserProfile)),
    __param(2, (0, typeorm_1.InjectRepository)(user_stat_entity_1.UserStat)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        typeorm_2.Repository,
        typeorm_2.Repository])
], UserService);
//# sourceMappingURL=user.service.js.map