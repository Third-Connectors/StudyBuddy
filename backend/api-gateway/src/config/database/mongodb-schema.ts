// ════════════════════════════════════════════════════════════════════════════
// Study Buddy - MongoDB Schema (Mongoose)
// ════════════════════════════════════════════════════════════════════════════
// Database: studybuddy_content
// Purpose: Flexible schema for study materials, quizzes, AI content
// ════════════════════════════════════════════════════════════════════════════

import mongoose, { Schema, Document } from 'mongoose';

// ── Study Materials ─────────────────────────────────────────────────────────
export interface IStudyMaterial extends Document {
  title: string;
  subject: string;
  subjectCode: string;
  gradeLevel: string;
  content: string;
  contentType: 'text' | 'video' | 'pdf' | 'interactive';
  thumbnailUrl?: string;
  mediaUrl?: string;
  tags: string[];
  difficulty: 'easy' | 'medium' | 'hard';
  estimatedMinutes: number;
  vakStyles: ('visual' | 'auditory' | 'kinesthetic')[];
  views: number;
  likes: number;
  isPublished: boolean;
  publishedAt?: Date;
  createdAt: Date;
  updatedAt: Date;
}

const StudyMaterialSchema = new Schema<IStudyMaterial>({
  title: { type: String, required: true, index: true },
  subject: { type: String, required: true, index: true },
  subjectCode: { type: String, required: true },
  gradeLevel: { type: String, required: true, index: true },
  content: { type: String, required: true },
  contentType: {
    type: String,
    enum: ['text', 'video', 'pdf', 'interactive'],
    required: true
  },
  thumbnailUrl: String,
  mediaUrl: String,
  tags: [String],
  difficulty: {
    type: String,
    enum: ['easy', 'medium', 'hard'],
    default: 'medium'
  },
  estimatedMinutes: { type: Number, default: 30 },
  vakStyles: [{
    type: String,
    enum: ['visual', 'auditory', 'kinesthetic']
  }],
  views: { type: Number, default: 0 },
  likes: { type: Number, default: 0 },
  isPublished: { type: Boolean, default: false, index: true },
  publishedAt: Date,
}, {
  timestamps: true,
});

StudyMaterialSchema.index({ subject: 1, gradeLevel: 1, difficulty: 1 });
StudyMaterialSchema.index({ tags: 1 });

export const StudyMaterial = mongoose.model<IStudyMaterial>(
  'StudyMaterial',
  StudyMaterialSchema,
);

// ── Quiz Bank ───────────────────────────────────────────────────────────────
export interface IQuiz extends Document {
  title: string;
  subject: string;
  subjectCode: string;
  gradeLevel: string;
  description: string;
  difficulty: 'easy' | 'medium' | 'hard';
  questionCount: number;
  durationMinutes: number;
  xpReward: number;
  questions: IQuizQuestion[];
  tags: string[];
  vakStyles: ('visual' | 'auditory' | 'kinesthetic')[];
  isPublished: boolean;
  attempts: number;
  averageScore: number;
  createdAt: Date;
  updatedAt: Date;
}

export interface IQuizQuestion {
  id: string;
  question: string;
  options: string[];
  correctIndex: number;
  explanation: string;
  imageUrl?: string;
  points: number;
}

const QuizQuestionSchema = new Schema({
  id: { type: String, required: true },
  question: { type: String, required: true },
  options: { type: [String], required: true },
  correctIndex: { type: Number, required: true },
  explanation: { type: String, required: true },
  imageUrl: String,
  points: { type: Number, default: 10 },
}, { _id: false });

const QuizSchema = new Schema<IQuiz>({
  title: { type: String, required: true, index: true },
  subject: { type: String, required: true, index: true },
  subjectCode: { type: String, required: true },
  gradeLevel: { type: String, required: true, index: true },
  description: { type: String, required: true },
  difficulty: {
    type: String,
    enum: ['easy', 'medium', 'hard'],
    required: true,
    index: true
  },
  questionCount: { type: Number, required: true },
  durationMinutes: { type: Number, required: true },
  xpReward: { type: Number, required: true },
  questions: { type: [QuizQuestionSchema], required: true },
  tags: [String],
  vakStyles: [{
    type: String,
    enum: ['visual', 'auditory', 'kinesthetic']
  }],
  isPublished: { type: Boolean, default: false, index: true },
  attempts: { type: Number, default: 0 },
  averageScore: { type: Number, default: 0 },
}, {
  timestamps: true,
});

QuizSchema.index({ subject: 1, difficulty: 1 });
QuizSchema.index({ tags: 1 });

export const Quiz = mongoose.model<IQuiz>('Quiz', QuizSchema);

// ── Quiz Results ────────────────────────────────────────────────────────────
export interface IQuizResult extends Document {
  quizId: string;
  userId: string;
  answers: number[];
  correctCount: number;
  score: number;
  xpEarned: number;
  timeSpentSeconds: number;
  completedAt: Date;
  feedback?: string;
}

const QuizResultSchema = new Schema<IQuizResult>({
  quizId: { type: String, required: true, index: true },
  userId: { type: String, required: true, index: true },
  answers: { type: [Number], required: true },
  correctCount: { type: Number, required: true },
  score: { type: Number, required: true },
  xpEarned: { type: Number, required: true },
  timeSpentSeconds: { type: Number, required: true },
  completedAt: { type: Date, default: Date.now },
  feedback: String,
});

QuizResultSchema.index({ userId: 1, completedAt: -1 });
QuizResultSchema.index({ quizId: 1, userId: 1 });

export const QuizResult = mongoose.model<IQuizResult>(
  'QuizResult',
  QuizResultSchema,
);

// ── Tutor Sessions (LLM Interactions) ──────────────────────────────────────
export interface ITutorSession extends Document {
  userId: string;
  title: string;
  subject: string;
  messages: ITutorMessage[];
  isActive: boolean;
  createdAt: Date;
  lastMessageAt: Date;
}

export interface ITutorMessage {
  id: string;
  content: string;
  isUser: boolean;
  timestamp: Date;
  imageUrl?: string;
  metadata?: Record<string, any>;
}

const TutorMessageSchema = new Schema({
  id: { type: String, required: true },
  content: { type: String, required: true },
  isUser: { type: Boolean, required: true },
  timestamp: { type: Date, default: Date.now },
  imageUrl: String,
  metadata: Schema.Types.Mixed,
}, { _id: false });

const TutorSessionSchema = new Schema<ITutorSession>({
  userId: { type: String, required: true, index: true },
  title: { type: String, required: true },
  subject: { type: String, required: true, index: true },
  messages: { type: [TutorMessageSchema], default: [] },
  isActive: { type: Boolean, default: true, index: true },
  createdAt: { type: Date, default: Date.now },
  lastMessageAt: { type: Date, default: Date.now },
});

TutorSessionSchema.index({ userId: 1, lastMessageAt: -1 });

export const TutorSession = mongoose.model<ITutorSession>(
  'TutorSession',
  TutorSessionSchema,
);

// ── Schedule Entries ────────────────────────────────────────────────────────
export interface IScheduleEntry extends Document {
  userId: string;
  subject: string;
  subjectCode: string;
  startTime: Date;
  endTime: Date;
  location?: string;
  notes?: string;
  isRecurring: boolean;
  recurringDays: string[]; // MON, TUE, WED, THU, FRI, SAT
  isSchoolSchedule: boolean;
  isStudySchedule: boolean;
  source: 'manual' | 'ocr' | 'ai_generated';
  createdAt: Date;
  updatedAt: Date;
}

const ScheduleEntrySchema = new Schema<IScheduleEntry>({
  userId: { type: String, required: true, index: true },
  subject: { type: String, required: true },
  subjectCode: { type: String, required: true },
  startTime: { type: Date, required: true },
  endTime: { type: Date, required: true },
  location: String,
  notes: String,
  isRecurring: { type: Boolean, default: false },
  recurringDays: [{
    type: String,
    enum: ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT']
  }],
  isSchoolSchedule: { type: Boolean, default: false },
  isStudySchedule: { type: Boolean, default: false },
  source: {
    type: String,
    enum: ['manual', 'ocr', 'ai_generated'],
    default: 'manual'
  },
}, {
  timestamps: true,
});

ScheduleEntrySchema.index({ userId: 1, startTime: 1 });
ScheduleEntrySchema.index({ isRecurring: 1, recurringDays: 1 });

export const ScheduleEntry = mongoose.model<IScheduleEntry>(
  'ScheduleEntry',
  ScheduleEntrySchema,
);

// ── OCR Scans (Schedule Scans) ─────────────────────────────────────────────
export interface IOcrScan extends Document {
  userId: string;
  imageUrl: string;
  rawText: string;
  extractedSchedules: any[];
  processedAt: Date;
  confidence: number;
}

const OcrScanSchema = new Schema<IOcrScan>({
  userId: { type: String, required: true, index: true },
  imageUrl: { type: String, required: true },
  rawText: { type: String, required: true },
  extractedSchedules: { type: [Schema.Types.Mixed], default: [] } as any,
  processedAt: { type: Date, default: Date.now },
  confidence: { type: Number, default: 0 },
});

OcrScanSchema.index({ userId: 1, processedAt: -1 });

export const OcrScan = mongoose.model<IOcrScan>('OcrScan', OcrScanSchema);

// ── Leaderboard Cache (for fast access) ────────────────────────────────────
export interface ILeaderboardCache extends Document {
  timeframe: 'daily' | 'weekly' | 'monthly' | 'alltime';
  entries: ILeaderboardEntry[];
  generatedAt: Date;
  expiresAt: Date;
}

export interface ILeaderboardEntry {
  rank: number;
  userId: string;
  userName: string;
  schoolName: string;
  xp: number;
  level: number;
}

const LeaderboardEntrySchema = new Schema({
  rank: { type: Number, required: true },
  userId: { type: String, required: true, index: true },
  userName: { type: String, required: true },
  schoolName: { type: String, required: true },
  xp: { type: Number, required: true },
  level: { type: Number, required: true },
}, { _id: false });

const LeaderboardCacheSchema = new Schema<ILeaderboardCache>({
  timeframe: {
    type: String,
    enum: ['daily', 'weekly', 'monthly', 'alltime'],
    required: true,
    index: true
  },
  entries: { type: [LeaderboardEntrySchema], required: true },
  generatedAt: { type: Date, default: Date.now },
  expiresAt: { type: Date, required: true },
});

LeaderboardCacheSchema.index({ timeframe: 1, expiresAt: 1 });

export const LeaderboardCache = mongoose.model<ILeaderboardCache>(
  'LeaderboardCache',
  LeaderboardCacheSchema,
);
