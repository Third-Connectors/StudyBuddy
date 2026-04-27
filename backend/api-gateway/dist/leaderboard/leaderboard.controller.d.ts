import { LeaderboardService } from './leaderboard.service';
export declare class LeaderboardController {
    private leaderboardService;
    constructor(leaderboardService: LeaderboardService);
    getLeaderboard(limit?: number): Promise<{
        entries: any;
    }>;
    getWeeklyLeaderboard(limit?: number): Promise<{
        entries: any;
    }>;
    getMonthlyLeaderboard(limit?: number): Promise<{
        entries: any;
    }>;
    getUserRank(req: any): Promise<{
        rank: number;
    }>;
    getFriendsLeaderboard(req: any, limit?: number): Promise<{
        entries: any;
    }>;
}
