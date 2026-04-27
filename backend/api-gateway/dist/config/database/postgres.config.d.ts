import { ConfigService } from '@nestjs/config';
import { TypeOrmOptionsFactory, TypeOrmModuleOptions } from '@nestjs/typeorm';
export declare class TypeOrmConfigService implements TypeOrmOptionsFactory {
    private configService;
    constructor(configService: ConfigService);
    createTypeOrmOptions(): TypeOrmModuleOptions;
}
export declare const postgresDataSourceOptions: {
    inject: (typeof ConfigService)[];
    useFactory: (configService: ConfigService) => {
        type: string;
        url: string;
        entities: string[];
        migrations: string[];
        synchronize: boolean;
        logging: boolean;
        ssl: {
            rejectUnauthorized: boolean;
        };
        host?: undefined;
        port?: undefined;
        username?: undefined;
        password?: undefined;
        database?: undefined;
        extra?: undefined;
    } | {
        type: string;
        host: string;
        port: number;
        username: string;
        password: string;
        database: string;
        entities: string[];
        migrations: string[];
        synchronize: boolean;
        logging: boolean;
        ssl: {
            rejectUnauthorized: boolean;
        };
        extra: {
            connectTimeout: number;
        };
        url?: undefined;
    };
};
