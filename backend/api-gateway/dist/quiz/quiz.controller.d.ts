import { QuizService } from './quiz.service';
export declare class QuizController {
    private quizService;
    constructor(quizService: QuizService);
    getQuizzes(filters: any): Promise<{
        quizzes: any[];
    }>;
    getQuizById(quizId: string): Promise<{
        quiz: any;
    }>;
    getQuizQuestions(quizId: string): Promise<{
        questions: any;
    }>;
    submitQuiz(req: any, quizId: string, answers: number[], timeSpentSeconds: number): Promise<{
        result: any;
    }>;
    getQuizHistory(req: any): Promise<{
        results: any[];
    }>;
}
