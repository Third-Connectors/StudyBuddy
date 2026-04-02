import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { TypeOrmModule } from '@nestjs/typeorm';

import { LeaderboardController } from './leaderboard.controller';
import { LeaderboardService } from './leaderboard.service';
import { UserStat } from '../user/entities/user-stat.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([UserStat]),
    MongooseModule.forFeature([
      { name: 'LeaderboardCache', schema: {} },
    ]),
  ],
  controllers: [LeaderboardController],
  providers: [LeaderboardService],
  exports: [LeaderboardService],
})
export class LeaderboardModule {}
