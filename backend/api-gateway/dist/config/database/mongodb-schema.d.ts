import mongoose, { Document } from 'mongoose';
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
export declare const StudyMaterial: mongoose.Model<IStudyMaterial, {}, {}, {}, mongoose.Document<unknown, {}, IStudyMaterial, {}, {}> & IStudyMaterial & Required<{
    _id: mongoose.Types.ObjectId;
}> & {
    __v: number;
}, any>;
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
export declare const Quiz: mongoose.Model<IQuiz, {}, {}, {}, mongoose.Document<unknown, {}, IQuiz, {}, {}> & IQuiz & Required<{
    _id: mongoose.Types.ObjectId;
}> & {
    __v: number;
}, any>;
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
export declare const QuizResult: mongoose.Model<IQuizResult, {}, {}, {}, mongoose.Document<unknown, {}, IQuizResult, {}, {}> & IQuizResult & Required<{
    _id: mongoose.Types.ObjectId;
}> & {
    __v: number;
}, any>;
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
export declare const TutorSession: mongoose.Model<ITutorSession, {}, {}, {}, mongoose.Document<unknown, {}, ITutorSession, {}, {}> & ITutorSession & Required<{
    _id: mongoose.Types.ObjectId;
}> & {
    __v: number;
}, any>;
export interface IScheduleEntry extends Document {
    userId: string;
    subject: string;
    subjectCode: string;
    startTime: Date;
    endTime: Date;
    location?: string;
    notes?: string;
    isRecurring: boolean;
    recurringDays: string[];
    isSchoolSchedule: boolean;
    isStudySchedule: boolean;
    source: 'manual' | 'ocr' | 'ai_generated';
    createdAt: Date;
    updatedAt: Date;
}
export declare const ScheduleEntry: mongoose.Model<IScheduleEntry, {}, {}, {}, mongoose.Document<unknown, {}, IScheduleEntry, {}, {}> & IScheduleEntry & Required<{
    _id: mongoose.Types.ObjectId;
}> & {
    __v: number;
}, any>;
export interface IOcrScan extends Document {
    userId: string;
    imageUrl: string;
    rawText: string;
    extractedSchedules: any[];
    processedAt: Date;
    confidence: number;
}
export declare const OcrScan: mongoose.Model<IOcrScan, {}, {}, {}, mongoose.Document<unknown, {}, IOcrScan, {}, {}> & IOcrScan & Required<{
    _id: mongoose.Types.ObjectId;
}> & {
    __v: number;
}, any>;
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
export declare const LeaderboardCache: mongoose.Model<ILeaderboardCache, {}, {}, {}, mongoose.Document<unknown, {}, ILeaderboardCache, {}, {}> & ILeaderboardCache & Required<{
    _id: mongoose.Types.ObjectId;
}> & {
    __v: number;
}, any>;
