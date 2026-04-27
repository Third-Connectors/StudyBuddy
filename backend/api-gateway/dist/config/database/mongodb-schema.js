"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.LeaderboardCache = exports.OcrScan = exports.ScheduleEntry = exports.TutorSession = exports.QuizResult = exports.Quiz = exports.StudyMaterial = void 0;
const mongoose_1 = require("mongoose");
const StudyMaterialSchema = new mongoose_1.Schema({
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
exports.StudyMaterial = mongoose_1.default.model('StudyMaterial', StudyMaterialSchema);
const QuizQuestionSchema = new mongoose_1.Schema({
    id: { type: String, required: true },
    question: { type: String, required: true },
    options: { type: [String], required: true },
    correctIndex: { type: Number, required: true },
    explanation: { type: String, required: true },
    imageUrl: String,
    points: { type: Number, default: 10 },
}, { _id: false });
const QuizSchema = new mongoose_1.Schema({
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
exports.Quiz = mongoose_1.default.model('Quiz', QuizSchema);
const QuizResultSchema = new mongoose_1.Schema({
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
exports.QuizResult = mongoose_1.default.model('QuizResult', QuizResultSchema);
const TutorMessageSchema = new mongoose_1.Schema({
    id: { type: String, required: true },
    content: { type: String, required: true },
    isUser: { type: Boolean, required: true },
    timestamp: { type: Date, default: Date.now },
    imageUrl: String,
    metadata: mongoose_1.Schema.Types.Mixed,
}, { _id: false });
const TutorSessionSchema = new mongoose_1.Schema({
    userId: { type: String, required: true, index: true },
    title: { type: String, required: true },
    subject: { type: String, required: true, index: true },
    messages: { type: [TutorMessageSchema], default: [] },
    isActive: { type: Boolean, default: true, index: true },
    createdAt: { type: Date, default: Date.now },
    lastMessageAt: { type: Date, default: Date.now },
});
TutorSessionSchema.index({ userId: 1, lastMessageAt: -1 });
exports.TutorSession = mongoose_1.default.model('TutorSession', TutorSessionSchema);
const ScheduleEntrySchema = new mongoose_1.Schema({
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
exports.ScheduleEntry = mongoose_1.default.model('ScheduleEntry', ScheduleEntrySchema);
const OcrScanSchema = new mongoose_1.Schema({
    userId: { type: String, required: true, index: true },
    imageUrl: { type: String, required: true },
    rawText: { type: String, required: true },
    extractedSchedules: { type: [mongoose_1.Schema.Types.Mixed], default: [] },
    processedAt: { type: Date, default: Date.now },
    confidence: { type: Number, default: 0 },
});
OcrScanSchema.index({ userId: 1, processedAt: -1 });
exports.OcrScan = mongoose_1.default.model('OcrScan', OcrScanSchema);
const LeaderboardEntrySchema = new mongoose_1.Schema({
    rank: { type: Number, required: true },
    userId: { type: String, required: true, index: true },
    userName: { type: String, required: true },
    schoolName: { type: String, required: true },
    xp: { type: Number, required: true },
    level: { type: Number, required: true },
}, { _id: false });
const LeaderboardCacheSchema = new mongoose_1.Schema({
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
exports.LeaderboardCache = mongoose_1.default.model('LeaderboardCache', LeaderboardCacheSchema);
//# sourceMappingURL=mongodb-schema.js.map