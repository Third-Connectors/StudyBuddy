import { Controller, Get, Post, Put, Delete, Body, Param, UseGuards, Request, UseInterceptors, UploadedFile } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiConsumes } from '@nestjs/swagger';

import { ScheduleService } from './schedule.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@ApiTags('Schedule Scanner')
@Controller('schedule')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class ScheduleController {
  constructor(private scheduleService: ScheduleService) {}

  @Post('upload')
  @ApiOperation({ summary: 'Upload schedule image for OCR' })
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(FileInterceptor('file'))
  async uploadSchedule(@Request() req, @UploadedFile() file: any) {
    return this.scheduleService.uploadSchedule(req.user.userId, file);
  }

  @Get()
  @ApiOperation({ summary: 'Get user schedules' })
  async getSchedules(@Request() req) {
    return this.scheduleService.getSchedules(req.user.userId);
  }

  @Post()
  @ApiOperation({ summary: 'Add new schedule' })
  async addSchedule(@Request() req, @Body() scheduleData: any) {
    return this.scheduleService.addSchedule(req.user.userId, scheduleData);
  }

  @Put(':scheduleId')
  @ApiOperation({ summary: 'Update schedule' })
  async updateSchedule(@Param('scheduleId') scheduleId: string, @Body() scheduleData: any) {
    return this.scheduleService.updateSchedule(scheduleId, scheduleData);
  }

  @Delete(':scheduleId')
  @ApiOperation({ summary: 'Delete schedule' })
  async deleteSchedule(@Param('scheduleId') scheduleId: string) {
    return this.scheduleService.deleteSchedule(scheduleId);
  }

  @Post('generate-optimized')
  @ApiOperation({ summary: 'Generate optimized study schedule' })
  async generateOptimized(@Request() req, @Body() data: any) {
    return this.scheduleService.generateOptimizedSchedule(req.user.userId, data);
  }
}
