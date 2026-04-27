import { UserService } from './user.service';
import { UpdateUserDto } from './dto/update-user.dto';
export declare class UserController {
    private userService;
    constructor(userService: UserService);
    getProfile(req: any): Promise<any>;
    updateProfile(req: any, updateUserDto: UpdateUserDto): Promise<any>;
    getStats(req: any): Promise<any>;
    getUserById(id: string): Promise<import("./entities/user.entity").User>;
}
