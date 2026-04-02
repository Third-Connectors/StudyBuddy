import { Controller, Get, Post, Delete, Body, Param, Query, UseGuards, Request } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';

import { TutorService } from './tutor.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@ApiTags('AI Tutor')
@Controller('tutor')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class TutorController {
  constructor(private tutorService: TutorService) {}

  @Post('chat')
  @ApiOperation({ summary: 'Send message to AI tutor' })
  async chat(
    @Request() req,
    @Body('sessionId') sessionId: string,
    @Body('message') message: string,
    @Body('subject') subject?: string,
  ) {
    return this.tutorService.chat(req.user.userId, sessionId, message, subject);
  }

  @Post('sessions')
  @ApiOperation({ summary: 'Create new tutor session' })
  async createSession(
    @Request() req,
    @Body('title') title: string,
    @Body('subject') subject: string,
  ) {
    return this.tutorService.createSession(req.user.userId, title, subject);
  }

  @Get('sessions')
  @ApiOperation({ summary: 'Get user tutor sessions' })
  async getSessions(@Request() req) {
    return this.tutorService.getSessions(req.user.userId);
  }

  @Get('sessions/:sessionId')
  @ApiOperation({ summary: 'Get session by ID' })
  async getSessionById(@Param('sessionId') sessionId: string) {
    return this.tutorService.getSessionById(sessionId);
  }

  @Delete('sessions/:sessionId')
  @ApiOperation({ summary: 'Delete session' })
  async deleteSession(@Param('sessionId') sessionId: string) {
    return this.tutorService.deleteSession(sessionId);
  }
}
