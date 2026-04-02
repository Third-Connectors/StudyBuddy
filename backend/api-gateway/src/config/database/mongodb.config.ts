import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

export const mongooseConfig = {
  inject: [ConfigService],
  useFactory: (configService: ConfigService) => ({
    uri: configService.get<string>('MONGODB_URI', 'mongodb://localhost:27017/studybuddy_content'),
    useNewUrlParser: true,
    useUnifiedTopology: true,
  }),
};
