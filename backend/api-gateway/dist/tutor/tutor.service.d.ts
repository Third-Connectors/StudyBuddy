import { ConfigService } from '@nestjs/config';
import { Model } from 'mongoose';
import { HttpService } from '@nestjs/axios';
import { ITutorSession } from '../config/database/mongodb-schema';
export declare class TutorService {
    private sessionModel;
    private httpService;
    private configService;
    constructor(sessionModel: Model<ITutorSession>, httpService: HttpService, configService: ConfigService);
    chat(userId: string, sessionId: string, message: string, subject?: string): Promise<{
        message: {
            id: string;
            content: string;
            isUser: boolean;
            timestamp: Date;
        };
    }>;
    createSession(userId: string, title: string, subject: string): Promise<{
        session: import("mongoose").Document<unknown, {}, ITutorSession, {}, {}> & ITutorSession & Required<{
            _id: import("mongoose").Types.ObjectId;
        }> & {
            __v: number;
        };
    }>;
    getSessions(userId: string): Promise<{
        sessions: (import("mongoose").Document<unknown, {}, ITutorSession, {}, {}> & ITutorSession & Required<{
            _id: import("mongoose").Types.ObjectId;
        }> & {
            __v: number;
        })[];
    }>;
    getSessionById(sessionId: string): Promise<{
        session: import("mongoose").Document<unknown, {}, ITutorSession, {}, {}> & ITutorSession & Required<{
            _id: import("mongoose").Types.ObjectId;
        }> & {
            __v: number;
        };
    }>;
    deleteSession(sessionId: string): Promise<{
        success: boolean;
    }>;
}
