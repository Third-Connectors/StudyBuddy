import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity('vak_questions')
export class VakQuestion {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'text' })
  question: string;

  @Column({ type: 'text' })
  optionA: string;

  @Column({ type: 'text' })
  optionB: string;

  @Column({ type: 'text' })
  optionC: string;
}
