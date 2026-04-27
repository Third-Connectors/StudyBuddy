import { UserProfile } from './user-profile.entity';
import { UserStat } from './user-stat.entity';
export declare enum UserRole {
    STUDENT = "student",
    TEACHER = "teacher",
    PARENT = "parent",
    ADMIN = "admin"
}
export declare class User {
    id: string;
    email: string;
    passwordHash: string;
    name: string;
    role: UserRole;
    schoolName?: string;
    gradeLevel?: string;
    profileImageUrl?: string;
    emailVerified: boolean;
    isActive: boolean;
    lastLoginAt?: Date;
    createdAt: Date;
    updatedAt: Date;
    profile?: UserProfile;
    stats?: UserStat;
}
