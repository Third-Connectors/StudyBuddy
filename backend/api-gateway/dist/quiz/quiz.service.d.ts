import { Model } from 'mongoose';
export declare class QuizService {
    private quizModel;
    private resultModel;
    constructor(quizModel: Model<any>, resultModel: Model<any>);
    getQuizzes(filters: any): Promise<{
        quizzes: any[];
    }>;
    getQuizById(quizId: string): Promise<{
        quiz: any;
    }>;
    getQuizQuestions(quizId: string): Promise<{
        questions: any;
    }>;
    submitQuiz(quizId: string, userId: string, answers: number[], timeSpentSeconds: number): Promise<{
        result: any;
    }>;
    getQuizHistory(userId: string): Promise<{
        results: any[];
    }>;
}
