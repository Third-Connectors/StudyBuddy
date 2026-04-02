import { Controller, Get, Post, Body, Query, UseGuards, Request } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';

import { VakService } from './vak.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@ApiTags('VAK Assessment')
@Controller('vak')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class VakController {
  constructor(private vakService: VakService) {}

  @Get('questions')
  @ApiOperation({ summary: 'Get VAK assessment questions' })
  async getQuestions() {
    return { questions: await this.vakService.getQuestions() };
  }

  @Post('submit')
  @ApiOperation({ summary: 'Submit VAK answers and get result' })
  async submitAnswers(@Request() req, @Body('answers') answers: any[]) {
    const result = await this.vakService.submitAnswers(req.user.userId, answers);
    return { result };
  }

  @Get('result')
  @ApiOperation({ summary: 'Get user VAK result' })
  async getUserResult(@Request() req) {
    const result = await this.vakService.getUserResult(req.user.userId);
    return { result };
  }

  @Get('result/can-recalibrate')
  @ApiOperation({ summary: 'Check if user can recalibrate VAK' })
  async canRecalibrate(@Request() req) {
    const canRecalibrate = await this.vakService.canRecalibrate(req.user.userId);
    return { canRecalibrate };
  }
}
