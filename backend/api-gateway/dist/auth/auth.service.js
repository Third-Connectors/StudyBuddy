"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AuthService = void 0;
const common_1 = require("@nestjs/common");
const jwt_1 = require("@nestjs/jwt");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const bcrypt = require("bcrypt");
const user_entity_1 = require("../user/entities/user.entity");
let AuthService = class AuthService {
    constructor(userRepository, jwtService) {
        this.userRepository = userRepository;
        this.jwtService = jwtService;
    }
    async register(createUserDto) {
        const existingUser = await this.userRepository.findOne({
            where: { email: createUserDto.email },
        });
        if (existingUser) {
            throw new common_1.ConflictException("Email already registered");
        }
        const saltRounds = 10;
        const passwordHash = await bcrypt.hash(createUserDto.password, saltRounds);
        const user = this.userRepository.create({
            email: createUserDto.email,
            passwordHash,
            name: createUserDto.name,
            role: user_entity_1.UserRole.STUDENT,
            schoolName: createUserDto.schoolName,
            gradeLevel: createUserDto.gradeLevel,
            emailVerified: false,
        });
        await this.userRepository.save(user);
        const tokens = await this.generateTokens(user);
        return {
            user: this.sanitizeUser(user),
            accessToken: tokens.accessToken,
            refreshToken: tokens.refreshToken,
        };
    }
    async login(loginDto) {
        const user = await this.userRepository.findOne({
            where: { email: loginDto.email },
        });
        if (!user) {
            throw new common_1.UnauthorizedException("Invalid email or password");
        }
        const isPasswordValid = await bcrypt.compare(loginDto.password, user.passwordHash);
        if (!isPasswordValid) {
            throw new common_1.UnauthorizedException("Invalid email or password");
        }
        if (!user.isActive) {
            throw new common_1.UnauthorizedException("Account is deactivated");
        }
        user.lastLoginAt = new Date();
        await this.userRepository.save(user);
        const tokens = await this.generateTokens(user);
        return {
            user: this.sanitizeUser(user),
            accessToken: tokens.accessToken,
            refreshToken: tokens.refreshToken,
        };
    }
    async logout(userId) {
    }
    async refreshToken(refreshToken) {
        try {
            const payload = this.jwtService.verify(refreshToken, {
                secret: process.env.JWT_REFRESH_SECRET,
            });
            const user = await this.userRepository.findOne({
                where: { id: payload.sub },
            });
            if (!user) {
                throw new common_1.UnauthorizedException("User not found");
            }
            const tokens = await this.generateTokens(user);
            return tokens;
        }
        catch (error) {
            throw new common_1.UnauthorizedException("Invalid refresh token");
        }
    }
    async forgotPassword(email) {
        const user = await this.userRepository.findOne({ where: { email } });
        if (!user) {
            return;
        }
        console.log(`Password reset requested for: ${email}`);
    }
    async validateUser(userId) {
        const user = await this.userRepository.findOne({
            where: { id: userId },
            select: ["id", "email", "name", "role", "isActive"],
        });
        if (!user || !user.isActive) {
            throw new common_1.UnauthorizedException("User not found or inactive");
        }
        return user;
    }
    async generateTokens(user) {
        const [accessToken, refreshToken] = await Promise.all([
            this.jwtService.signAsync({
                sub: user.id,
                email: user.email,
                role: user.role,
            }, {
                secret: process.env.JWT_SECRET,
                expiresIn: process.env.JWT_EXPIRATION || "15m",
            }),
            this.jwtService.signAsync({
                sub: user.id,
            }, {
                secret: process.env.JWT_REFRESH_SECRET,
                expiresIn: process.env.JWT_REFRESH_EXPIRATION || "7d",
            }),
        ]);
        return { accessToken, refreshToken };
    }
    async validateUserForLocal(email, password) {
        const user = await this.userRepository.findOne({
            where: { email },
            select: ["id", "email", "passwordHash", "name", "role", "isActive"],
        });
        if (user && (await bcrypt.compare(password, user.passwordHash))) {
            if (!user.isActive) {
                throw new common_1.UnauthorizedException("Account is deactivated");
            }
            const { passwordHash, ...result } = user;
            return result;
        }
        return null;
    }
    sanitizeUser(user) {
        const { passwordHash, ...result } = user;
        return result;
    }
};
exports.AuthService = AuthService;
exports.AuthService = AuthService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(user_entity_1.User)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        jwt_1.JwtService])
], AuthService);
//# sourceMappingURL=auth.service.js.map