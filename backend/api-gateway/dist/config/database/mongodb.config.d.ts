import { ConfigService } from '@nestjs/config';
export declare const mongooseConfig: {
    inject: (typeof ConfigService)[];
    useFactory: (configService: ConfigService) => {
        uri: string;
    };
};
