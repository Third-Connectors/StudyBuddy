import { User } from './user.entity';
export declare class UserStat {
    id: string;
    userId: string;
    user: User;
    xp: number;
    level: number;
    quizzesCompleted: number;
    quizzesPassed: number;
    averageScore: number;
    studyStreakDays: number;
    totalStudyMinutes: number;
    badges: string[];
    createdAt: Date;
    updatedAt: Date;
}
