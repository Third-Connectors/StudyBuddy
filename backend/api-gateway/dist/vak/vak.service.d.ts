import { Repository } from 'typeorm';
import { HttpService } from '@nestjs/axios';
import { ConfigService } from '@nestjs/config';
import { VakResult } from './entities/vak-result.entity';
import { VakQuestion } from './entities/vak-question.entity';
export declare class VakService {
    private vakRepository;
    private vakQuestionRepository;
    private httpService;
    private configService;
    constructor(vakRepository: Repository<VakResult>, vakQuestionRepository: Repository<VakQuestion>, httpService: HttpService, configService: ConfigService);
    getQuestions(): Promise<VakQuestion[]>;
    seedQuestions(): Promise<void>;
    submitAnswers(userId: string, answers: any[]): Promise<VakResult>;
    getUserResult(userId: string): Promise<VakResult | null>;
    canRecalibrate(userId: string): Promise<boolean>;
    private _calculateResultLocally;
    private _getMonthsDifference;
    private _getHardcodedQuestions;
}
