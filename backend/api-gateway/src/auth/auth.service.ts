import {
  Injectable,
  UnauthorizedException,
  ConflictException,
  BadRequestException,
} from "@nestjs/common";
import { JwtService } from "@nestjs/jwt";
import { InjectRepository } from "@nestjs/typeorm";
import { Repository } from "typeorm";
import * as bcrypt from "bcrypt";

import { User, UserRole } from "../user/entities/user.entity";
import { CreateUserDto } from "./dto/create-user.dto";
import { LoginDto } from "./dto/login.dto";
import { AuthResponseDto } from "./dto/auth-response.dto";

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User)
    private userRepository: Repository<User>,
    private jwtService: JwtService,
  ) {}

  /**
   * Register a new user
   */
  async register(createUserDto: CreateUserDto): Promise<AuthResponseDto> {
    // Check if user already exists
    const existingUser = await this.userRepository.findOne({
      where: { email: createUserDto.email },
    });

    if (existingUser) {
      throw new ConflictException("Email already registered");
    }

    // Hash password
    const saltRounds = 10;
    const passwordHash = await bcrypt.hash(createUserDto.password, saltRounds);

    // Create user
    const user = this.userRepository.create({
      email: createUserDto.email,
      passwordHash,
      name: createUserDto.name,
      role: UserRole.STUDENT,
      schoolName: createUserDto.schoolName,
      gradeLevel: createUserDto.gradeLevel,
      emailVerified: false,
    });

    await this.userRepository.save(user);

    // Generate tokens
    const tokens = await this.generateTokens(user);

    return {
      user: this.sanitizeUser(user),
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    };
  }

  /**
   * Login user
   */
  async login(loginDto: LoginDto): Promise<AuthResponseDto> {
    // Find user by email
    const user = await this.userRepository.findOne({
      where: { email: loginDto.email },
    });

    if (!user) {
      throw new UnauthorizedException("Invalid email or password");
    }

    // Verify password
    const isPasswordValid = await bcrypt.compare(
      loginDto.password,
      user.passwordHash,
    );

    if (!isPasswordValid) {
      throw new UnauthorizedException("Invalid email or password");
    }

    // Check if user is active
    if (!user.isActive) {
      throw new UnauthorizedException("Account is deactivated");
    }

    // Update last login
    user.lastLoginAt = new Date();
    await this.userRepository.save(user);

    // Generate tokens
    const tokens = await this.generateTokens(user);

    return {
      user: this.sanitizeUser(user),
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    };
  }

  /**
   * Logout user (revoke refresh token)
   */
  async logout(userId: string): Promise<void> {
    // TODO: Add refresh token revocation logic
    // For now, client just clears tokens locally
  }

  /**
   * Refresh access token
   */
  async refreshToken(
    refreshToken: string,
  ): Promise<{ accessToken: string; refreshToken: string }> {
    try {
      // Verify refresh token
      const payload = this.jwtService.verify(refreshToken, {
        secret: process.env.JWT_REFRESH_SECRET,
      });

      // Find user
      const user = await this.userRepository.findOne({
        where: { id: payload.sub },
      });

      if (!user) {
        throw new UnauthorizedException("User not found");
      }

      // Generate new tokens
      const tokens = await this.generateTokens(user);

      return tokens;
    } catch (error) {
      throw new UnauthorizedException("Invalid refresh token");
    }
  }

  /**
   * Forgot password - send reset email
   */
  async forgotPassword(email: string): Promise<void> {
    const user = await this.userRepository.findOne({ where: { email } });

    if (!user) {
      // Don't reveal if user exists
      return;
    }

    // TODO: Generate password reset token and send email
    // For now, just log
    console.log(`Password reset requested for: ${email}`);
  }

  /**
   * Validate user for JWT strategy
   */
  async validateUser(userId: string): Promise<any> {
    const user = await this.userRepository.findOne({
      where: { id: userId },
      select: ["id", "email", "name", "role", "isActive"],
    });

    if (!user || !user.isActive) {
      throw new UnauthorizedException("User not found or inactive");
    }

    return user;
  }

  /**
   * Generate JWT tokens
   */
  private async generateTokens(user: User) {
    const [accessToken, refreshToken] = await Promise.all([
      this.jwtService.signAsync(
        {
          sub: user.id,
          email: user.email,
          role: user.role,
        },
        {
          secret: process.env.JWT_SECRET,
          expiresIn: process.env.JWT_EXPIRATION || "15m",
        },
      ),
      this.jwtService.signAsync(
        {
          sub: user.id,
        },
        {
          secret: process.env.JWT_REFRESH_SECRET,
          expiresIn: process.env.JWT_REFRESH_EXPIRATION || "7d",
        },
      ),
    ]);

    return { accessToken, refreshToken };
  }

  /**
   * Validate user for local strategy (email/password)
   */
  async validateUserForLocal(email: string, password: string): Promise<any> {
    const user = await this.userRepository.findOne({
      where: { email },
      select: ["id", "email", "passwordHash", "name", "role", "isActive"],
    });

    if (user && (await bcrypt.compare(password, user.passwordHash))) {
      if (!user.isActive) {
        throw new UnauthorizedException("Account is deactivated");
      }
      const { passwordHash, ...result } = user;
      return result;
    }

    return null;
  }

  /**
   * Remove sensitive data from user object
   */
  private sanitizeUser(user: User): any {
    const { passwordHash, ...result } = user;
    return result;
  }
}
