import { VakService } from './vak.service';
export declare class VakController {
    private vakService;
    constructor(vakService: VakService);
    getQuestions(): Promise<{
        questions: import("./entities/vak-question.entity").VakQuestion[];
    }>;
    submitAnswers(req: any, answers: any[]): Promise<{
        result: import("./entities/vak-result.entity").VakResult;
    }>;
    getUserResult(req: any): Promise<{
        result: import("./entities/vak-result.entity").VakResult;
    }>;
    canRecalibrate(req: any): Promise<{
        canRecalibrate: boolean;
    }>;
}
