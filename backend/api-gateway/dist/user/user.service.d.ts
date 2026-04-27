import { Repository } from 'typeorm';
import { User } from './entities/user.entity';
import { UserProfile } from './entities/user-profile.entity';
import { UserStat } from './entities/user-stat.entity';
import { UpdateUserDto } from './dto/update-user.dto';
export declare class UserService {
    private userRepository;
    private profileRepository;
    private statsRepository;
    constructor(userRepository: Repository<User>, profileRepository: Repository<UserProfile>, statsRepository: Repository<UserStat>);
    findById(id: string): Promise<User | null>;
    getProfile(userId: string): Promise<any>;
    updateProfile(userId: string, updateUserDto: UpdateUserDto): Promise<any>;
    getStats(userId: string): Promise<any>;
    addXp(userId: string, xpAmount: number): Promise<UserStat>;
    updateQuizStats(userId: string, score: number, passed: boolean): Promise<UserStat>;
}
