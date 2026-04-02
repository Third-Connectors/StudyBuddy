import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn } from 'typeorm';

@Entity('vak_results')
export class VakResult {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'user_id' })
  userId: string;

  @Column({ name: 'visual_score', type: 'decimal', precision: 5, scale: 4 })
  visualScore: number;

  @Column({ name: 'auditory_score', type: 'decimal', precision: 5, scale: 4 })
  auditoryScore: number;

  @Column({ name: 'kinesthetic_score', type: 'decimal', precision: 5, scale: 4 })
  kinestheticScore: number;

  @Column({ name: 'dominant_style' })
  dominantStyle: string;

  @Column({ name: 'confidence_score', type: 'decimal', precision: 5, scale: 4, nullable: true })
  confidenceScore?: number;

  @Column({ name: 'completed_at' })
  completedAt: Date;

  @Column({ type: 'jsonb' })
  answers: any;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;
}
