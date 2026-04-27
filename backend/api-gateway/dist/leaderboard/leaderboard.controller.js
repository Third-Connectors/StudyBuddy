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
exports.LeaderboardController = void 0;
const common_1 = require("@nestjs/common");
const swagger_1 = require("@nestjs/swagger");
const leaderboard_service_1 = require("./leaderboard.service");
const jwt_auth_guard_1 = require("../auth/guards/jwt-auth.guard");
let LeaderboardController = class LeaderboardController {
    constructor(leaderboardService) {
        this.leaderboardService = leaderboardService;
    }
    async getLeaderboard(limit = 50) {
        return this.leaderboardService.getLeaderboard('alltime', limit);
    }
    async getWeeklyLeaderboard(limit = 50) {
        return this.leaderboardService.getLeaderboard('weekly', limit);
    }
    async getMonthlyLeaderboard(limit = 50) {
        return this.leaderboardService.getLeaderboard('monthly', limit);
    }
    async getUserRank(req) {
        return this.leaderboardService.getUserRank(req.user.userId);
    }
    async getFriendsLeaderboard(req, limit = 20) {
        return this.leaderboardService.getFriendsLeaderboard(req.user.userId, limit);
    }
};
exports.LeaderboardController = LeaderboardController;
__decorate([
    (0, common_1.Get)(),
    (0, swagger_1.ApiOperation)({ summary: 'Get all-time leaderboard' }),
    __param(0, (0, common_1.Query)('limit')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number]),
    __metadata("design:returntype", Promise)
], LeaderboardController.prototype, "getLeaderboard", null);
__decorate([
    (0, common_1.Get)('weekly'),
    (0, swagger_1.ApiOperation)({ summary: 'Get weekly leaderboard' }),
    __param(0, (0, common_1.Query)('limit')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number]),
    __metadata("design:returntype", Promise)
], LeaderboardController.prototype, "getWeeklyLeaderboard", null);
__decorate([
    (0, common_1.Get)('monthly'),
    (0, swagger_1.ApiOperation)({ summary: 'Get monthly leaderboard' }),
    __param(0, (0, common_1.Query)('limit')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number]),
    __metadata("design:returntype", Promise)
], LeaderboardController.prototype, "getMonthlyLeaderboard", null);
__decorate([
    (0, common_1.Get)('rank'),
    (0, swagger_1.ApiOperation)({ summary: 'Get user rank' }),
    __param(0, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], LeaderboardController.prototype, "getUserRank", null);
__decorate([
    (0, common_1.Get)('friends'),
    (0, swagger_1.ApiOperation)({ summary: 'Get friends leaderboard' }),
    __param(0, (0, common_1.Request)()),
    __param(1, (0, common_1.Query)('limit')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, Number]),
    __metadata("design:returntype", Promise)
], LeaderboardController.prototype, "getFriendsLeaderboard", null);
exports.LeaderboardController = LeaderboardController = __decorate([
    (0, swagger_1.ApiTags)('Leaderboard'),
    (0, common_1.Controller)('leaderboard'),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard),
    (0, swagger_1.ApiBearerAuth)(),
    __metadata("design:paramtypes", [leaderboard_service_1.LeaderboardService])
], LeaderboardController);
//# sourceMappingURL=leaderboard.controller.js.map