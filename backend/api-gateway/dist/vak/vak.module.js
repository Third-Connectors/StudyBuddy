"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.VakModule = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const axios_1 = require("@nestjs/axios");
const vak_controller_1 = require("./vak.controller");
const vak_service_1 = require("./vak.service");
const vak_result_entity_1 = require("./entities/vak-result.entity");
const vak_question_entity_1 = require("./entities/vak-question.entity");
let VakModule = class VakModule {
};
exports.VakModule = VakModule;
exports.VakModule = VakModule = __decorate([
    (0, common_1.Module)({
        imports: [
            typeorm_1.TypeOrmModule.forFeature([vak_result_entity_1.VakResult, vak_question_entity_1.VakQuestion]),
            axios_1.HttpModule,
        ],
        controllers: [vak_controller_1.VakController],
        providers: [vak_service_1.VakService],
        exports: [vak_service_1.VakService],
    })
], VakModule);
//# sourceMappingURL=vak.module.js.map