"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.postgresDataSourceOptions = exports.TypeOrmConfigService = void 0;
const common_1 = require("@nestjs/common");
const config_1 = require("@nestjs/config");
let TypeOrmConfigService = class TypeOrmConfigService {
    constructor(configService) {
        this.configService = configService;
    }
    createTypeOrmOptions() {
        return {
            type: 'postgres',
            host: this.configService.get('POSTGRES_HOST', 'localhost'),
            port: this.configService.get('POSTGRES_PORT', 5432),
            username: this.configService.get('POSTGRES_USER', 'studybuddy'),
            password: this.configService.get('POSTGRES_PASSWORD'),
            database: this.configService.get('POSTGRES_DB', 'studybuddy_users'),
            entities: [__dirname + '/../../**/*.entity{.ts,.js}'],
            migrations: [__dirname + '/migrations/*{.ts,.js}'],
            synchronize: this.configService.get('NODE_ENV') === 'development',
            logging: this.configService.get('NODE_ENV') === 'development',
            ssl: {
                rejectUnauthorized: false,
            },
            extra: {
                max: 20,
                idleTimeoutMillis: 30000,
                connectionTimeoutMillis: 10000,
            },
        };
    }
};
exports.TypeOrmConfigService = TypeOrmConfigService;
exports.TypeOrmConfigService = TypeOrmConfigService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [config_1.ConfigService])
], TypeOrmConfigService);
exports.postgresDataSourceOptions = {
    inject: [config_1.ConfigService],
    useFactory: (configService) => {
        const databaseUrl = configService.get('DATABASE_URL');
        if (databaseUrl) {
            return {
                type: 'postgres',
                url: databaseUrl,
                entities: [__dirname + '/../../**/*.entity{.ts,.js}'],
                migrations: [__dirname + '/migrations/*{.ts,.js}'],
                synchronize: configService.get('NODE_ENV') === 'development',
                logging: configService.get('NODE_ENV') === 'development',
                ssl: {
                    rejectUnauthorized: false,
                },
            };
        }
        return {
            type: 'postgres',
            host: configService.get('POSTGRES_HOST', 'localhost'),
            port: configService.get('POSTGRES_PORT', 5432),
            username: configService.get('POSTGRES_USER', 'studybuddy'),
            password: configService.get('POSTGRES_PASSWORD'),
            database: configService.get('POSTGRES_DB', 'studybuddy_users'),
            entities: [__dirname + '/../../**/*.entity{.ts,.js}'],
            migrations: [__dirname + '/migrations/*{.ts,.js}'],
            synchronize: configService.get('NODE_ENV') === 'development',
            logging: configService.get('NODE_ENV') === 'development',
            ssl: {
                rejectUnauthorized: false,
            },
            extra: {
                connectTimeout: 10000,
            },
        };
    },
};
//# sourceMappingURL=postgres.config.js.map