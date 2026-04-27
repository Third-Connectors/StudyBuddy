"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AppModule = void 0;
const common_1 = require("@nestjs/common");
const config_1 = require("@nestjs/config");
const typeorm_1 = require("@nestjs/typeorm");
const mongoose_1 = require("@nestjs/mongoose");
const cache_manager_1 = require("@nestjs/cache-manager");
const throttler_1 = require("@nestjs/throttler");
const postgres_config_1 = require("./config/database/postgres.config");
const mongodb_config_1 = require("./config/database/mongodb.config");
const auth_module_1 = require("./auth/auth.module");
const user_module_1 = require("./user/user.module");
const vak_module_1 = require("./vak/vak.module");
const tutor_module_1 = require("./tutor/tutor.module");
const schedule_module_1 = require("./schedule/schedule.module");
const quiz_module_1 = require("./quiz/quiz.module");
const leaderboard_module_1 = require("./leaderboard/leaderboard.module");
const health_module_1 = require("./health/health.module");
let AppModule = class AppModule {
};
exports.AppModule = AppModule;
exports.AppModule = AppModule = __decorate([
    (0, common_1.Module)({
        imports: [
            config_1.ConfigModule.forRoot({
                isGlobal: true,
                envFilePath: '.env',
            }),
            typeorm_1.TypeOrmModule.forRootAsync(postgres_config_1.postgresDataSourceOptions),
            mongoose_1.MongooseModule.forRootAsync(mongodb_config_1.mongooseConfig),
            cache_manager_1.CacheModule.register({
                isGlobal: true,
                ttl: 300,
            }),
            throttler_1.ThrottlerModule.forRootAsync({
                useFactory: async (configService) => ({
                    ttl: configService.get('THROTTLE_TTL', 60),
                    limit: configService.get('THROTTLE_LIMIT', 10),
                }),
                inject: [config_1.ConfigService],
            }),
            auth_module_1.AuthModule,
            user_module_1.UserModule,
            vak_module_1.VakModule,
            tutor_module_1.TutorModule,
            schedule_module_1.ScheduleModule,
            quiz_module_1.QuizModule,
            leaderboard_module_1.LeaderboardModule,
            health_module_1.HealthModule,
        ],
    })
], AppModule);
//# sourceMappingURL=app.module.js.map