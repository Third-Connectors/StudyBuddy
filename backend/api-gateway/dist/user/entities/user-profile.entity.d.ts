import { User } from './user.entity';
export declare class UserProfile {
    id: string;
    userId: string;
    user: User;
    phoneNumber?: string;
    dateOfBirth?: Date;
    gender?: string;
    address?: string;
    city?: string;
    province?: string;
    postalCode?: string;
    parentName?: string;
    parentPhone?: string;
    learningStyle?: string;
    createdAt: Date;
    updatedAt: Date;
}
