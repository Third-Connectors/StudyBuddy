import { Repository } from 'typeorm';
import { Model } from 'mongoose';
import { UserStat } from '../user/entities/user-stat.entity';
export declare class LeaderboardService {
    private statsRepository;
    private leaderboardModel;
    constructor(statsRepository: Repository<UserStat>, leaderboardModel: Model<any>);
    getLeaderboard(timeframe?: string, limit?: number): Promise<{
        entries: any;
    }>;
    getUserRank(userId: string): Promise<{
        rank: number;
    }>;
    getFriendsLeaderboard(userId: string, limit?: number): Promise<{
        entries: any;
    }>;
}
