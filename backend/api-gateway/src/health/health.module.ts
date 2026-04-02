import { Module } from '@nestjs/common';
import { TerminusModule } from '@nestjs/terminus';
import { TypeOrmModule } from '@nestjs/typeorm';
import { MongooseModule } from '@nestjs/mongoose';
import { HealthController } from './health.controller';

@Module({
  imports: [
    TerminusModule,
    TypeOrmModule,
    MongooseModule,
  ],
  controllers: [HealthController],
})
export class HealthModule {}
