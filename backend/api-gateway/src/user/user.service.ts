import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { User } from './entities/user.entity';
import { UserProfile } from './entities/user-profile.entity';
import { UserStat } from './entities/user-stat.entity';
import { UpdateUserDto } from './dto/update-user.dto';

@Injectable()
export class UserService {
  constructor(
    @InjectRepository(User)
    private userRepository: Repository<User>,
    @InjectRepository(UserProfile)
    private profileRepository: Repository<UserProfile>,
    @InjectRepository(UserStat)
    private statsRepository: Repository<UserStat>,
  ) {}

  /**
   * Get user by ID with profile and stats
   */
  async findById(id: string): Promise<User | null> {
    return this.userRepository.findOne({
      where: { id },
      relations: ['profile', 'stats'],
    });
  }

  /**
   * Get user profile
   */
  async getProfile(userId: string): Promise<any> {
    const user = await this.userRepository.findOne({
      where: { id: userId },
      relations: ['profile', 'stats'],
    });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    return {
      id: user.id,
      email: user.email,
      name: user.name,
      role: user.role,
      schoolName: user.schoolName,
      gradeLevel: user.gradeLevel,
      profileImageUrl: user.profileImageUrl,
      profile: user.profile,
      stats: user.stats,
    };
  }

  /**
   * Update user profile
   */
  async updateProfile(userId: string, updateUserDto: UpdateUserDto): Promise<any> {
    const user = await this.userRepository.findOne({ where: { id: userId } });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    // Update user fields
    if (updateUserDto.name) user.name = updateUserDto.name;
    if (updateUserDto.schoolName) user.schoolName = updateUserDto.schoolName;
    if (updateUserDto.gradeLevel) user.gradeLevel = updateUserDto.gradeLevel;
    if (updateUserDto.profileImageUrl) user.profileImageUrl = updateUserDto.profileImageUrl;

    await this.userRepository.save(user);

    // Update or create profile
    let profile = await this.profileRepository.findOne({ where: { userId } });

    if (!profile) {
      profile = this.profileRepository.create({ userId });
    }

    if (updateUserDto.phoneNumber) profile.phoneNumber = updateUserDto.phoneNumber;
    if (updateUserDto.dateOfBirth) profile.dateOfBirth = new Date(updateUserDto.dateOfBirth);
    if (updateUserDto.gender) profile.gender = updateUserDto.gender;
    if (updateUserDto.address) profile.address = updateUserDto.address;
    if (updateUserDto.city) profile.city = updateUserDto.city;
    if (updateUserDto.province) profile.province = updateUserDto.province;
    if (updateUserDto.postalCode) profile.postalCode = updateUserDto.postalCode;
    if (updateUserDto.parentName) profile.parentName = updateUserDto.parentName;
    if (updateUserDto.parentPhone) profile.parentPhone = updateUserDto.parentPhone;
    if (updateUserDto.learningStyle) profile.learningStyle = updateUserDto.learningStyle;

    await this.profileRepository.save(profile);

    // Get updated user with relations
    return this.getProfile(userId);
  }

  /**
   * Get user stats
   */
  async getStats(userId: string): Promise<any> {
    let stats = await this.statsRepository.findOne({ where: { userId } });

    if (!stats) {
      // Create default stats if not exists
      stats = this.statsRepository.create({
        userId,
        xp: 0,
        level: 1,
        quizzesCompleted: 0,
        quizzesPassed: 0,
        averageScore: 0,
        studyStreakDays: 0,
        totalStudyMinutes: 0,
        badges: [],
      });
      await this.statsRepository.save(stats);
    }

    return stats;
  }

  /**
   * Update user XP and level
   */
  async addXp(userId: string, xpAmount: number): Promise<UserStat> {
    let stats = await this.statsRepository.findOne({ where: { userId } });

    if (!stats) {
      stats = this.statsRepository.create({
        userId,
        xp: 0,
        level: 1,
        quizzesCompleted: 0,
        quizzesPassed: 0,
        averageScore: 0,
        studyStreakDays: 0,
        totalStudyMinutes: 0,
        badges: [],
      });
    }

    stats.xp += xpAmount;

    // Calculate level based on XP (simple formula: level = sqrt(xp / 100))
    const newLevel = Math.floor(Math.sqrt(stats.xp / 100)) + 1;
    if (newLevel > stats.level) {
      stats.level = newLevel;
      // TODO: Add level up logic (notifications, badges, etc.)
    }

    await this.statsRepository.save(stats);

    return stats;
  }

  /**
   * Update quiz stats
   */
  async updateQuizStats(userId: string, score: number, passed: boolean): Promise<UserStat> {
    let stats = await this.statsRepository.findOne({ where: { userId } });

    if (!stats) {
      stats = this.statsRepository.create({
        userId,
        xp: 0,
        level: 1,
        quizzesCompleted: 0,
        quizzesPassed: 0,
        averageScore: 0,
        studyStreakDays: 0,
        totalStudyMinutes: 0,
        badges: [],
      });
    }

    stats.quizzesCompleted += 1;
    if (passed) {
      stats.quizzesPassed += 1;
    }

    // Update average score
    const totalScore = stats.averageScore * (stats.quizzesCompleted - 1) + score;
    stats.averageScore = totalScore / stats.quizzesCompleted;

    await this.statsRepository.save(stats);

    return stats;
  }
}
