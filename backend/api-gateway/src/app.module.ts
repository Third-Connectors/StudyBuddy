import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { MongooseModule } from '@nestjs/mongoose';
import { CacheModule } from '@nestjs/cache-manager';
import { ThrottlerModule } from '@nestjs/throttler';

// Database Config
import { postgresDataSourceOptions } from './config/database/postgres.config';
import { mongooseConfig } from './config/database/mongodb.config';

// Modules
import { AuthModule } from './auth/auth.module';
import { UserModule } from './user/user.module';
import { VakModule } from './vak/vak.module';
import { TutorModule } from './tutor/tutor.module';
import { ScheduleModule } from './schedule/schedule.module';
import { QuizModule } from './quiz/quiz.module';
import { LeaderboardModule } from './leaderboard/leaderboard.module';

// Health Check
import { HealthModule } from './health/health.module';

@Module({
  imports: [
    // ── Configuration ────────────────────────────────────────────────────────
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
    }),

    // ── PostgreSQL (TypeORM) - User Data ────────────────────────────────────
    TypeOrmModule.forRootAsync({
      useFactory: postgresDataSourceOptions,
      inject: [ConfigService],
    }),

    // ── MongoDB (Mongoose) - Content ────────────────────────────────────────
    MongooseModule.forRootAsync({
      useFactory: mongooseConfig,
      inject: [ConfigService],
    }),

    // ── Redis (Cache) ───────────────────────────────────────────────────────
    CacheModule.registerAsync({
      isGlobal: true,
      useFactory: async (configService: ConfigService) => ({
        store: await import('cache-manager-redis-store'),
        host: configService.get<string>('REDIS_HOST', 'localhost'),
        port: configService.get<number>('REDIS_PORT', 6379),
        ttl: 300, // 5 minutes default
      }),
      inject: [ConfigService],
    }),

    // ── Rate Limiting ───────────────────────────────────────────────────────
    ThrottlerModule.forRootAsync({
      useFactory: async (configService: ConfigService) => ({
        ttl: configService.get<number>('THROTTLE_TTL', 60),
        limit: configService.get<number>('THROTTLE_LIMIT', 10),
      }),
      inject: [ConfigService],
    }),

    // ── Feature Modules ─────────────────────────────────────────────────────
    AuthModule,
    UserModule,
    VakModule,
    TutorModule,
    ScheduleModule,
    QuizModule,
    LeaderboardModule,
    HealthModule,
  ],
})
export class AppModule {}
