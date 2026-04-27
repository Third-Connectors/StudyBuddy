import { TutorService } from './tutor.service';
export declare class TutorController {
    private tutorService;
    constructor(tutorService: TutorService);
    chat(req: any, sessionId: string, message: string, subject?: string): Promise<{
        message: {
            id: string;
            content: string;
            isUser: boolean;
            timestamp: Date;
        };
    }>;
    createSession(req: any, title: string, subject: string): Promise<{
        session: import("mongoose").Document<unknown, {}, import("../config/database/mongodb-schema").ITutorSession, {}, {}> & import("../config/database/mongodb-schema").ITutorSession & Required<{
            _id: import("mongoose").Types.ObjectId;
        }> & {
            __v: number;
        };
    }>;
    getSessions(req: any): Promise<{
        sessions: (import("mongoose").Document<unknown, {}, import("../config/database/mongodb-schema").ITutorSession, {}, {}> & import("../config/database/mongodb-schema").ITutorSession & Required<{
            _id: import("mongoose").Types.ObjectId;
        }> & {
            __v: number;
        })[];
    }>;
    getSessionById(sessionId: string): Promise<{
        session: import("mongoose").Document<unknown, {}, import("../config/database/mongodb-schema").ITutorSession, {}, {}> & import("../config/database/mongodb-schema").ITutorSession & Required<{
            _id: import("mongoose").Types.ObjectId;
        }> & {
            __v: number;
        };
    }>;
    deleteSession(sessionId: string): Promise<{
        success: boolean;
    }>;
}
