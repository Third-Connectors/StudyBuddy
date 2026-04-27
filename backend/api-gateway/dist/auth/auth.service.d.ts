import { JwtService } from "@nestjs/jwt";
import { Repository } from "typeorm";
import { User } from "../user/entities/user.entity";
import { CreateUserDto } from "./dto/create-user.dto";
import { LoginDto } from "./dto/login.dto";
import { AuthResponseDto } from "./dto/auth-response.dto";
export declare class AuthService {
    private userRepository;
    private jwtService;
    constructor(userRepository: Repository<User>, jwtService: JwtService);
    register(createUserDto: CreateUserDto): Promise<AuthResponseDto>;
    login(loginDto: LoginDto): Promise<AuthResponseDto>;
    logout(userId: string): Promise<void>;
    refreshToken(refreshToken: string): Promise<{
        accessToken: string;
        refreshToken: string;
    }>;
    forgotPassword(email: string): Promise<void>;
    validateUser(userId: string): Promise<any>;
    private generateTokens;
    validateUserForLocal(email: string, password: string): Promise<any>;
    private sanitizeUser;
}
