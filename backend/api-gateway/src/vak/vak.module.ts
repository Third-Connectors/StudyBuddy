import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { HttpModule } from '@nestjs/axios';

import { VakController } from './vak.controller';
import { VakService } from './vak.service';
import { VakResult } from './entities/vak-result.entity';
import { VakQuestion } from './entities/vak-question.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([VakResult, VakQuestion]),
    HttpModule,
  ],
  controllers: [VakController],
  providers: [VakService],
  exports: [VakService],
})
export class VakModule {}
