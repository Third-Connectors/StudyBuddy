import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn, OneToOne, JoinColumn } from 'typeorm';

import { UserProfile } from './user-profile.entity';
import { UserStat } from './user-stat.entity';

export enum UserRole {
  STUDENT = 'student',
  TEACHER = 'teacher',
  PARENT = 'parent',
  ADMIN = 'admin',
}

@Entity('app_users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ unique: true })
  email: string;

  @Column({ name: 'password_hash' })
  passwordHash: string;

  @Column()
  name: string;

  @Column({ type: 'enum', enum: UserRole, default: UserRole.STUDENT })
  role: UserRole;

  @Column({ name: 'school_name', nullable: true })
  schoolName?: string;

  @Column({ name: 'grade_level', nullable: true })
  gradeLevel?: string;

  @Column({ name: 'profile_image_url', nullable: true })
  profileImageUrl?: string;

  @Column({ name: 'email_verified', default: false })
  emailVerified: boolean;

  @Column({ name: 'is_active', default: true })
  isActive: boolean;

  @Column({ name: 'last_login_at', nullable: true })
  lastLoginAt?: Date;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;

  // Relations
  @OneToOne(() => UserProfile, (profile) => profile.user)
  profile?: UserProfile;

  @OneToOne(() => UserStat, (stats) => stats.user)
  stats?: UserStat;
}
