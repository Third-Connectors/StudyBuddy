"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.mongooseConfig = void 0;
const config_1 = require("@nestjs/config");
exports.mongooseConfig = {
    inject: [config_1.ConfigService],
    useFactory: (configService) => ({
        uri: configService.get('MONGODB_URI', 'mongodb://localhost:27017/studybuddy_content'),
    }),
};
//# sourceMappingURL=mongodb.config.js.map