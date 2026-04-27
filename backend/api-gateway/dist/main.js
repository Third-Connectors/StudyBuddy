"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const core_1 = require("@nestjs/core");
const common_1 = require("@nestjs/common");
const config_1 = require("@nestjs/config");
const swagger_1 = require("@nestjs/swagger");
const helmet_1 = require("helmet");
const compression = require("compression");
const app_module_1 = require("./app.module");
async function bootstrap() {
    const app = await core_1.NestFactory.create(app_module_1.AppModule);
    const configService = app.get(config_1.ConfigService);
    app.use((0, helmet_1.default)());
    app.enableCors({
        origin: true,
        credentials: true,
    });
    app.use(compression());
    const apiPrefix = configService.get('API_PREFIX', '/api/v1');
    app.setGlobalPrefix(apiPrefix);
    app.useGlobalPipes(new common_1.ValidationPipe({
        whitelist: true,
        forbidNonWhitelisted: true,
        transform: true,
    }));
    const config = new swagger_1.DocumentBuilder()
        .setTitle('Study Buddy API')
        .setDescription('API Gateway for Study Buddy - AI-powered EdTech Platform')
        .setVersion('1.0')
        .addBearerAuth()
        .addApiKey({ type: 'apiKey', name: 'X-API-Key', in: 'header' }, 'ApiKey')
        .build();
    const document = swagger_1.SwaggerModule.createDocument(app, config);
    swagger_1.SwaggerModule.setup(`${apiPrefix}/docs`, app, document);
    const port = configService.get('PORT', 3000);
    await app.listen(port);
    console.log(`
╔═══════════════════════════════════════════════════════════╗
║           🎓 Study Buddy API Gateway                      ║
╠═══════════════════════════════════════════════════════════╣
║  Server running on: http://localhost:${port}               ║
║  API Prefix: ${apiPrefix}                                  ║
║  Swagger Docs: http://localhost:${port}${apiPrefix}/docs   ║
║  Environment: ${configService.get('NODE_ENV')}                       ║
╚═══════════════════════════════════════════════════════════╝
  `);
}
bootstrap();
//# sourceMappingURL=main.js.map