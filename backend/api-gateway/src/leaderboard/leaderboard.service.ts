import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';

import { UserStat } from '../user/entities/user-stat.entity';

@Injectable()
export class LeaderboardService {
  constructor(
    @InjectRepository(UserStat)
    private statsRepository: Repository<UserStat>,
    @InjectModel('LeaderboardCache') private leaderboardModel: Model<any>,
  ) {}

  async getLeaderboard(timeframe: string = 'alltime', limit: number = 50) {
    // Get from cache first
    const cached = await this.leaderboardModel.findOne({
      timeframe,
      expiresAt: { $gt: new Date() },
    });

    if (cached) {
      return { entries: cached.entries };
    }

    // Generate from database
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

    // Cache the result
    await this.leaderboardModel.create({
      timeframe,
      entries,
      generatedAt: new Date(),
      expiresAt: new Date(Date.now() + 5 * 60 * 1000), // 5 minutes
    });

    return { entries };
  }

  async getUserRank(userId: string) {
    const allStats = await this.statsRepository
      .createQueryBuilder('stats')
      .select('stats.userId')
      .addSelect('stats.xp')
      .orderBy('stats.xp', 'DESC')
      .getMany();

    const rank = allStats.findIndex(s => s.userId === userId) + 1;
    return { rank: rank > 0 ? rank : null };
  }

  async getFriendsLeaderboard(userId: string, limit: number = 20) {
    // TODO: Implement friends logic (requires friends table)
    // For now, return general leaderboard
    return this.getLeaderboard('alltime', limit);
  }
}
