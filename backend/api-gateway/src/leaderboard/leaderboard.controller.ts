import { Controller, Get, Query, UseGuards, Request } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';

import { LeaderboardService } from './leaderboard.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@ApiTags('Leaderboard')
@Controller('leaderboard')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class LeaderboardController {
  constructor(private leaderboardService: LeaderboardService) {}

  @Get()
  @ApiOperation({ summary: 'Get all-time leaderboard' })
  async getLeaderboard(@Query('limit') limit: number = 50) {
    return this.leaderboardService.getLeaderboard('alltime', limit);
  }

  @Get('weekly')
  @ApiOperation({ summary: 'Get weekly leaderboard' })
  async getWeeklyLeaderboard(@Query('limit') limit: number = 50) {
    return this.leaderboardService.getLeaderboard('weekly', limit);
  }

  @Get('monthly')
  @ApiOperation({ summary: 'Get monthly leaderboard' })
  async getMonthlyLeaderboard(@Query('limit') limit: number = 50) {
    return this.leaderboardService.getLeaderboard('monthly', limit);
  }

  @Get('rank')
  @ApiOperation({ summary: 'Get user rank' })
  async getUserRank(@Request() req) {
    return this.leaderboardService.getUserRank(req.user.userId);
  }

  @Get('friends')
  @ApiOperation({ summary: 'Get friends leaderboard' })
  async getFriendsLeaderboard(@Request() req, @Query('limit') limit: number = 20) {
    return this.leaderboardService.getFriendsLeaderboard(req.user.userId, limit);
  }
}
