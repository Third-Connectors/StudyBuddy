"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.VakService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const axios_1 = require("@nestjs/axios");
const config_1 = require("@nestjs/config");
const rxjs_1 = require("rxjs");
const vak_result_entity_1 = require("./entities/vak-result.entity");
const vak_question_entity_1 = require("./entities/vak-question.entity");
let VakService = class VakService {
    constructor(vakRepository, vakQuestionRepository, httpService, configService) {
        this.vakRepository = vakRepository;
        this.vakQuestionRepository = vakQuestionRepository;
        this.httpService = httpService;
        this.configService = configService;
    }
    async getQuestions() {
        const questions = await this.vakQuestionRepository.find({
            order: { id: 'ASC' },
        });
        if (questions.length === 0) {
            await this.seedQuestions();
            return this.vakQuestionRepository.find({
                order: { id: 'ASC' },
            });
        }
        return questions;
    }
    async seedQuestions() {
        const questions = this._getHardcodedQuestions();
        for (const q of questions) {
            const entity = this.vakQuestionRepository.create({
                id: q.id,
                question: q.question,
                optionA: q.optionA,
                optionB: q.optionB,
                optionC: q.optionC,
            });
            await this.vakQuestionRepository.save(entity);
        }
    }
    async submitAnswers(userId, answers) {
        try {
            const mlServiceUrl = this.configService.get('ML_SERVICE_URL');
            const response = await (0, rxjs_1.firstValueFrom)(this.httpService.post(`${mlServiceUrl}/vak/classify`, {
                userId,
                answers,
            }));
            const resultData = response.data.result;
            const vakResult = this.vakRepository.create({
                userId,
                visualScore: resultData.visualScore,
                auditoryScore: resultData.auditoryScore,
                kinestheticScore: resultData.kinestheticScore,
                dominantStyle: resultData.dominantStyle,
                confidenceScore: resultData.confidence,
                completedAt: new Date(),
                answers,
            });
            return this.vakRepository.save(vakResult);
        }
        catch (error) {
            return this._calculateResultLocally(userId, answers);
        }
    }
    async getUserResult(userId) {
        return this.vakRepository.findOne({
            where: { userId },
            order: { completedAt: 'DESC' },
        });
    }
    async canRecalibrate(userId) {
        const lastResult = await this.getUserResult(userId);
        if (!lastResult) {
            return true;
        }
        const monthsSince = this._getMonthsDifference(lastResult.completedAt, new Date());
        return monthsSince >= 4;
    }
    async _calculateResultLocally(userId, answers) {
        let visualScore = 0;
        let auditoryScore = 0;
        let kinestheticScore = 0;
        for (const answer of answers) {
            switch (answer.selectedOption.toUpperCase()) {
                case 'A':
                    visualScore++;
                    break;
                case 'B':
                    auditoryScore++;
                    break;
                case 'C':
                    kinestheticScore++;
                    break;
            }
        }
        const total = answers.length;
        visualScore = visualScore / total;
        auditoryScore = auditoryScore / total;
        kinestheticScore = kinestheticScore / total;
        const scores = {
            visual: visualScore,
            auditory: auditoryScore,
            kinesthetic: kinestheticScore,
        };
        const dominantStyle = Object.entries(scores)
            .reduce((a, b) => (a[1] > b[1] ? a : b))[0];
        const maxScore = scores[dominantStyle];
        const avgScore = (visualScore + auditoryScore + kinestheticScore) / 3;
        const confidence = Math.max(0, Math.min(1, (maxScore - avgScore) * 3));
        const vakResult = this.vakRepository.create({
            userId,
            visualScore,
            auditoryScore,
            kinestheticScore,
            dominantStyle,
            confidenceScore: confidence,
            completedAt: new Date(),
            answers,
        });
        return this.vakRepository.save(vakResult);
    }
    _getMonthsDifference(date1, date2) {
        const months = (date2.getFullYear() - date1.getFullYear()) * 12;
        return months - date1.getMonth() + date2.getMonth();
    }
    _getHardcodedQuestions() {
        return [
            {
                id: 1,
                question: 'Ketika mempelajari sesuatu yang baru, aku lebih suka...',
                optionA: 'Melihat gambar, diagram, atau video',
                optionB: 'Mendengarkan penjelasan dari guru/teman',
                optionC: 'Langsung mencoba/praktik sendiri',
            },
            {
                id: 2,
                question: 'Saat aku harus mengikuti petunjuk, aku lebih suka...',
                optionA: 'Membaca petunjuk tertulis',
                optionB: 'Mendengarkan penjelasan lisan',
                optionC: 'Langsung mencoba sambil belajar',
            },
            {
                id: 3,
                question: 'Ketika aku punya waktu luang, aku biasanya...',
                optionA: 'Menonton video atau membaca buku bergambar',
                optionB: 'Mendengarkan musik atau podcast',
                optionC: 'Berolahraga atau melakukan aktivitas fisik',
            },
            {
                id: 4,
                question: 'Aku paling mudah mengingat...',
                optionA: 'Apa yang aku lihat',
                optionB: 'Apa yang aku dengar',
                optionC: 'Apa yang aku lakukan',
            },
            {
                id: 5,
                question: 'Ketika belajar untuk ujian, aku lebih suka...',
                optionA: 'Membuat catatan berwarna dan mind map',
                optionB: 'Diskusi dengan teman atau membaca keras-keras',
                optionC: 'Mengerjakan latihan soal berulang-ulang',
            },
            {
                id: 6,
                question: 'Di kelas, aku lebih suka guru yang...',
                optionA: 'Menggunakan banyak gambar dan slide presentasi',
                optionB: 'Menjelaskan dengan detail dan jelas',
                optionC: 'Memberikan banyak praktik dan eksperimen',
            },
            {
                id: 7,
                question: 'Ketika aku tersesat di tempat baru, aku...',
                optionA: 'Melihat peta atau tanda-tanda visual',
                optionB: 'Bertanya pada orang sekitar',
                optionC: 'Coba jalan terus sampai menemukan jalan',
            },
            {
                id: 8,
                question: 'Aku paling suka tugas yang...',
                optionA: 'Banyak gambar dan ilustrasi',
                optionB: 'Ada diskusi presentasi',
                optionC: 'Ada praktik atau eksperimen',
            },
            {
                id: 9,
                question: 'Ketika membeli barang baru, aku...',
                optionA: 'Melihat gambar dan spesifikasi',
                optionB: 'Mendengarkan review dari orang lain',
                optionC: 'Langsung mencoba barangnya',
            },
            {
                id: 10,
                question: 'Aku lebih suka pelajaran yang...',
                optionA: 'Banyak diagram dan gambar (seperti Biologi)',
                optionB: 'Banyak diskusi dan cerita (seperti Sejarah)',
                optionC: 'Banyak praktikum (seperti Kimia/Fisika)',
            },
            {
                id: 11,
                question: 'Ketika menjelaskan sesuatu, aku sering...',
                optionA: 'Menggambar atau menunjukkan',
                optionB: 'Menjelaskan dengan kata-kata',
                optionC: 'Mendemonstrasikan langsung',
            },
            {
                id: 12,
                question: 'Aku terganggu ketika...',
                optionA: 'Tempat berantakan atau tidak rapi',
                optionB: 'Ada suara bising',
                optionC: 'Harus duduk diam terlalu lama',
            },
            {
                id: 13,
                question: 'Ketika belajar bahasa baru, aku lebih suka...',
                optionA: 'Melihat tulisan dan gambar',
                optionB: 'Mendengarkan dan mengulang',
                optionC: 'Praktik langsung berbicara',
            },
            {
                id: 14,
                question: 'Aku lebih mudah paham dengan...',
                optionA: 'Video tutorial',
                optionB: 'Podcast atau rekaman suara',
                optionC: 'Tutorial praktik langsung',
            },
            {
                id: 15,
                question: 'Ketika bermain game, aku lebih suka...',
                optionA: 'Game dengan grafis bagus',
                optionB: 'Game dengan cerita menarik',
                optionC: 'Game yang butuh keterampilan fisik',
            },
            {
                id: 16,
                question: 'Ruangan belajarku biasanya...',
                optionA: 'Banyak poster dan catatan di dinding',
                optionB: 'Sering diputar musik atau audio',
                optionC: 'Banyak alat praktik atau benda untuk disentuh',
            },
            {
                id: 17,
                question: 'Ketika menghadapi masalah, aku...',
                optionA: 'Membuat daftar atau diagram',
                optionB: 'Curhat atau diskusi dengan orang lain',
                optionC: 'Langsung action mencari solusi',
            },
            {
                id: 18,
                question: 'Aku lebih suka presentasi yang...',
                optionA: 'Banyak slide dan visual',
                optionB: 'Penjelasan detail dari presenter',
                optionC: 'Ada demo atau praktik langsung',
            },
            {
                id: 19,
                question: 'Ketika menghafal, aku biasanya...',
                optionA: 'Menulis ulang atau membuat catatan visual',
                optionB: 'Membaca keras-keras atau mendengarkan',
                optionC: 'Sambil bergerak atau melakukan sesuatu',
            },
            {
                id: 20,
                question: 'Teman-temanku bilang aku...',
                optionA: 'Peka terhadap tampilan dan warna',
                optionB: 'Pendengar yang baik',
                optionC: 'Aktif dan suka bergerak',
            },
        ];
    }
};
exports.VakService = VakService;
exports.VakService = VakService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(vak_result_entity_1.VakResult)),
    __param(1, (0, typeorm_1.InjectRepository)(vak_question_entity_1.VakQuestion)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        typeorm_2.Repository,
        axios_1.HttpService,
        config_1.ConfigService])
], VakService);
//# sourceMappingURL=vak.service.js.map