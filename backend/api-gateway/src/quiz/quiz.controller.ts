import { Controller, Get, Post, Body, Param, Query, UseGuards, Request } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';

import { QuizService } from './quiz.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@ApiTags('Quiz')
@Controller('quiz')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class QuizController {
  constructor(private quizService: QuizService) {}

  @Get()
  @ApiOperation({ summary: 'Get list of quizzes' })
  async getQuizzes(@Query() filters: any) {
    return this.quizService.getQuizzes(filters);
  }

  @Get(':quizId')
  @ApiOperation({ summary: 'Get quiz by ID' })
  async getQuizById(@Param('quizId') quizId: string) {
    return this.quizService.getQuizById(quizId);
  }

  @Get(':quizId/questions')
  @ApiOperation({ summary: 'Get quiz questions' })
  async getQuizQuestions(@Param('quizId') quizId: string) {
    return this.quizService.getQuizQuestions(quizId);
  }

  @Post(':quizId/submit')
  @ApiOperation({ summary: 'Submit quiz answers' })
  async submitQuiz(
    @Request() req,
    @Param('quizId') quizId: string,
    @Body('answers') answers: number[],
    @Body('timeSpentSeconds') timeSpentSeconds: number,
  ) {
    return this.quizService.submitQuiz(quizId, req.user.userId, answers, timeSpentSeconds);
  }

  @Get('history')
  @ApiOperation({ summary: 'Get user quiz history' })
  async getQuizHistory(@Request() req) {
    return this.quizService.getQuizHistory(req.user.userId);
  }
}
