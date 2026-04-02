import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn, OneToOne, JoinColumn } from 'typeorm';

import { User } from './user.entity';

@Entity('user_stats')
export class UserStat {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'user_id' })
  userId: string;

  @OneToOne(() => User, (user) => user.stats, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user: User;

  @Column({ default: 0 })
  xp: number;

  @Column({ default: 1 })
  level: number;

  @Column({ name: 'quizzes_completed', default: 0 })
  quizzesCompleted: number;

  @Column({ name: 'quizzes_passed', default: 0 })
  quizzesPassed: number;

  @Column({ name: 'average_score', type: 'decimal', precision: 5, scale: 2, default: 0 })
  averageScore: number;

  @Column({ name: 'study_streak_days', default: 0 })
  studyStreakDays: number;

  @Column({ name: 'total_study_minutes', default: 0 })
  totalStudyMinutes: number;

  @Column({ type: 'jsonb', default: [] })
  badges: string[];

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;
}
