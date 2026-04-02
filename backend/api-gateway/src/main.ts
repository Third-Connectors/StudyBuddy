import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import helmet from 'helmet';
import compression from 'compression';

import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  const configService = app.get(ConfigService);

  // ── Security ──────────────────────────────────────────────────────────────
  app.use(helmet());
  app.enableCors({
    origin: configService.get<string>('CORS_ORIGIN', '*'),
    credentials: true,
  });

  // ── Compression ───────────────────────────────────────────────────────────
  app.use(compression());

  // ── Global Prefix ─────────────────────────────────────────────────────────
  const apiPrefix = configService.get<string>('API_PREFIX', '/api/v1');
  app.setGlobalPrefix(apiPrefix);

  // ── Validation ────────────────────────────────────────────────────────────
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );

  // ── Swagger Documentation ────────────────────────────────────────────────
  const config = new DocumentBuilder()
    .setTitle('Study Buddy API')
    .setDescription('API Gateway for Study Buddy - AI-powered EdTech Platform')
    .setVersion('1.0')
    .addBearerAuth()
    .addApiKey({ type: 'apiKey', name: 'X-API-Key', in: 'header' }, 'ApiKey')
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup(`${apiPrefix}/docs`, app, document);

  // ── Server Start ──────────────────────────────────────────────────────────
  const port = configService.get<number>('PORT', 3000);
  await app.listen(port);

  console.log(`
╔═══════════════════════════════════════════════════════════╗
║           🎓 Study Buddy API Gateway                      ║
╠═══════════════════════════════════════════════════════════╣
║  Server running on: http://localhost:${port}               ║
║  API Prefix: ${apiPrefix}                                  ║
║  Swagger Docs: http://localhost:${port}${apiPrefix}/docs   ║
║  Environment: ${configService.get<string>('NODE_ENV')}                       ║
╚═══════════════════════════════════════════════════════════╝
  `);
}

bootstrap();
