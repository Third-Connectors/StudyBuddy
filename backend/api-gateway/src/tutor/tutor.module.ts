import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { HttpModule } from '@nestjs/axios';

import { TutorController } from './tutor.controller';
import { TutorService } from './tutor.service';
import { TutorSession } from '../config/database/mongodb-schema';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: 'TutorSession', schema: TutorSession.schema },
    ]),
    HttpModule,
  ],
  controllers: [TutorController],
  providers: [TutorService],
  exports: [TutorService],
})
export class TutorModule {}
