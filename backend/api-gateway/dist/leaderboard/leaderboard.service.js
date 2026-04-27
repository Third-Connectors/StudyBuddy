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
exports.LeaderboardService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const mongoose_1 = require("@nestjs/mongoose");
const mongoose_2 = require("mongoose");
const user_stat_entity_1 = require("../user/entities/user-stat.entity");
let LeaderboardService = class LeaderboardService {
    constructor(statsRepository, leaderboardModel) {
        this.statsRepository = statsRepository;
        this.leaderboardModel = leaderboardModel;
    }
    async getLeaderboard(timeframe = 'alltime', limit = 50) {
        const cached = await this.leaderboardModel.findOne({
            timeframe,
            expiresAt: { $gt: new Date() },
        });
        if (cached) {
            return { entries: cached.entries };
        }
        const stats = await this.statsRepository
            .createQueryBuilder('stats')
            .innerJoinAndSelect('stats.user', 'user')
            .orderBy('stats.xp', 'DESC')
            .take(limit)
            .getMany();
        const entries = stats.map((stat, index) => ({
            rank: index + 1,
            userId: stat.userId,
            userName: stat.user.name,
            schoolName: stat.user.schoolName || '-',
            xp: stat.xp,
            level: stat.level,
        }));
        await this.leaderboardModel.create({
            timeframe,
            entries,
            generatedAt: new Date(),
            expiresAt: new Date(Date.now() + 5 * 60 * 1000),
        });
        return { entries };
    }
    async getUserRank(userId) {
        const allStats = await this.statsRepository
            .createQueryBuilder('stats')
            .select('stats.userId')
            .addSelect('stats.xp')
            .orderBy('stats.xp', 'DESC')
            .getMany();
        const rank = allStats.findIndex(s => s.userId === userId) + 1;
        return { rank: rank > 0 ? rank : null };
    }
    async getFriendsLeaderboard(userId, limit = 20) {
        return this.getLeaderboard('alltime', limit);
    }
};
exports.LeaderboardService = LeaderboardService;
exports.LeaderboardService = LeaderboardService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(user_stat_entity_1.UserStat)),
    __param(1, (0, mongoose_1.InjectModel)('LeaderboardCache')),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        mongoose_2.Model])
], LeaderboardService);
//# sourceMappingURL=leaderboard.service.js.map