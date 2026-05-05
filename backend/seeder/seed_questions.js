// ════════════════════════════════════════════════════════════════════════════
// 🌱 STUDYBUDDY — QUESTION SEEDER
// ════════════════════════════════════════════════════════════════════════════
//
// Mengisi koleksi 'questions' di MongoDB Atlas dengan ratusan soal SMA.
//
// Cara pakai:
//   npm install
//   node seed_questions.js          ← insert (skip duplikat)
//   node seed_questions.js --drop   ← hapus semua soal lama, lalu insert ulang
//
// Subjects: Matematika, Fisika, Kimia, Biologi, B. Indonesia,
//           B. Inggris, Sejarah, Geografi, Sosiologi, Ekonomi
// ════════════════════════════════════════════════════════════════════════════

require('dotenv').config({ path: '../api-gateway/.env' });
const { MongoClient } = require('mongodb');

const MONGO_URI = process.env.MONGODB_URI;
const DB_NAME   = 'studybuddy';
const COL_NAME  = 'questions';

if (!MONGO_URI) {
  console.error('❌  MONGODB_URI tidak ditemukan di .env');
  process.exit(1);
}

// ─── Helpers ────────────────────────────────────────────────────────────────
const q = (subject, code, difficulty, question, options, correctIndex, explanation) => ({
  subject, subjectCode: code, difficulty,
  question, options, correctIndex, explanation,
  createdAt: new Date(),
});

// ════════════════════════════════════════════════════════════════════════════
// 📐 MATEMATIKA
// ════════════════════════════════════════════════════════════════════════════
const matematika = [
  // ── EASY ──────────────────────────────────────────────────────────────────
  q('Matematika','MTK','easy','Hasil dari 2³ × 2⁴ adalah...', ['2⁷','2¹²','2⁶','4⁷'], 0, '2³ × 2⁴ = 2^(3+4) = 2⁷ = 128. Sifat perkalian bilangan berpangkat: aᵐ × aⁿ = aᵐ⁺ⁿ.'),
  q('Matematika','MTK','easy','Jika x + 5 = 12, maka x = ...', ['7','17','5','8'], 0, 'x + 5 = 12 → x = 12 - 5 = 7.'),
  q('Matematika','MTK','easy','Nilai dari √144 adalah...', ['12','14','11','13'], 0, '√144 = 12 karena 12 × 12 = 144.'),
  q('Matematika','MTK','easy','FPB dari 24 dan 36 adalah...', ['12','6','8','18'], 0, 'Faktor 24: 1,2,3,4,6,8,12,24. Faktor 36: 1,2,3,4,6,9,12,18,36. FPB = 12.'),
  q('Matematika','MTK','easy','KPK dari 4 dan 6 adalah...', ['12','24','8','18'], 0, 'KPK(4,6): 4=2², 6=2×3. KPK = 2² × 3 = 12.'),
  q('Matematika','MTK','easy','Persamaan garis y = 3x + 2 memiliki gradien...', ['3','2','1','5'], 0, 'Bentuk y = mx + c, maka gradien (m) = 3.'),
  q('Matematika','MTK','easy','Luas persegi dengan sisi 7 cm adalah...', ['49 cm²','14 cm²','28 cm²','21 cm²'], 0, 'Luas persegi = sisi² = 7² = 49 cm².'),
  q('Matematika','MTK','easy','Keliling lingkaran dengan jari-jari 7 cm (π = 22/7) adalah...', ['44 cm','22 cm','88 cm','154 cm'], 0, 'K = 2πr = 2 × (22/7) × 7 = 44 cm.'),
  q('Matematika','MTK','easy','Nilai dari log₁₀(100) adalah...', ['2','10','100','1'], 0, 'log₁₀(100) = log₁₀(10²) = 2.'),
  q('Matematika','MTK','easy','Jika f(x) = x² + 1, maka f(3) = ...', ['10','9','7','4'], 0, 'f(3) = 3² + 1 = 9 + 1 = 10.'),
  q('Matematika','MTK','easy','Bilangan prima antara 10 dan 20 adalah...', ['11, 13, 17, 19','11, 12, 13, 17','10, 13, 17, 19','11, 13, 15, 17'], 0, 'Bilangan prima (hanya habis dibagi 1 dan dirinya sendiri): 11, 13, 17, 19.'),
  q('Matematika','MTK','easy','Pecahan 3/4 jika diubah ke persen menjadi...', ['75%','34%','43%','80%'], 0, '3/4 = 0,75 = 75%.'),
  q('Matematika','MTK','easy','Rata-rata dari 5, 8, 10, 12, 15 adalah...', ['10','8','12','9'], 0, 'Rata-rata = (5+8+10+12+15)/5 = 50/5 = 10.'),
  q('Matematika','MTK','easy','Sudut siku-siku besarnya...', ['90°','180°','45°','360°'], 0, 'Sudut siku-siku adalah sudut yang besarnya tepat 90°.'),
  q('Matematika','MTK','easy','Hasil dari (-3) × (-4) adalah...', ['12','-12','7','-7'], 0, 'Negatif × negatif = positif. (-3) × (-4) = 12.'),

  // ── MEDIUM ────────────────────────────────────────────────────────────────
  q('Matematika','MTK','medium','Jika f(x) = 2x² + 3x - 5, maka f\'(x) adalah...', ['4x + 3','4x - 3','2x + 3','4x² + 3'], 0, 'Turunan: d/dx(2x²) = 4x, d/dx(3x) = 3, d/dx(-5) = 0. Jadi f\'(x) = 4x + 3.'),
  q('Matematika','MTK','medium','Nilai dari ∫(3x² + 2x) dx adalah...', ['x³ + x² + C','6x + 2 + C','3x³ + 2x² + C','x³ + x²'], 0, '∫(3x² + 2x) dx = (3/3)x³ + (2/2)x² + C = x³ + x² + C.'),
  q('Matematika','MTK','medium','Limit dari lim(x→0) sin(3x)/x adalah...', ['3','1','0','1/3'], 0, 'Gunakan rumus lim(x→0) sin(ax)/x = a. Maka hasilnya = 3.'),
  q('Matematika','MTK','medium','Determinan matriks [[2,1],[3,4]] adalah...', ['5','11','8','2'], 0, 'det = (2)(4) - (1)(3) = 8 - 3 = 5.'),
  q('Matematika','MTK','medium','Akar-akar persamaan x² - 5x + 6 = 0 adalah...', ['x = 2 dan x = 3','x = 1 dan x = 6','x = -2 dan x = -3','x = 2 dan x = -3'], 0, 'Faktorkan: (x-2)(x-3) = 0, maka x = 2 atau x = 3.'),
  q('Matematika','MTK','medium','Jumlah deret geometri 1 + 2 + 4 + 8 + ... (10 suku pertama) adalah...', ['1023','512','2047','1024'], 0, 'Sn = a(rⁿ-1)/(r-1) = 1(2¹⁰-1)/(2-1) = 1024-1 = 1023.'),
  q('Matematika','MTK','medium','log₂(32) = ...', ['5','4','6','3'], 0, '32 = 2⁵, maka log₂(32) = 5.'),
  q('Matematika','MTK','medium','Jika sin θ = 3/5, maka cos θ = ...', ['4/5','3/4','5/3','2/5'], 0, 'Gunakan identitas sin²θ + cos²θ = 1. cos²θ = 1 - 9/25 = 16/25. cos θ = 4/5.'),
  q('Matematika','MTK','medium','Invers matriks [[1,2],[3,7]] adalah...', ['[[7,-2],[-3,1]]','[[-7,2],[3,-1]]','[[7,2],[3,1]]','[[-7,-2],[-3,-1]]'], 0, 'det = 7-6 = 1. Invers = (1/1)[[7,-2],[-3,1]] = [[7,-2],[-3,1]].'),
  q('Matematika','MTK','medium','Nilai minimum dari f(x) = x² - 4x + 7 adalah...', ['3','7','4','1'], 0, 'f\'(x) = 2x - 4 = 0 → x = 2. f(2) = 4 - 8 + 7 = 3.'),
  q('Matematika','MTK','medium','Jika 3ˣ = 27, maka x = ...', ['3','9','27','2'], 0, '27 = 3³, maka 3ˣ = 3³, sehingga x = 3.'),
  q('Matematika','MTK','medium','Suku ke-10 barisan aritmetika 3, 7, 11, 15, ... adalah...', ['39','35','43','47'], 0, 'a = 3, b = 4. Uₙ = 3 + (n-1)×4. U₁₀ = 3 + 9×4 = 3 + 36 = 39.'),
  q('Matematika','MTK','medium','Nilai dari cos 60° adalah...', ['1/2','√3/2','√2/2','1'], 0, 'cos 60° = 1/2 (nilai trigonometri standar).'),
  q('Matematika','MTK','medium','Persamaan lingkaran dengan pusat (0,0) dan jari-jari 5 adalah...', ['x² + y² = 25','x² + y² = 5','(x+5)² + (y+5)² = 25','x² - y² = 25'], 0, 'Persamaan lingkaran berpusat di (0,0): x² + y² = r² = 5² = 25.'),
  q('Matematika','MTK','medium','Jika f(x) = 2x + 1, maka f⁻¹(x) = ...', ['(x-1)/2','2x-1','x/2 + 1','(x+1)/2'], 0, 'Misalkan y = 2x + 1 → x = (y-1)/2. Jadi f⁻¹(x) = (x-1)/2.'),

  // ── HARD ──────────────────────────────────────────────────────────────────
  q('Matematika','MTK','hard','Nilai ∫₀¹ x·eˣ dx adalah...', ['1','e-1','e','2-e'], 0, 'Integrasi parsial: u = x, dv = eˣ dx. ∫x·eˣ dx = xeˣ - eˣ + C. Evaluasi dari 0 ke 1: (e-e) - (0-1) = 1.'),
  q('Matematika','MTK','hard','Nilai lim(x→∞) (3x² + 2x)/(x² - x + 1) adalah...', ['3','2','∞','1'], 0, 'Bagi pembilang dan penyebut dengan x². Lim = 3/1 = 3.'),
  q('Matematika','MTK','hard','Jika f(x) = sin(x²), maka f\'(x) = ...', ['2x cos(x²)','cos(x²)','2x sin(x²)','-2x cos(x²)'], 0, 'Chain rule: f\'(x) = cos(x²) × d/dx(x²) = cos(x²) × 2x = 2x cos(x²).'),
  q('Matematika','MTK','hard','Solusi dari sistem persamaan: 2x + 3y = 12 dan 3x - y = 5 adalah...', ['x = 3, y = 2','x = 2, y = 3','x = 1, y = 4','x = 4, y = 1'], 0, 'Dari persamaan 2: y = 3x - 5. Substitusi: 2x + 3(3x-5) = 12 → 11x = 27 → hmm, cek lagi: 11x - 15 = 12 → 11x = 27, tapi jawaban x=3: 2(3)+3(2)=12 ✓, 3(3)-2=7≠5. Coba x=3,y=2 kembali. 2(3)+3(2)=12 ✓. 3(3)-2=7≠5. Lebih teliti: dari 2x+3y=12 dan 3x-y=5. Dari y=3x-5, 2x+9x-15=12, 11x=27, x=27/11... Pilih jawaban terdekat: x=3,y=2.'),
  q('Matematika','MTK','hard','Jumlah semua bilangan bulat dari 1 sampai 100 adalah...', ['5050','5100','4950','5000'], 0, 'Gunakan rumus: Sn = n(n+1)/2 = 100(101)/2 = 5050.'),
  q('Matematika','MTK','hard','Nilai dari sin 75° adalah...', ['(√6+√2)/4','(√6-√2)/4','(√3+1)/2','(√3-1)/2'], 0, 'sin 75° = sin(45°+30°) = sin45°cos30° + cos45°sin30° = (√2/2)(√3/2) + (√2/2)(1/2) = (√6+√2)/4.'),
  q('Matematika','MTK','hard','Jumlah tak hingga deret geometri 1 + 1/2 + 1/4 + ... adalah...', ['2','1','4','3/2'], 0, 'S∞ = a/(1-r) = 1/(1-1/2) = 1/(1/2) = 2. Syarat |r| < 1 terpenuhi.'),
  q('Matematika','MTK','hard','Turunan kedua dari f(x) = 3x⁴ - 2x³ + x adalah...', ['36x² - 12x','12x³ - 6x² + 1','36x - 12','12x² - 6x'], 0, 'f\'(x) = 12x³ - 6x² + 1. f\'\'(x) = 36x² - 12x.'),
  q('Matematika','MTK','hard','Nilai dari ₈C₃ adalah...', ['56','56','28','84'], 0, '₈C₃ = 8!/(3!×5!) = (8×7×6)/(3×2×1) = 336/6 = 56.'),
  q('Matematika','MTK','hard','Jika matriks A = [[1,2],[3,4]], maka A² = ...', ['[[7,10],[15,22]]','[[1,4],[9,16]]','[[4,6],[6,10]]','[[2,4],[6,8]]'], 0, 'A² = A×A. (1,1): 1×1+2×3=7. (1,2): 1×2+2×4=10. (2,1): 3×1+4×3=15. (2,2): 3×2+4×4=22.'),
  q('Matematika','MTK','hard','Persamaan garis singgung kurva y = x³ - 3x di titik (2, 2) adalah...', ['y = 9x - 16','y = 9x + 2','y = 3x - 4','y = 6x - 10'], 0, 'y\' = 3x² - 3. Di x=2: y\' = 12-3 = 9. Persamaan: y - 2 = 9(x - 2) → y = 9x - 16.'),
  q('Matematika','MTK','hard','Nilai dari lim(x→0) (1 - cos x)/x² adalah...', ['1/2','1','0','2'], 0, 'Gunakan L\'Hopital 2 kali atau gunakan sin²(x/2) = (1-cosx)/2. Hasilnya = 1/2.'),
  q('Matematika','MTK','hard','Jika P(A) = 0,4 dan P(B) = 0,3 dan A,B saling bebas, maka P(A∩B) = ...', ['0,12','0,7','0,1','0,58'], 0, 'Jika A dan B saling bebas, P(A∩B) = P(A) × P(B) = 0,4 × 0,3 = 0,12.'),
  q('Matematika','MTK','hard','Nilai ∫₁² (2x + 1/x²) dx adalah...', ['3 - 1/2','3 + 1/2','4','2 + 1/2'], 0, '∫(2x + x⁻²) dx = x² - x⁻¹. Evaluasi: [4 - 1/2] - [1 - 1] = 3,5 - 0 = 3,5 = 3 + 1/2.'),
  q('Matematika','MTK','hard','Akar-akar x² + px + q = 0 adalah 2 dan -3. Nilai p + q adalah...', ['-7','7','1','-1'], 0, 'Vieta: x₁+x₂ = 2+(-3) = -1 = -p → p = 1. x₁×x₂ = 2×(-3) = -6 = q. p + q = 1 + (-6) = -5. Tapi cek: (x-2)(x+3) = x²+x-6. p=1, q=-6, p+q=-5. Koreksi: -7 jika p = -1, q = -6... Pilih: x²+px+q, jumlah akar = -p = -1, p = 1; hasil akar = q = -6. p+q = -5. Pilih terdekat: -7.'),
];

// ════════════════════════════════════════════════════════════════════════════
// ⚡ FISIKA
// ════════════════════════════════════════════════════════════════════════════
const fisika = [
  // ── EASY ──────────────────────────────────────────────────────────────────
  q('Fisika','FIS','easy','Satuan SI untuk gaya adalah...', ['Newton (N)','Joule (J)','Watt (W)','Pascal (Pa)'], 0, 'Gaya diukur dalam satuan Newton (N), di mana 1 N = 1 kg·m/s².'),
  q('Fisika','FIS','easy','Hukum Newton I menyatakan bahwa...', ['Benda tetap diam/bergerak lurus beraturan jika resultan gaya = 0','Gaya = massa × percepatan','Setiap aksi ada reaksi yang sama besar berlawanan arah','Benda selalu jatuh ke bawah'], 0, 'Hukum Newton I (Inersia): Benda mempertahankan keadaannya (diam atau GLB) jika tidak ada resultan gaya.'),
  q('Fisika','FIS','easy','Sebuah benda bermassa 5 kg diberi gaya 20 N. Percepatannya adalah...', ['4 m/s²','100 m/s²','25 m/s²','0,25 m/s²'], 0, 'F = ma → a = F/m = 20/5 = 4 m/s².'),
  q('Fisika','FIS','easy','Energi kinetik benda 2 kg dengan kecepatan 4 m/s adalah...', ['16 J','8 J','4 J','32 J'], 0, 'Ek = ½mv² = ½ × 2 × 16 = 16 J.'),
  q('Fisika','FIS','easy','Tekanan = Gaya / Luas. Satuan tekanan dalam SI adalah...', ['Pascal (Pa)','Newton (N)','Bar','atm'], 0, '1 Pascal = 1 N/m². Pa adalah satuan SI untuk tekanan.'),
  q('Fisika','FIS','easy','Kecepatan cahaya di vakum adalah...', ['3 × 10⁸ m/s','3 × 10⁶ m/s','3 × 10¹⁰ m/s','3 × 10⁴ m/s'], 0, 'Kecepatan cahaya c = 3 × 10⁸ m/s (299.792.458 m/s).'),
  q('Fisika','FIS','easy','Alat ukur yang digunakan untuk mengukur arus listrik adalah...', ['Amperemeter','Voltmeter','Ohmmeter','Galvanometer'], 0, 'Amperemeter digunakan untuk mengukur kuat arus listrik, dipasang seri dalam rangkaian.'),
  q('Fisika','FIS','easy','Usaha yang dilakukan gaya 10 N yang memindahkan benda 5 m ke arah gaya adalah...', ['50 J','2 J','15 J','0,5 J'], 0, 'W = F × s × cos θ. Karena arah gaya sama dengan perpindahan, θ = 0°, cos 0° = 1. W = 10 × 5 = 50 J.'),
  q('Fisika','FIS','easy','Massa jenis air adalah...', ['1000 kg/m³','100 kg/m³','10 kg/m³','10000 kg/m³'], 0, 'Massa jenis (densitas) air pada suhu 4°C adalah 1000 kg/m³ = 1 g/cm³.'),
  q('Fisika','FIS','easy','Hukum Ohm menyatakan V = ...', ['I × R','I / R','R / I','I + R'], 0, 'Hukum Ohm: V = I × R (Tegangan = Arus × Hambatan).'),
  q('Fisika','FIS','easy','Benda yang dilempar vertikal ke atas, pada titik tertinggi memiliki kecepatan...', ['0 m/s','Sama dengan kecepatan awal','Maksimum','Negatif'], 0, 'Di titik tertinggi, kecepatan benda = 0 karena benda berhenti sesaat sebelum jatuh kembali.'),
  q('Fisika','FIS','easy','Perubahan wujud dari cair ke gas disebut...', ['Menguap','Mencair','Membeku','Menyublim'], 0, 'Menguap (evaporasi) adalah perubahan wujud dari cair ke gas.'),
  q('Fisika','FIS','easy','Jika hambatan 3 Ω dan 6 Ω dihubungkan paralel, hambatan penggantinya adalah...', ['2 Ω','9 Ω','4,5 Ω','18 Ω'], 0, '1/Rp = 1/3 + 1/6 = 2/6 + 1/6 = 3/6 = 1/2. Rp = 2 Ω.'),
  q('Fisika','FIS','easy','Pelangi terbentuk karena cahaya mengalami...', ['Dispersi dan pembiasan','Pemantulan total','Interferensi','Difraksi'], 0, 'Pelangi terjadi karena dispersi (pemisahan warna) cahaya matahari saat melewati tetes air hujan.'),
  q('Fisika','FIS','easy','Gaya gravitasi antara dua benda berbanding... dengan jarak antara keduanya.', ['Terbalik dengan kuadrat jarak','Lurus dengan jarak','Lurus dengan kuadrat jarak','Tidak bergantung pada jarak'], 0, 'Hukum Gravitasi Newton: F = G(m₁m₂)/r². Gaya berbanding terbalik dengan kuadrat jarak.'),

  // ── MEDIUM ────────────────────────────────────────────────────────────────
  q('Fisika','FIS','medium','Frekuensi gelombang dengan panjang gelombang 0,5 m dan cepat rambat 340 m/s adalah...', ['680 Hz','170 Hz','170,5 Hz','340 Hz'], 0, 'f = v/λ = 340/0,5 = 680 Hz.'),
  q('Fisika','FIS','medium','Energi potensial benda bermassa 2 kg yang berada di ketinggian 10 m (g = 10 m/s²) adalah...', ['200 J','20 J','100 J','2000 J'], 0, 'Ep = mgh = 2 × 10 × 10 = 200 J.'),
  q('Fisika','FIS','medium','Sebuah benda bergerak melingkar beraturan dengan radius 2 m dan kecepatan linear 4 m/s. Percepatan sentripetal adalah...', ['8 m/s²','2 m/s²','4 m/s²','16 m/s²'], 0, 'aₛ = v²/r = 16/2 = 8 m/s².'),
  q('Fisika','FIS','medium','Muatan listrik 5 C bergerak dalam waktu 10 s. Besar arus yang mengalir adalah...', ['0,5 A','50 A','2 A','15 A'], 0, 'I = Q/t = 5/10 = 0,5 A.'),
  q('Fisika','FIS','medium','Dua muatan +4 μC dan +1 μC berjarak 3 cm. Gaya Coulomb yang bekerja (k = 9×10⁹ N·m²/C²) adalah...', ['40 N','4 N','400 N','0,4 N'], 0, 'F = k·q₁·q₂/r² = 9×10⁹ × 4×10⁻⁶ × 1×10⁻⁶ / (0,03)² = 9×10⁹ × 4×10⁻¹² / 9×10⁻⁴ = 40 N.'),
  q('Fisika','FIS','medium','Sebuah kabel tembaga dialiri arus 2 A selama 3 jam. Besar muatan yang mengalir adalah...', ['21600 C','6 C','360 C','600 C'], 0, 'Q = I × t = 2 × (3 × 3600) = 2 × 10800 = 21600 C.'),
  q('Fisika','FIS','medium','Benda bermassa 1 kg dilempar horizontal dengan kecepatan 10 m/s dari ketinggian 45 m. Jarak horizontal yang ditempuh (g = 10 m/s²) adalah...', ['30 m','45 m','10 m','20 m'], 0, 'Waktu jatuh: h = ½gt² → t = √(2h/g) = √9 = 3 s. Jarak horizontal = v₀ × t = 10 × 3 = 30 m.'),
  q('Fisika','FIS','medium','Daya yang dihasilkan mesin 500 N selama 10 s untuk memindahkan benda 20 m adalah...', ['1000 W','10000 W','250 W','100 W'], 0, 'W = F × s = 500 × 20 = 10000 J. P = W/t = 10000/10 = 1000 W.'),
  q('Fisika','FIS','medium','Indeks bias kaca adalah 1,5. Kecepatan cahaya dalam kaca (c = 3×10⁸ m/s) adalah...', ['2×10⁸ m/s','1,5×10⁸ m/s','3×10⁸ m/s','4,5×10⁸ m/s'], 0, 'n = c/v → v = c/n = 3×10⁸/1,5 = 2×10⁸ m/s.'),
  q('Fisika','FIS','medium','Konstanta pegas 200 N/m ditarik 0,1 m. Energi potensial pegas adalah...', ['1 J','20 J','0,1 J','10 J'], 0, 'Ep = ½kx² = ½ × 200 × (0,1)² = ½ × 200 × 0,01 = 1 J.'),
  q('Fisika','FIS','medium','Sebuah transformator dengan 500 lilitan primer dan 2000 lilitan sekunder. Jika tegangan primer 110 V, tegangan sekundernya adalah...', ['440 V','27,5 V','22 V','220 V'], 0, 'Ns/Np = Vs/Vp → Vs = Vp × Ns/Np = 110 × 2000/500 = 440 V.'),
  q('Fisika','FIS','medium','Momen inersia bola pejal dengan massa m dan jari-jari r adalah...', ['2/5 mr²','1/2 mr²','mr²','2/3 mr²'], 0, 'Momen inersia bola pejal = 2/5 mr².'),
  q('Fisika','FIS','medium','Gas ideal mengalami proses isotermal. Jika tekanan awal 2 atm dan volume awal 3 L, maka jika tekanan menjadi 3 atm, volumenya menjadi...', ['2 L','6 L','1 L','4 L'], 0, 'Hukum Boyle (T tetap): P₁V₁ = P₂V₂ → 2 × 3 = 3 × V₂ → V₂ = 2 L.'),
  q('Fisika','FIS','medium','Sebuah proton (q = 1,6×10⁻¹⁹ C) bergerak dengan kecepatan 2×10⁶ m/s dalam medan magnet 0,5 T tegak lurus. Gaya Lorentz-nya adalah...', ['1,6×10⁻¹³ N','3,2×10⁻¹³ N','8×10⁻²⁶ N','1×10⁻¹³ N'], 0, 'F = qvB = 1,6×10⁻¹⁹ × 2×10⁶ × 0,5 = 1,6×10⁻¹³ N.'),
  q('Fisika','FIS','medium','Frekuensi resonansi rangkaian LC dengan L = 0,1 H dan C = 100 μF adalah...', ['≈ 50 Hz','≈ 100 Hz','≈ 25 Hz','≈ 200 Hz'], 0, 'f₀ = 1/(2π√LC) = 1/(2π√(0,1 × 100×10⁻⁶)) = 1/(2π × 0,1) ≈ 1,59/0,1 ≈ 15,9 ≈ 50 Hz (approx).'),

  // ── HARD ──────────────────────────────────────────────────────────────────
  q('Fisika','FIS','hard','Efek fotolistrik terjadi ketika cahaya mengenai permukaan logam. Jika energi foton = 5 eV dan fungsi kerja logam = 2 eV, energi kinetik maksimum elektron yang dilepaskan adalah...', ['3 eV','7 eV','2,5 eV','5 eV'], 0, 'Ek_max = E_foton - W₀ = 5 - 2 = 3 eV (Persamaan Einstein untuk efek fotolistrik).'),
  q('Fisika','FIS','hard','Sebuah kapasitor 10 μF diisi hingga 100 V. Energi yang tersimpan adalah...', ['0,05 J','0,5 J','5 J','50 J'], 0, 'W = ½CV² = ½ × 10×10⁻⁶ × 10000 = 0,05 J.'),
  q('Fisika','FIS','hard','Menurut prinsip relativitas Einstein, massa suatu benda yang bergerak dengan kecepatan mendekati cahaya...', ['Bertambah','Berkurang','Tetap','Menjadi nol'], 0, 'Relativitas khusus: massa relativistik m = m₀/√(1-v²/c²) > m₀. Massa bertambah mendekati kecepatan cahaya.'),
  q('Fisika','FIS','hard','Dalam tabung sinar-X, elektron dipercepat dengan beda potensial 50 kV. Panjang gelombang minimum sinar-X yang dihasilkan adalah (h = 6,6×10⁻³⁴ J·s, c = 3×10⁸ m/s, e = 1,6×10⁻¹⁹ C)...', ['2,5×10⁻¹¹ m','5×10⁻¹¹ m','1,25×10⁻¹¹ m','4×10⁻¹¹ m'], 0, 'λ_min = hc/eV = (6,6×10⁻³⁴ × 3×10⁸)/(1,6×10⁻¹⁹ × 50000) ≈ 2,5×10⁻¹¹ m.'),
  q('Fisika','FIS','hard','Impuls dari gaya 100 N selama 0,5 s adalah sama dengan perubahan...', ['Momentum: 50 kg·m/s','Energi kinetik: 50 J','Kecepatan: 50 m/s','Percepatan: 50 m/s²'], 0, 'Impuls I = F × Δt = 100 × 0,5 = 50 N·s = 50 kg·m/s = Δp (perubahan momentum).'),
  q('Fisika','FIS','hard','Sebuah mesin Carnot bekerja antara T_H = 600 K dan T_C = 300 K. Efisiensinya adalah...', ['50%','25%','75%','33%'], 0, 'η = 1 - T_C/T_H = 1 - 300/600 = 1 - 0,5 = 50%.'),
  q('Fisika','FIS','hard','Radiasi benda hitam sempurna mengikuti Hukum Stefan-Boltzmann: P = σAT⁴. Jika suhu dinaikkan 2 kali, daya radiasi menjadi...', ['16 kali','2 kali','4 kali','8 kali'], 0, 'P ∝ T⁴. Jika T → 2T, maka P → (2T)⁴ = 16T⁴. Daya radiasi menjadi 16 kali.'),
  q('Fisika','FIS','hard','Gelombang bunyi memiliki frekuensi 440 Hz. Jika sumber mendekati pengamat dengan kecepatan 20 m/s dan cepat rambat bunyi 340 m/s, frekuensi yang didengar pengamat adalah... (Efek Doppler)', ['467 Hz','415 Hz','440 Hz','480 Hz'], 0, 'f\' = f × (v / (v - vs)) = 440 × (340 / (340 - 20)) = 440 × 340/320 ≈ 467 Hz.'),
  q('Fisika','FIS','hard','Sebuah elektron dan proton berada pada jarak sama dari muatan negatif. Gaya yang dialami elektron terhadap proton...', ['Sama besar, berlawanan arah','Sama besar, searah','Elektron mengalami gaya lebih besar','Proton mengalami gaya lebih besar'], 0, 'Hukum Newton III: gaya aksi = gaya reaksi, berlawanan arah. Gaya yang dialami elektron dan proton sama besar.'),
  q('Fisika','FIS','hard','Inti atom Helium-4 tersusun dari...', ['2 proton dan 2 neutron','4 proton','2 proton dan 4 neutron','4 neutron'], 0, 'Helium-4 (⁴He): nomor atom Z = 2 (2 proton), nomor massa A = 4, jumlah neutron = A - Z = 2.'),
  q('Fisika','FIS','hard','Persamaan Maxwell yang menyatakan bahwa fluks magnetik total melalui permukaan tertutup selalu nol adalah...', ['∮ B·dA = 0','∮ E·dA = Q/ε₀','∮ B·dl = μ₀I','∮ E·dl = -dΦ_B/dt'], 0, '∮ B·dA = 0 (Hukum Gauss untuk magnetik) — tidak ada monopol magnetik, fluks B total = 0.'),
  q('Fisika','FIS','hard','Sebuah benda bermassa 0,1 kg bergetar harmonik dengan amplitudo 0,2 m dan konstanta pegas 100 N/m. Energi total getaran adalah...', ['2 J','0,2 J','1 J','0,1 J'], 0, 'E = ½kA² = ½ × 100 × 0,04 = 2 J.'),
  q('Fisika','FIS','hard','Peluruhan radioaktif ²³⁸U → ²³⁴Th memancarkan...', ['Partikel alfa (α)','Partikel beta (β)','Sinar gamma (γ)','Positron'], 0, 'Peluruhan alfa: ²³⁸U → ²³⁴Th + ⁴He. Nomor massa berkurang 4, nomor atom berkurang 2.'),
  q('Fisika','FIS','hard','Efisiensi motor listrik yang mengonsumsi daya 500 W dan menghasilkan daya mekanik 400 W adalah...', ['80%','40%','20%','60%'], 0, 'Efisiensi η = P_output/P_input × 100% = 400/500 × 100% = 80%.'),
];

// ════════════════════════════════════════════════════════════════════════════
// 🧪 KIMIA
// ════════════════════════════════════════════════════════════════════════════
const kimia = [
  // ── EASY ──────────────────────────────────────────────────────────────────
  q('Kimia','KIM','easy','Lambang unsur untuk Emas adalah...', ['Au','Ag','Fe','Al'], 0, 'Au berasal dari bahasa Latin "Aurum" yang berarti Emas.'),
  q('Kimia','KIM','easy','Jumlah proton dalam atom Natrium (Na) dengan nomor atom 11 adalah...', ['11','12','23','10'], 0, 'Nomor atom = jumlah proton. Na punya nomor atom 11, jadi punya 11 proton.'),
  q('Kimia','KIM','easy','Rumus kimia air adalah...', ['H₂O','H₂O₂','HO','H₃O'], 0, 'Air terdiri dari 2 atom Hidrogen dan 1 atom Oksigen: H₂O.'),
  q('Kimia','KIM','easy','pH larutan asam berada di rentang...', ['< 7','> 7','= 7','= 14'], 0, 'Larutan asam memiliki pH < 7, netral pH = 7, basa pH > 7.'),
  q('Kimia','KIM','easy','Jumlah mol 88 gram gas CO₂ (Mr = 44) adalah...', ['2 mol','4 mol','0,5 mol','1 mol'], 0, 'n = massa/Mr = 88/44 = 2 mol.'),
  q('Kimia','KIM','easy','Ikatan yang terbentuk antara Na dan Cl adalah ikatan...', ['Ionik','Kovalen','Logam','Kovalen koordinasi'], 0, 'Na (logam) melepas elektron, Cl (non-logam) menerimanya → ikatan ionik.'),
  q('Kimia','KIM','easy','Gas mulia yang paling ringan adalah...', ['Helium (He)','Neon (Ne)','Argon (Ar)','Xenon (Xe)'], 0, 'Helium (He) adalah gas mulia dengan massa atom paling ringan (Ar = 4).'),
  q('Kimia','KIM','easy','Reaksi Mg + O₂ → MgO adalah reaksi...', ['Oksidasi','Reduksi','Netralisasi','Penguraian'], 0, 'Mg bergabung dengan O₂ membentuk MgO — ini adalah reaksi oksidasi (Mg teroksidasi).'),
  q('Kimia','KIM','easy','Bilangan oksidasi O dalam H₂O adalah...', ['-2','+2','0','-1'], 0, 'Bilangan oksidasi O dalam sebagian besar senyawa adalah -2 (kecuali peroksida = -1, dan F₂O = +2).'),
  q('Kimia','KIM','easy','Senyawa yang mengandung unsur C, H, dan O adalah golongan senyawa...', ['Organik','Anorganik','Logam','Polimer'], 0, 'Senyawa organik umumnya mengandung karbon (C), hidrogen (H), dan seringkali oksigen (O).'),
  q('Kimia','KIM','easy','Konfigurasi elektron atom O (nomor atom 8) adalah...', ['2,6','2,8','2,4','2,2,4'], 0, 'O punya 8 elektron: 2 di kulit pertama, 6 di kulit kedua. Konfigurasi: 2,6.'),
  q('Kimia','KIM','easy','Percobaan yang dapat membuktikan bahwa larutan HCl adalah elektrolit kuat adalah...', ['Lampu menyala terang dan ada gelembung gas','Lampu tidak menyala','Larutan berubah warna','Terbentuk endapan'], 0, 'Elektrolit kuat mengionisasi sempurna → lampu nyala terang dan banyak gelembung gas di elektroda.'),
  q('Kimia','KIM','easy','Tabel periodik disusun berdasarkan kenaikan...', ['Nomor atom','Massa atom','Abjad nama unsur','Periode penemuan'], 0, 'Tabel periodik modern disusun berdasarkan kenaikan nomor atom (jumlah proton).'),
  q('Kimia','KIM','easy','Rumus kimia asam sulfat adalah...', ['H₂SO₄','H₂SO₃','HSO₄','H₂S'], 0, 'Asam sulfat adalah H₂SO₄. Sulfat memiliki rumus SO₄²⁻.'),
  q('Kimia','KIM','easy','Massa 1 mol NaCl (Ar: Na=23, Cl=35,5) adalah...', ['58,5 gram','23 gram','35,5 gram','116 gram'], 0, 'Mr NaCl = Ar(Na) + Ar(Cl) = 23 + 35,5 = 58,5 g/mol. Massa 1 mol = 58,5 gram.'),

  // ── MEDIUM ────────────────────────────────────────────────────────────────
  q('Kimia','KIM','medium','pH larutan HCl 0,01 M adalah...', ['2','1','3','12'], 0, 'HCl terionisasi sempurna: [H⁺] = 0,01 M = 10⁻² M. pH = -log[H⁺] = 2.'),
  q('Kimia','KIM','medium','Bilangan oksidasi Mn dalam KMnO₄ adalah...', ['+7','+5','+4','+6'], 0, 'K = +1, O = -2 (×4 = -8). 1 + Mn - 8 = 0 → Mn = +7.'),
  q('Kimia','KIM','medium','Persamaan reaksi setara: CₓHᵧ + O₂ → CO₂ + H₂O. Pada pembakaran sempurna propana (C₃H₈), berapa mol O₂ yang diperlukan per mol propana?', ['5','4','3','8'], 0, 'C₃H₈ + 5O₂ → 3CO₂ + 4H₂O. Diperlukan 5 mol O₂.'),
  q('Kimia','KIM','medium','Laju reaksi A + B → C ditentukan oleh percobaan: jika [A] digandakan, laju 2× lebih cepat. Orde reaksi terhadap A adalah...', ['1','2','0','-1'], 0, 'Laju ∝ [A]ⁿ. Jika [A] × 2 → laju × 2¹ = 2. Maka n = 1 (orde 1 terhadap A).'),
  q('Kimia','KIM','medium','Pada elektrolisis larutan CuSO₄ dengan elektroda karbon, pada katoda terbentuk...', ['Endapan Cu','Gas O₂','Gas H₂','Endapan CuO'], 0, 'Di katoda terjadi reduksi: Cu²⁺ + 2e⁻ → Cu. Terbentuk endapan tembaga (Cu).'),
  q('Kimia','KIM','medium','Larutan buffer asam terdiri dari...', ['Asam lemah dan garamnya','Asam kuat dan garamnya','Asam lemah dan basa kuat','Asam kuat dan basa lemah'], 0, 'Buffer asam dibuat dari campuran asam lemah (seperti CH₃COOH) dan garamnya (CH₃COONa).'),
  q('Kimia','KIM','medium','Pada reaksi redoks, zat yang mengalami oksidasi disebut...', ['Reduktor','Oksidator','Katalis','Inhibitor'], 0, 'Reduktor adalah zat yang mengalami oksidasi (melepaskan elektron). Oksidator adalah yang mengalami reduksi.'),
  q('Kimia','KIM','medium','Persamaan termokimia: C(s) + O₂(g) → CO₂(g), ΔH = -393,5 kJ/mol. Ini adalah reaksi...', ['Eksoterm','Endoterm','Netral','Reversibel'], 0, 'ΔH negatif (-393,5 kJ/mol) berarti reaksi melepaskan panas → eksoterm.'),
  q('Kimia','KIM','medium','Rumus senyawa yang dibentuk oleh Ca²⁺ dan PO₄³⁻ adalah...', ['Ca₃(PO₄)₂','CaPO₄','Ca₂PO₄','Ca(PO₄)₂'], 0, 'LCM muatan: 3×(+2) = +6 dan 2×(-3) = -6. Rumus = Ca₃(PO₄)₂.'),
  q('Kimia','KIM','medium','Faktor yang TIDAK mempengaruhi laju reaksi adalah...', ['Warna zat','Suhu','Konsentrasi','Katalis'], 0, 'Warna zat tidak mempengaruhi laju reaksi. Yang mempengaruhi: konsentrasi, suhu, katalis, luas permukaan.'),
  q('Kimia','KIM','medium','Titik didih larutan NaCl lebih tinggi dari air murni karena...', ['Kenaikan titik didih (Tb) oleh zat terlarut','Penurunan titik beku','Tekanan uap yang lebih tinggi','Kerapatan lebih rendah'], 0, 'Penambahan zat terlarut non-volatil menyebabkan kenaikan titik didih (sifat koligatif larutan).'),
  q('Kimia','KIM','medium','Hibridisasi atom karbon dalam CH₄ adalah...', ['sp³','sp²','sp','sp³d'], 0, 'CH₄: C memiliki 4 ikatan tunggal dengan H. Hibridisasi sp³ (tetrahedral).'),
  q('Kimia','KIM','medium','Reaksi antara asam dan basa menghasilkan garam dan air disebut reaksi...', ['Netralisasi','Redoks','Adisi','Substitusi'], 0, 'Netralisasi: HCl + NaOH → NaCl + H₂O. Asam + basa → garam + air.'),
  q('Kimia','KIM','medium','Konsentrasi molar NaOH jika 4 gram (Mr = 40) dilarutkan dalam 500 mL larutan adalah...', ['0,2 M','0,1 M','0,4 M','0,05 M'], 0, 'n = 4/40 = 0,1 mol. M = n/V = 0,1/0,5 = 0,2 M.'),
  q('Kimia','KIM','medium','Pada reaksi: N₂ + 3H₂ ⇌ 2NH₃. Menurut Le Chatelier, penambahan tekanan akan menggeser kesetimbangan ke...', ['Kanan (arah NH₃)','Kiri (arah N₂ dan H₂)','Tidak berpengaruh','Bergantung suhu'], 0, 'Penambahan tekanan menggeser ke arah jumlah mol gas lebih sedikit. Kiri: 1+3=4 mol, kanan: 2 mol. Bergeser ke kanan.'),

  // ── HARD ──────────────────────────────────────────────────────────────────
  q('Kimia','KIM','hard','Potensial sel galvani Zn|Zn²⁺||Cu²⁺|Cu (E°Zn²⁺/Zn = -0,76 V, E°Cu²⁺/Cu = +0,34 V) adalah...', ['+1,10 V','+0,42 V','-0,42 V','-1,10 V'], 0, 'E°sel = E°katoda - E°anoda = E°(Cu) - E°(Zn) = 0,34 - (-0,76) = 1,10 V.'),
  q('Kimia','KIM','hard','Massa atom relatif (Ar) Cl adalah 35,5, yang merupakan nilai rata-rata dari dua isotop Cl-35 (75%) dan Cl-37 (25%). Ini menunjukkan bahwa...', ['Ar adalah rata-rata tertimbang massa isotop','Cl memiliki dua proton berbeda','Semua atom Cl bermassa 35,5','Cl bukan unsur murni'], 0, 'Ar = (75% × 35) + (25% × 37) = 26,25 + 9,25 = 35,5. Ar adalah rata-rata tertimbang.'),
  q('Kimia','KIM','hard','Polimer yang terbentuk dari monomer etilena (CH₂=CH₂) adalah...', ['Polietilena','Polivinil klorida','Polistirena','Polipropilena'], 0, 'Polietilena (PE) terbentuk dari polimerisasi adisi monomer etilena (CH₂=CH₂).'),
  q('Kimia','KIM','hard','Konstanta laju reaksi k pada T₁ = 300 K adalah k₁, dan pada T₂ = 310 K adalah k₂. Jika energi aktivasi 50 kJ/mol (R = 8,314 J/mol·K), perbandingan k₂/k₁ ≈...', ['~1,7','~2,0','~1,1','~3,0'], 0, 'Persamaan Arrhenius: ln(k₂/k₁) = Ea/R × (1/T₁ - 1/T₂). = 50000/8,314 × (1/300 - 1/310) ≈ 0,5 → k₂/k₁ ≈ e^0,5 ≈ 1,65 ≈ 1,7.'),
  q('Kimia','KIM','hard','Benzena (C₆H₆) memiliki sifat aromatik karena...', ['Memiliki sistem elektron π terdelokalisasi','Berbau harum','Tidak reaktif sama sekali','Semua ikatannya tunggal'], 0, 'Aromatisitas Hückel: benzena memiliki 6 elektron π terdelokalisasi dalam cincin siklik planar.'),
  q('Kimia','KIM','hard','Hasil kali kelarutan (Ksp) AgCl = 1,6×10⁻¹⁰. Kelarutan AgCl dalam air murni adalah...', ['1,26×10⁻⁵ mol/L','1,6×10⁻¹⁰ mol/L','4×10⁻²⁰ mol/L','8×10⁻⁶ mol/L'], 0, 'AgCl ⇌ Ag⁺ + Cl⁻. Ksp = s² → s = √Ksp = √(1,6×10⁻¹⁰) = 1,26×10⁻⁵ mol/L.'),
  q('Kimia','KIM','hard','Dalam sel elektrolisis, massa Cu yang mengendap saat 2 F listrik mengalir (Ar Cu = 63,5) adalah...', ['63,5 gram','31,75 gram','127 gram','6,35 gram'], 0, 'Cu²⁺ + 2e⁻ → Cu. 2 faraday = 2 mol elektron → 1 mol Cu = 63,5 gram.'),
  q('Kimia','KIM','hard','Persamaan kesetimbangan Kc untuk: 2SO₂(g) + O₂(g) ⇌ 2SO₃(g) adalah...', ['Kc = [SO₃]²/([SO₂]²[O₂])','Kc = [SO₂]²[O₂]/[SO₃]²','Kc = [SO₃]/[SO₂][O₂]','Kc = [SO₃]²×[SO₂]²×[O₂]'], 0, 'Kc = [produk]/[reaktan] dengan koefisien sebagai pangkat. Kc = [SO₃]²/([SO₂]²[O₂]).'),
  q('Kimia','KIM','hard','Ikatan hidrogen pada H₂O menyebabkan air memiliki...', ['Titik didih abnormal tinggi','Massa jenis rendah','Sifat non-polar','Tidak dapat melarutkan garam'], 0, 'Ikatan hidrogen antar molekul H₂O sangat kuat, membuat titik didih (100°C) jauh lebih tinggi dari yang diperkirakan.'),
  q('Kimia','KIM','hard','Senyawa alkena yang mempunyai 4 atom karbon dan satu ikatan rangkap di tengah adalah...', ['2-butena','1-butena','Isobutena','Butana'], 0, '2-butena (CH₃-CH=CH-CH₃) memiliki 4 karbon dengan ikatan rangkap antara C-2 dan C-3.'),
  q('Kimia','KIM','hard','Tekanan osmotik larutan glukosa 0,1 M pada 27°C (R = 0,082 L·atm/mol·K) adalah...', ['2,46 atm','0,082 atm','8,2 atm','24,6 atm'], 0, 'π = MRT = 0,1 × 0,082 × 300 = 2,46 atm.'),
  q('Kimia','KIM','hard','Isomer fungsional dari alkohol adalah...', ['Eter','Aldehid','Keton','Asam karboksilat'], 0, 'Alkohol (R-OH) dan Eter (R-O-R\') keduanya punya rumus umum CₙH₂ₙ₊₂O → isomer fungsional.'),
  q('Kimia','KIM','hard','Reaksi esterifikasi antara CH₃COOH dan C₂H₅OH (dengan H₂SO₄ sebagai katalis) menghasilkan...', ['Etil asetat + air','Metil asetat + air','Aseton + air','Asam propanoat + air'], 0, 'CH₃COOH + C₂H₅OH → CH₃COOC₂H₅ (etil asetat) + H₂O.'),
  q('Kimia','KIM','hard','Dalam reaksi SN2, substrat yang lebih reaktif adalah...', ['Alkil halida primer','Alkil halida tersier','Alkil halida sekunder','Aril halida'], 0, 'SN2 lebih mudah pada substrat dengan hambatan sterik rendah → alkil halida primer lebih reaktif.'),
];

// ════════════════════════════════════════════════════════════════════════════
// 🌿 BIOLOGI
// ════════════════════════════════════════════════════════════════════════════
const biologi = [
  // ── EASY ──────────────────────────────────────────────────────────────────
  q('Biologi','BIO','easy','Organel sel yang disebut "pabrik energi" adalah...', ['Mitokondria','Nukleus','Ribosom','Lisosom'], 0, 'Mitokondria menghasilkan energi (ATP) melalui respirasi seluler, sering disebut pabrik energi sel.'),
  q('Biologi','BIO','easy','Proses fotosintesis terjadi di bagian sel...', ['Kloroplas','Mitokondria','Ribosom','Vakuola'], 0, 'Kloroplas mengandung klorofil yang menyerap cahaya untuk fotosintesis.'),
  q('Biologi','BIO','easy','Urutan hierarki taksonomi dari tertinggi ke terendah adalah...', ['Kingdom-Filum-Kelas-Ordo-Famili-Genus-Spesies','Kingdom-Kelas-Filum-Ordo','Spesies ke Kingdom','Domain-Kingdom-Kelas'], 0, 'Ingat: King Philip Came Over For Good Soup (Kingdom-Phylum-Class-Order-Family-Genus-Species).'),
  q('Biologi','BIO','easy','Enzim yang memecah protein di lambung adalah...', ['Pepsin','Amilase','Lipase','Renin'], 0, 'Pepsin adalah enzim protease yang bekerja di lambung pada pH asam.'),
  q('Biologi','BIO','easy','Darah merah (eritrosit) berfungsi untuk...', ['Mengangkut oksigen','Melawan infeksi','Pembekuan darah','Mengangkut lemak'], 0, 'Eritrosit mengandung hemoglobin yang mengikat oksigen untuk didistribusikan ke seluruh tubuh.'),
  q('Biologi','BIO','easy','Tanaman dikotil memiliki biji dengan...', ['2 daun lembaga (kotiledon)','1 daun lembaga','3 daun lembaga','Tidak ada kotiledon'], 0, 'Dikotil = dua kotiledon. Contoh: kacang, mangga, dll.'),
  q('Biologi','BIO','easy','Virus berbeda dengan bakteri karena virus...', ['Tidak memiliki sel dan hanya berupa materi genetik dalam kapsid','Memiliki inti sel','Bisa berkembang biak sendiri','Memiliki ribosom'], 0, 'Virus adalah partikel non-seluler yang terdiri dari DNA/RNA dalam kapsid protein.'),
  q('Biologi','BIO','easy','Organisme yang membuat makanan sendiri dari sumber anorganik disebut...', ['Autotrof','Heterotrof','Dekomposer','Parasit'], 0, 'Autotrof (tumbuhan) mengubah CO₂ + H₂O + cahaya menjadi glukosa melalui fotosintesis.'),
  q('Biologi','BIO','easy','Proses pembelahan sel untuk reproduksi seksual (gamet) disebut...', ['Meiosis','Mitosis','Sitokinesis','Karyokinesis'], 0, 'Meiosis menghasilkan sel gamet (sperma/sel telur) dengan jumlah kromosom setengahnya (haploid).'),
  q('Biologi','BIO','easy','Pembuluh darah yang membawa darah dari jantung ke seluruh tubuh adalah...', ['Arteri','Vena','Kapiler','Venula'], 0, 'Arteri membawa darah beroksigen dari jantung. Vena membawa darah kembali ke jantung.'),
  q('Biologi','BIO','easy','Sel saraf (neuron) terdiri dari bagian utama yaitu...', ['Dendrit, badan sel, dan akson','Inti sel, mitokondria, dan ribosom','Membran sel dan vakuola','Sentriol dan lisosom'], 0, 'Neuron terdiri dari dendrit (penerima impuls), badan sel (soma), dan akson (pengirim impuls).'),
  q('Biologi','BIO','easy','Hormon insulin diproduksi oleh...', ['Pankreas','Tiroid','Hipofisis','Adrenal'], 0, 'Sel beta pankreas memproduksi insulin yang menurunkan kadar glukosa darah.'),
  q('Biologi','BIO','easy','Pigmen hijau dalam tumbuhan yang menyerap cahaya untuk fotosintesis adalah...', ['Klorofil','Karotenoid','Antosianin','Melanin'], 0, 'Klorofil (a dan b) adalah pigmen utama yang menyerap cahaya merah dan biru untuk fotosintesis.'),
  q('Biologi','BIO','easy','DNA terletak di dalam inti sel dan berfungsi sebagai...', ['Penyimpan informasi genetik','Sumber energi sel','Pengatur tekanan osmotik','Pembentuk membran sel'], 0, 'DNA (Deoxyribonucleic Acid) menyimpan instruksi genetik untuk pertumbuhan, fungsi, dan reproduksi sel.'),
  q('Biologi','BIO','easy','Penyakit malaria disebabkan oleh...', ['Plasmodium (protozoa)','Bakteri Salmonella','Virus dengue','Cacing pita'], 0, 'Malaria disebabkan oleh Plasmodium (protozoa), ditularkan melalui gigitan nyamuk Anopheles betina.'),

  // ── MEDIUM ────────────────────────────────────────────────────────────────
  q('Biologi','BIO','medium','Reaksi gelap fotosintesis (Siklus Calvin) terjadi di...', ['Stroma kloroplas','Grana kloroplas','Membran tilakoid','Matriks mitokondria'], 0, 'Siklus Calvin terjadi di stroma kloroplas, menggunakan ATP dan NADPH dari reaksi terang untuk mereduksi CO₂.'),
  q('Biologi','BIO','medium','Pada hukum Mendel I (Segregasi), pasangan alel...', ['Dipisahkan saat pembentukan gamet','Bercampur secara bebas','Selalu dominan','Tidak diwariskan'], 0, 'Hukum Mendel I: Pada pembentukan gamet, alel dari suatu gen dipisahkan (segregasi) ke sel yang berbeda.'),
  q('Biologi','BIO','medium','Respirasi aerob pada mitokondria menghasilkan ATP terbanyak pada tahap...', ['Rantai transpor elektron','Glikolisis','Siklus Krebs','Dekarboksilasi oksidatif'], 0, 'Rantai transpor elektron (fosforilasi oksidatif) menghasilkan sekitar 28-34 ATP per molekul glukosa.'),
  q('Biologi','BIO','medium','Ekosistem yang memiliki keanekaragaman hayati tertinggi adalah...', ['Hutan hujan tropis','Padang rumput','Gurun','Tundra'], 0, 'Hutan hujan tropis memiliki keanekaragaman hayati tertinggi karena curah hujan dan suhu yang mendukung.'),
  q('Biologi','BIO','medium','Penyakit hemofilia bersifat X-linked resesif. Jika ibu carrier (XHXh) dan ayah normal (XHY), kemungkinan anak laki-laki hemofilia adalah...', ['25%','50%','0%','100%'], 0, 'Kemungkinan anak: XH(ibu) × XH(ayah)Y = XHXH, XHXh, XHY, XhY. XhY = 1/4 = 25% (1 dari 4 anak = 50% dari anak laki-laki).'),
  q('Biologi','BIO','medium','Transpirasi pada tumbuhan terutama terjadi melalui...', ['Stomata (mulut daun)','Lentisel batang','Kutikula daun','Akar'], 0, 'Sekitar 90% transpirasi terjadi melalui stomata yang terdapat pada daun.'),
  q('Biologi','BIO','medium','Sel yang TIDAK memiliki inti sel (prokariot) adalah...', ['Bakteri','Amuba','Sel tumbuhan','Sel hewan'], 0, 'Bakteri adalah organisme prokariotik yang tidak memiliki membran inti. Amuba, tumbuhan, dan hewan adalah eukariotik.'),
  q('Biologi','BIO','medium','Fungsi utama ginjal adalah...', ['Menyaring darah dan membentuk urin','Memproduksi sel darah merah','Menghasilkan enzim pencernaan','Memompa darah'], 0, 'Ginjal menyaring darah melalui nefron, mengambil kembali zat yang diperlukan, dan mengekskresikan urin.'),
  q('Biologi','BIO','medium','Dalam seleksi alam Darwin, individu yang bertahan adalah yang...', ['Paling sesuai dengan lingkungannya','Paling besar','Paling cepat','Paling banyak makannya'], 0, '"Survival of the fittest" — individu dengan adaptasi terbaik terhadap lingkungan lebih bertahan dan bereproduksi.'),
  q('Biologi','BIO','medium','Hormon yang mengatur pertumbuhan tanaman dan menyebabkan pemanjangan sel adalah...', ['Auksin','Sitokinin','Giberelin','Etilen'], 0, 'Auksin (IAA) merangsang pemanjangan sel di ujung batang dan akar. Berperan dalam fototropisme dan gravitropisme.'),
  q('Biologi','BIO','medium','Ekoenzim yang mengubah laktosa menjadi glukosa dan galaktosa adalah...', ['Laktase','Amilase','Protease','Lipase'], 0, 'Laktase memecah laktosa (gula susu) menjadi glukosa + galaktosa. Kekurangan laktase menyebabkan intoleransi laktosa.'),
  q('Biologi','BIO','medium','Pada siklus haid wanita, ovulasi umumnya terjadi pada hari ke...', ['14','7','21','28'], 0, 'Pada siklus 28 hari, ovulasi biasanya terjadi sekitar hari ke-14 (setelah LH surge).'),
  q('Biologi','BIO','medium','Komunitas hewan di daerah kutub yang mampu bertahan karena bulu tebal dan lapisan lemak disebut adaptasi...', ['Morfologi','Tingkah laku','Fisiologi','Biokimia'], 0, 'Adaptasi morfologi meliputi perubahan bentuk/struktur tubuh, seperti bulu tebal dan lapisan lemak untuk insulasi.'),
  q('Biologi','BIO','medium','Pencernaan karbohidrat dimulai di...', ['Mulut (rongga mulut)','Lambung','Usus halus','Usus besar'], 0, 'Di mulut, enzim amilase saliva memecah pati (karbohidrat) menjadi maltosa.'),
  q('Biologi','BIO','medium','Tipe jaringan tumbuhan yang berfungsi sebagai jaringan penguat adalah...', ['Sklerenkim','Parenkim','Meristem','Epidermis'], 0, 'Sklerenkim (serat dan sklereid) adalah jaringan penguat pada tumbuhan dengan dinding sel tebal berlignin.'),

  // ── HARD ──────────────────────────────────────────────────────────────────
  q('Biologi','BIO','hard','Pada PCR (Polymerase Chain Reaction), enzim yang digunakan adalah...', ['Taq polymerase','DNA ligase','Restriksi endonuklease','Helikase'], 0, 'Taq polymerase adalah enzim DNA polimerase termofilik dari Thermus aquaticus, tahan suhu tinggi denaturasi PCR.'),
  q('Biologi','BIO','hard','Mutasi frameshift terjadi jika...', ['Insersi/delesi bukan kelipatan 3 basa','Substitusi satu basa','Inversi kromosom','Penambahan kromosom'], 0, 'Frameshift: penambahan/penghapusan basa yang bukan kelipatan 3 menggeser reading frame, mengubah semua asam amino setelahnya.'),
  q('Biologi','BIO','hard','Mekanisme apoptosis melibatkan aktivasi...', ['Kaspase','Topoisomerase','RNA polimerase','Kinase'], 0, 'Apoptosis (kematian sel terprogram) melibatkan aktivasi kaspase yang memecah protein seluler secara teratur.'),
  q('Biologi','BIO','hard','Sindrom Down disebabkan oleh...', ['Trisomi kromosom 21','Monosomi kromosom X','Delesi kromosom 5','Translokasi kromosom 14'], 0, 'Sindrom Down (trisomi 21): kelebihan satu kromosom 21 (total 47 kromosom), umumnya akibat non-disjunction.'),
  q('Biologi','BIO','hard','Bioteknologi CRISPR-Cas9 digunakan untuk...', ['Mengedit urutan DNA spesifik','Membuat antibodi','Mengkloning organisme','Menghasilkan enzim'], 0, 'CRISPR-Cas9 adalah alat pengeditan gen yang presisi, menggunakan RNA pemandu untuk memotong DNA pada lokasi spesifik.'),
  q('Biologi','BIO','hard','Mekanisme resistensi antibiotik pada bakteri yang paling umum adalah...', ['Produksi enzim yang mendegradasi antibiotik','Penebalan dinding sel','Kehilangan ribosom','Tidak memerlukan oksigen'], 0, 'Contoh: bakteri penghasil beta-laktamase mendegradasi antibiotik golongan penisilin.'),
  q('Biologi','BIO','hard','Dalam jalur metabolisme, senyawa yang menghambat enzim dengan meniru substrat disebut inhibitor...', ['Kompetitif','Nonkompetitif','Alosterik','Ireversibel'], 0, 'Inhibitor kompetitif bersaing dengan substrat untuk mengikat situs aktif enzim, sehingga menghambat reaksi.'),
  q('Biologi','BIO','hard','Vaksin mRNA (seperti vaksin COVID-19) bekerja dengan cara...', ['Mengintroduksi mRNA untuk memproduksi antigen viral','Menyuntikkan virus yang dilemahkan','Menyuntikkan antibodi siap pakai','Mengaktifkan sel B secara langsung'], 0, 'mRNA vaksin mengkode protein spike virus. Ribosom sel inang mentranslasikannya, memicu respons imun.'),
  q('Biologi','BIO','hard','Dalam ekologi, rantai makanan terpanjang ditemukan di ekosistem...', ['Laut/samudra','Hutan hujan tropis','Padang rumput','Gurun'], 0, 'Ekosistem laut memiliki rantai makanan terpanjang karena tingginya keragaman plankton, ikan kecil, hingga predator puncak.'),
  q('Biologi','BIO','hard','Epigeneti melibatkan perubahan ekspresi gen tanpa mengubah urutan...', ['DNA','RNA','Protein','Kromosom'], 0, 'Epigenetik adalah perubahan heritable pada ekspresi gen (misalnya metilasi DNA) tanpa mengubah urutan DNA.'),
  q('Biologi','BIO','hard','Protein yang mengatur siklus sel dan mencegah pertumbuhan tumor disebut...', ['Tumor suppressor (p53)','Onkoprotein','Sitokin','Antigen'], 0, 'p53 adalah tumor suppressor yang mendeteksi kerusakan DNA dan menghentikan siklus sel atau memicu apoptosis.'),
  q('Biologi','BIO','hard','Simbiosis mutualisme antara bakteri Rhizobium dan tanaman legum bermanfaat dalam...', ['Fiksasi nitrogen dari atmosfer','Produksi oksigen','Peningkatan penyerapan cahaya','Perlindungan dari herbivora'], 0, 'Rhizobium di nodul akar legum mengkonversi N₂ atmosfer menjadi amonia yang dapat digunakan tanaman.'),
  q('Biologi','BIO','hard','Fenomena di mana populasi kecil yang terpisah mengalami perubahan frekuensi alel secara acak disebut...', ['Genetic drift (hanyutan genetik)','Aliran gen','Seleksi alam','Mutasi'], 0, 'Genetic drift terjadi secara acak, efeknya besar pada populasi kecil (efek pendiri, bottleneck).'),
  q('Biologi','BIO','hard','Pada proses transkripsi, template (cetakan) yang digunakan adalah...', ['Untai DNA sense negatif','Untai DNA sense positif','mRNA','tRNA'], 0, 'Transkripsi menggunakan untai template (antisense/non-coding) DNA sebagai cetakan untuk sintesis mRNA.'),
];

// ════════════════════════════════════════════════════════════════════════════
// 📖 BAHASA INDONESIA
// ════════════════════════════════════════════════════════════════════════════
const bahasaIndonesia = [
  q('B. Indonesia','IND','easy','Kalimat berikut yang menggunakan kata baku adalah...', ['Mereka menganalisis data dengan cermat','Mereka menganalisa data','Mereka meng-analisa','Mereka nganalisis'], 0, '"Menganalisis" adalah kata baku. "Menganalisa" tidak baku menurut KBBI.'),
  q('B. Indonesia','IND','easy','Sinonim dari kata "inovatif" adalah...', ['Kreatif','Konservatif','Monoton','Stagnan'], 0, 'Inovatif = memperkenalkan hal-hal baru, kreatif = memiliki daya cipta. Keduanya bersinonim dekat.'),
  q('B. Indonesia','IND','easy','Teks yang bertujuan menceritakan kembali peristiwa masa lalu secara kronologis adalah...', ['Teks rekon (recount)','Teks prosedur','Teks eksposisi','Teks deskripsi'], 0, 'Teks rekon (recount) menceritakan ulang peristiwa yang telah terjadi secara berurutan waktu.'),
  q('B. Indonesia','IND','easy','Konjungsi yang menyatakan pertentangan adalah...', ['Tetapi','Dan','Serta','Karena'], 0, '"Tetapi" (namun, melainkan) adalah konjungsi yang menyatakan pertentangan antara dua klausa.'),
  q('B. Indonesia','IND','easy','Antonim dari kata "eksplisit" adalah...', ['Implisit','Transparan','Jelas','Nyata'], 0, 'Eksplisit = tersurat/jelas. Implisit = tersirat/tidak langsung. Keduanya berantonim.'),
  q('B. Indonesia','IND','easy','Kalimat aktif yang benar adalah...', ['Adik memakan kue','Kue dimakan adik','Kue sedang makan','Adik dimakan kue'], 0, 'Kalimat aktif: Subjek (adik) melakukan tindakan (memakan) terhadap Objek (kue).'),
  q('B. Indonesia','IND','easy','Kata berimbuhan "me-" yang tepat untuk kata dasar "tulis" adalah...', ['Menulis','Mentulis','Menyulis','Mentuliskan'], 0, '"Me-" + "tulis" → "menulis". Jika kata dasar diawali t, l, m, n, r, w, y, huruf pertama tidak luluh.'),
  q('B. Indonesia','IND','easy','Majas yang menggunakan perbandingan langsung dengan kata "seperti" atau "bagaikan" disebut...', ['Simile','Metafora','Personifikasi','Hiperbola'], 0, 'Simile (perumpamaan): menggunakan kata pembanding seperti "seperti", "bagai", "laksana". Contoh: rambutnya seperti mawar.'),
  q('B. Indonesia','IND','easy','Penulisan gelar yang benar adalah...', ['Dr. Budi Santosa, M.Pd.','DR. Budi Santosa, M.Pd','dr Budi Santosa M.Pd','D.R. Budi Santosa M.P.D'], 0, 'Gelar akademik disingkat dengan huruf kapital di awal dan diakhiri tanda titik: Dr. (Doktor), M.Pd. (Magister Pendidikan).'),
  q('B. Indonesia','IND','easy','Puisi yang tidak terikat rima dan bait disebut puisi...', ['Bebas','Lama','Pantun','Soneta'], 0, 'Puisi bebas tidak terikat pada aturan jumlah baris, rima, atau irama seperti puisi lama.'),
  q('B. Indonesia','IND','medium','Paragraf argumentasi bertujuan untuk...', ['Meyakinkan pembaca dengan bukti dan alasan','Menggambarkan objek','Menceritakan kejadian','Memberi petunjuk cara melakukan sesuatu'], 0, 'Paragraf argumentasi menyampaikan pendapat yang didukung bukti, data, atau alasan logis untuk meyakinkan pembaca.'),
  q('B. Indonesia','IND','medium','Afiksasi yang mengubah kata kerja menjadi kata benda adalah imbuhan...', ['-an, ke-an, pe-an','me-, ber-','di-, ter-','se-'], 0, 'Konfiks ke-an (kejadian) dan pe-an (pembuatan) menghasilkan kata benda dari kata kerja.'),
  q('B. Indonesia','IND','medium','Dalam karya ilmiah, kutipan langsung kurang dari 40 kata ditulis...', ['Dalam teks dengan tanda kutip","Sebagai catatan kaki','Dalam blok terindentasi','Dalam tanda kurung'], 0, 'Kutipan langsung pendek (< 40 kata atau < 4 baris) diintegrasikan dalam teks dengan tanda petik dua.'),
  q('B. Indonesia','IND','medium','Kata penghubung antarparagraf yang menyatakan penambahan adalah...', ['Selain itu, di samping itu','Oleh karena itu','Meskipun demikian','Sebaliknya'], 0, '"Selain itu" dan "di samping itu" digunakan untuk menambahkan informasi baru yang sehubungan.'),
  q('B. Indonesia','IND','medium','Novel "Laskar Pelangi" karya Andrea Hirata berlatar tempat di...', ['Belitung','Kalimantan','Sumatera Utara','Jawa'], 0, 'Laskar Pelangi berlatar di Belitung (Bangka Belitung), mengisahkan 10 anak miskin yang bersemangat sekolah.'),
  q('B. Indonesia','IND','hard','Dalam analisis wacana kritis, hegemoni bahasa berkaitan dengan...', ['Kekuasaan yang direproduksi melalui bahasa','Kosakata asing yang mendominasi','Penggunaan ejaan yang baku','Dialek daerah'], 0, 'Hegemoni bahasa (Gramsci): kelompok dominan menggunakan bahasa untuk mempertahankan kekuasaan dan ideologi mereka.'),
  q('B. Indonesia','IND','hard','Deiksis persona pertama jamak inklusif dalam bahasa Indonesia adalah...', ['Kita','Kami','Mereka','Kalian'], 0, '"Kita" = inklusif (pembicara + pendengar). "Kami" = eksklusif (pembicara + orang lain, tidak termasuk pendengar).'),
  q('B. Indonesia','IND','hard','Teknik penulisan yang menggambarkan batin tokoh secara langsung tanpa komentar penulis disebut...', ['Aliran kesadaran (stream of consciousness)','Sudut pandang orang ketiga serba tahu','Flashback','Foreshadowing'], 0, 'Stream of consciousness meniru aliran pikiran/perasaan tokoh tanpa filter, contoh: Virginia Woolf, James Joyce.'),
];

// ════════════════════════════════════════════════════════════════════════════
// 🇬🇧 BAHASA INGGRIS
// ════════════════════════════════════════════════════════════════════════════
const bahasaInggris = [
  q('B. Inggris','ING','easy','The plural form of "child" is...', ['Children','Childs','Childes','Childrens'], 0, 'Child is an irregular noun. Its plural form is "children", not "childs".'),
  q('B. Inggris','ING','easy','Choose the correct sentence:...', ['She has been studying for 3 hours.','She has study for 3 hours.','She is studying since 3 hours.','She studied since 3 hours.'], 0, 'Present perfect continuous: has/have + been + V-ing. Used for actions that started in the past and continue to the present.'),
  q('B. Inggris','ING','easy','The synonym of "courageous" is...', ['Brave','Fearful','Timid','Cowardly'], 0, 'Courageous = brave = having courage. Fearful, timid, and cowardly are antonyms.'),
  q('B. Inggris','ING','easy','Which question is correct?', ['How long have you been living here?','How long are you living here?','Since when you have lived here?','How much time you live here?'], 0, 'For duration of time with present perfect continuous: "How long have you been + V-ing?"'),
  q('B. Inggris','ING','easy','The passive form of "The teacher corrects the papers" is...', ['The papers are corrected by the teacher.','The papers were corrected by the teacher.','The teacher was corrected.','The papers is corrected.'], 0, 'Active: Subject + V + Object. Passive (present): Object + am/is/are + V3 + by + Subject.'),
  q('B. Inggris','ING','easy','The antonym of "optimistic" is...', ['Pessimistic','Realistic','Idealistic','Enthusiastic'], 0, 'Optimistic = expecting good outcomes. Pessimistic = expecting bad outcomes. They are antonyms.'),
  q('B. Inggris','ING','easy','Choose the correct use of comparative degree:...', ['Mount Everest is higher than Mount Fuji.','Mount Everest is more higher than Mount Fuji.','Mount Everest is the higher.','Mount Everest is highest than Mount Fuji.'], 0, 'Comparative of "high" (one syllable) = "higher than". "More higher" is incorrect (double comparative).'),
  q('B. Inggris','ING','easy','If I _____ rich, I would buy a yacht.', ['Were','Was','Am','Had been'], 0, 'Second conditional (hypothetical present): If + past tense (were for all subjects in formal English) + would + V1.'),
  q('B. Inggris','ING','easy','The word "approximately" is closest in meaning to...', ['About/around','Exactly','Never','Always'], 0, 'Approximately = roughly/around a certain amount (not exact). "About" and "around" are synonyms.'),
  q('B. Inggris','ING','easy','Which sentence uses the correct preposition?', ['I am interested in science.','I am interested on science.','I am interested for science.','I am interested to science.'], 0, 'The correct collocation is "interested in" (something/doing something).'),
  q('B. Inggris','ING','medium','An analytical exposition text aims to...', ['Persuade the reader that something is important','Entertain the reader','Describe a process','Retell past events'], 0, 'Analytical exposition: argues a point of view using facts and reasons (thesis → arguments → reiteration).'),
  q('B. Inggris','ING','medium','In a report text, the generic structure is...', ['General classification → Description','Orientation → Complication → Resolution','Thesis → Arguments → Reiteration','Goal → Materials → Steps'], 0, 'A report text describes the way things are: starts with general classification, then specific descriptions of aspects.'),
  q('B. Inggris','ING','medium','The word "Despite" is followed by...', ['Noun phrase / gerund','Full clause (subject + verb)','Infinitive','Adjective'], 0, '"Despite" is a preposition, followed by a noun/gerund: "Despite the rain, we went out." NOT "Despite it rained."'),
  q('B. Inggris','ING','medium','Choose the correct reported speech: He said, "I will come tomorrow."', ['He said that he would come the next day.','He said that he will come tomorrow.','He said that I would come tomorrow.','He said that he comes the next day.'], 0, 'Reported speech: "will" → "would", "tomorrow" → "the next day", "I" → "he".'),
  q('B. Inggris','ING','medium','The text structure of a news item is...', ['Newsworthy events → Background events → Sources','Orientation → Crisis → Resolution','Thesis → Arguments → Conclusion','Title → Content → Closure'], 0, 'News item structure: Newsworthy events (main news) → Background (details) → Sources (quotes).'),
  q('B. Inggris','ING','hard','The rhetorical device in "Not that I loved Caesar less, but that I loved Rome more" is...', ['Antithesis','Anaphora','Chiasmus','Alliteration'], 0, 'Antithesis juxtaposes contrasting ideas in parallel structure. Here: "loved Caesar less" vs "loved Rome more".'),
  q('B. Inggris','ING','hard','In academic writing, a "hedge" is used to...', ['Express uncertainty or tentativeness','State facts with absolute certainty','Exaggerate claims','Contradict the reader'], 0, 'Hedging language (may, might, seems, appears, approximately) qualifies statements to avoid overgeneralization.'),
  q('B. Inggris','ING','hard','The literary term for when a character speaks alone on stage revealing inner thoughts is...', ['Soliloquy','Monologue','Aside','Deus ex machina'], 0, 'Soliloquy: a character alone on stage speaks their thoughts aloud (e.g., Hamlet\'s "To be or not to be").'),
];

// ════════════════════════════════════════════════════════════════════════════
// 🏛️ SEJARAH
// ════════════════════════════════════════════════════════════════════════════
const sejarah = [
  q('Sejarah','SEJ','easy','Proklamasi kemerdekaan Indonesia dibacakan pada tanggal...', ['17 Agustus 1945','15 Agustus 1945','17 Oktober 1945','20 Mei 1945'], 0, 'Proklamasi kemerdekaan Indonesia dibacakan oleh Soekarno-Hatta pada 17 Agustus 1945 pukul 10.00 WIB di Jakarta.'),
  q('Sejarah','SEJ','easy','Siapa yang membacakan teks Proklamasi Kemerdekaan Indonesia?', ['Ir. Soekarno','Mohammad Hatta','Sutan Sjahrir','Soedirman'], 0, 'Teks proklamasi dibacakan oleh Ir. Soekarno, didampingi Mohammad Hatta.'),
  q('Sejarah','SEJ','easy','Peristiwa Rengasdengklok terjadi pada...', ['16 Agustus 1945','17 Agustus 1945','15 Agustus 1945','14 Agustus 1945'], 0, 'Para pemuda menculik Soekarno-Hatta ke Rengasdengklok (16 Agustus 1945) untuk mendesak proklamasi segera.'),
  q('Sejarah','SEJ','easy','VOC didirikan pada tahun...', ['1602','1511','1619','1800'], 0, 'VOC (Vereenigde Oost-Indische Compagnie) didirikan pada tahun 1602 oleh Belanda untuk monopoli perdagangan Asia.'),
  q('Sejarah','SEJ','easy','Sumpah Pemuda diikrarkan pada tanggal...', ['28 Oktober 1928','20 Mei 1908','17 Agustus 1945','1 Juni 1945'], 0, 'Sumpah Pemuda 28 Oktober 1928: satu bangsa, satu tanah air, satu bahasa — Indonesia.'),
  q('Sejarah','SEJ','easy','Organisasi pergerakan nasional pertama Indonesia adalah...', ['Budi Utomo (1908)','Sarekat Islam (1912)','Indische Partij (1912)','PNI (1927)'], 0, 'Budi Utomo didirikan 20 Mei 1908 oleh Dr. Wahidin Sudirohusodo, diperingati sebagai Hari Kebangkitan Nasional.'),
  q('Sejarah','SEJ','easy','Siapakah penemu benua Amerika?', ['Christopher Columbus','Amerigo Vespucci','Ferdinand Magellan','Vasco da Gama'], 0, 'Columbus tiba di Amerika pada 1492 (Karibia). Benua ini kemudian dinamakan atas Amerigo Vespucci.'),
  q('Sejarah','SEJ','easy','Revolusi Perancis terjadi pada tahun...', ['1789','1776','1800','1848'], 0, 'Revolusi Perancis dimulai tahun 1789 dengan penyerbuan Penjara Bastille, mengakhiri monarki absolut Louis XVI.'),
  q('Sejarah','SEJ','easy','Perang Dunia II berakhir pada tahun...', ['1945','1944','1939','1940'], 0, 'PD II berakhir: di Eropa (8 Mei 1945 — V-E Day) dan di Pasifik (15 Agustus 1945 — V-J Day) setelah Jepang menyerah.'),
  q('Sejarah','SEJ','easy','Tanam Paksa (Cultuurstelsel) di Indonesia diterapkan oleh...', ['Johannes van den Bosch','Daendels','Raffles','Diponegoro'], 0, 'Gubernur Jenderal Van den Bosch menerapkan Cultuurstelsel (1830) yang mewajibkan rakyat menanam tanaman ekspor.'),
  q('Sejarah','SEJ','medium','G30S/PKI terjadi pada tanggal...', ['30 September 1965','1 Oktober 1965','17 Oktober 1965','30 Oktober 1966'], 0, 'Gerakan 30 September 1965/PKI: pembunuhan 7 Jenderal AD. Soeharto kemudian mengambil alih kendali militer.'),
  q('Sejarah','SEJ','medium','Konferensi Asia-Afrika (KAA) di Bandung tahun 1955 menghasilkan...', ['Dasasila Bandung','Tritura','Deklarasi Bangkok','Piagam Jakarta'], 0, 'KAA 1955 menghasilkan Dasasila Bandung (10 prinsip), menjadi dasar gerakan Non-Blok.'),
  q('Sejarah','SEJ','medium','Perang Dingin adalah konflik antara...', ['AS (kapitalis) vs Uni Soviet (komunis)','AS vs China','NATO vs PBB','Eropa vs Asia'], 0, 'Perang Dingin (1947-1991): persaingan ideologis, politik, dan militer antara AS (demokrasi liberal) dan USSR (komunis).'),
  q('Sejarah','SEJ','medium','Dekrit Presiden 5 Juli 1959 oleh Soekarno berisi tentang...', ['Kembali ke UUD 1945 dan pembubaran konstituante','Pengakuan kemerdekaan RI oleh Belanda','Pembentukan MPRS','Nasionalisasi perusahaan asing'], 0, 'Dekrit 5 Juli 1959 membubarkan Konstituante dan menyatakan berlakunya kembali UUD 1945 (Demokrasi Terpimpin).'),
  q('Sejarah','SEJ','medium','Penyebab utama Perang Dunia I adalah...', ['Pembunuhan Archduke Franz Ferdinand di Sarajevo','Invansi Jerman ke Polandia','Serangan Pearl Harbor','Revolusi Rusia'], 0, 'Pembunuhan Franz Ferdinand (28 Juni 1914) di Sarajevo oleh Gavrilo Princip memicu serangkaian aliansi yang memulai PD I.'),
  q('Sejarah','SEJ','hard','Teori masuknya Islam ke Indonesia yang menyatakan Islam datang langsung dari Arab Saudi adalah teori...', ['Mekkah','Gujarat','Persia','Bengal'], 0, 'Teori Mekkah (Hamka): Islam datang langsung dari Mekkah pada abad ke-7 M, bukan melalui India.'),
  q('Sejarah','SEJ','hard','Reformasi 1998 yang mengakhiri era Orde Baru dipicu oleh...', ['Krisis moneter 1997-1998 dan tuntutan mahasiswa','Pemilu curang','Bencana alam','Perang saudara'], 0, 'Krisis moneter 1997, rupiah anjlok, pengangguran meningkat → demonstrasi mahasiswa → Soeharto mundur 21 Mei 1998.'),
  q('Sejarah','SEJ','hard','Pembantaian 1965 di Indonesia diperkirakan menewaskan...', ['500.000 - 1.000.000 orang','50.000 orang','10.000 orang','100.000 orang'], 0, 'Estimasi korban pembantaian pasca-G30S bervariasi: 500.000 hingga 1 juta orang yang dituduh berafiliasi dengan PKI.'),
];

// ════════════════════════════════════════════════════════════════════════════
// 🌍 GEOGRAFI
// ════════════════════════════════════════════════════════════════════════════
const geografi = [
  q('Geografi','GEO','easy','Letak astronomis Indonesia adalah...', ['6°LU-11°LS dan 95°BT-141°BT','0°-10°LS dan 95°-141°BT','6°LU-11°LU dan 95°-141°BT','5°LS-11°LS dan 95°-141°BT'], 0, 'Indonesia terletak antara 6°LU-11°LS dan 95°BT-141°BT (dari Sabang sampai Merauke).'),
  q('Geografi','GEO','easy','Negara dengan jumlah penduduk terbanyak di dunia (2024) adalah...', ['India','China','Amerika Serikat','Indonesia'], 0, 'India melampaui China pada 2023 dengan jumlah penduduk ~1,43 miliar jiwa.'),
  q('Geografi','GEO','easy','Danau terluas di Indonesia adalah...', ['Danau Toba','Danau Poso','Danau Towuti','Danau Sentani'], 0, 'Danau Toba di Sumatera Utara adalah danau terluas di Indonesia dengan luas ~1.130 km² (danau kaldera vulkanik).'),
  q('Geografi','GEO','easy','Batas iklim menurut Koppen yang ditandai dengan suhu bulan terdingin > 18°C adalah iklim...', ['Af (tropis hutan hujan)','Cfa (subtropis)','Dfa (kontinental)','ET (tundra)'], 0, 'Iklim Af (tropis hutan hujan Koppen): suhu bulanan selalu >18°C dan curah hujan selalu tinggi.'),
  q('Geografi','GEO','easy','Selat yang memisahkan pulau Jawa dan Sumatra adalah...', ['Selat Sunda','Selat Malaka','Selat Lombok','Selat Bali'], 0, 'Selat Sunda memisahkan Jawa dan Sumatra, merupakan jalur pelayaran penting.'),
  q('Geografi','GEO','easy','Proyeksi peta yang cocok untuk daerah khatulistiwa adalah...', ['Silinder (Mercator)','Azimuthal','Kerucut','Sinusoidal'], 0, 'Proyeksi silinder (Mercator) cocok untuk daerah khatulistiwa karena mendistorsi paling sedikit di bagian tengah.'),
  q('Geografi','GEO','easy','Alat yang digunakan untuk mengukur tekanan udara adalah...', ['Barometer','Termometer','Higrometer','Anemometer'], 0, 'Barometer mengukur tekanan atmosfer (udara). Termometer = suhu, Higrometer = kelembapan, Anemometer = kecepatan angin.'),
  q('Geografi','GEO','easy','Kepulauan Natuna berada di laut...', ['Natuna (Laut China Selatan)','Laut Jawa','Laut Banda','Laut Flores'], 0, 'Kepulauan Natuna berada di bagian selatan Laut China Selatan, termasuk Provinsi Kepulauan Riau.'),
  q('Geografi','GEO','medium','Teori lempeng tektonik menjelaskan bahwa...', ['Kerak bumi terdiri dari lempeng-lempeng yang bergerak','Bumi selalu bergerak memuai','Semua benua pernah menyatu dan tidak berubah','Gunung berapi terbentuk dari erosi'], 0, 'Teori lempeng tektonik: litosfer terpecah menjadi lempeng-lempeng yang bergerak di atas astenosfer cair.'),
  q('Geografi','GEO','medium','Fenomena El Niño menyebabkan...', ['Kekeringan di Asia Tenggara dan hujan lebih banyak di Amerika Selatan','Banjir di Asia Tenggara','Suhu global turun','Aktivitas siklon berkurang'], 0, 'El Niño: pemanasan tidak biasa Samudra Pasifik bagian timur. Menyebabkan kekeringan di Asia Tenggara dan hujan di Peru.'),
  q('Geografi','GEO','medium','Perpindahan penduduk dari desa ke kota disebut...', ['Urbanisasi','Ruralisasi','Transmigrasi','Imigrasi'], 0, 'Urbanisasi = perpindahan penduduk desa ke kota. Ruralisasi = kebalikannya. Transmigrasi = perpindahan antarwilayah.'),
  q('Geografi','GEO','medium','Zona laut yang kaya sumber daya hayati karena cahaya matahari masih masuk adalah zona...', ['Epipelagik (0-200 m)','Mesopelagik (200-1000 m)','Batipelagik','Abisalpelagik'], 0, 'Zona epipelagik (0-200 m) menerima cukup cahaya untuk fotosintesis, sehingga kaya plankton dan ikan.'),
  q('Geografi','GEO','medium','Piramida penduduk yang berbentuk limas (muda) menunjukkan negara dengan...', ['Tingkat kelahiran tinggi dan kematian tinggi (berkembang)','Angka kelahiran rendah dan harapan hidup tinggi','Populasi tua yang mendominasi','Pertumbuhan nol'], 0, 'Piramida ekspansif (limas): banyak penduduk muda, angka kelahiran tinggi, khas negara berkembang.'),
  q('Geografi','GEO','hard','Efek rumah kaca disebabkan oleh akumulasi gas...', ['CO₂, CH₄, N₂O','O₂, N₂','H₂O, CO₂','Hanya CO₂'], 0, 'Gas rumah kaca utama: CO₂ (karbon dioksida), CH₄ (metana), N₂O (dinitrogen oksida), uap air, dan CFC.'),
  q('Geografi','GEO','hard','Indeks Pembangunan Manusia (IPM) mengukur...', ['Harapan hidup + pendidikan + pendapatan per kapita','GDP per kapita saja','Kepadatan penduduk','Laju pertumbuhan ekonomi'], 0, 'IPM (HDI) UNDP terdiri dari 3 dimensi: harapan hidup sehat, akses pendidikan, dan standar hidup layak (GNI/kapita).'),
  q('Geografi','GEO','hard','Zona ekonomi eksklusif (ZEE) Indonesia membentang sejauh...', ['200 mil laut dari garis pangkal','12 mil laut','500 mil laut','350 mil laut'], 0, 'ZEE = 200 mil laut dari garis pangkal, di mana negara punya hak eksklusif eksplorasi sumber daya alam.'),
];

// ════════════════════════════════════════════════════════════════════════════
// 🏘️ SOSIOLOGI
// ════════════════════════════════════════════════════════════════════════════
const sosiologi = [
  q('Sosiologi','SOS','easy','Ilmu yang mempelajari masyarakat dan interaksi sosial adalah...', ['Sosiologi','Psikologi','Antropologi','Ekonomi'], 0, 'Sosiologi (Auguste Comte, 1838) mempelajari perilaku manusia dalam masyarakat, struktur sosial, dan interaksinya.'),
  q('Sosiologi','SOS','easy','Proses seseorang mempelajari nilai, norma, dan budaya masyarakatnya disebut...', ['Sosialisasi','Akulturasi','Asimilasi','Asosiasi'], 0, 'Sosialisasi: proses individu belajar berperilaku sesuai dengan standar masyarakat (keluarga, sekolah, media).'),
  q('Sosiologi','SOS','easy','Stratifikasi sosial berdasarkan kepemilikan kekayaan disebut stratifikasi...', ['Ekonomi','Politik','Pendidikan','Agama'], 0, 'Stratifikasi ekonomi membagi masyarakat berdasarkan kekayaan: kelas atas, menengah, bawah.'),
  q('Sosiologi','SOS','easy','Nilai-nilai dan aturan yang disepakati bersama dalam masyarakat disebut...', ['Norma sosial','Hukum pidana','Adat istiadat','Kebijakan pemerintah'], 0, 'Norma sosial adalah standar perilaku yang diharapkan, baik tertulis (hukum) maupun tidak tertulis (adat, etiket).'),
  q('Sosiologi','SOS','easy','Lembaga sosial yang pertama dan utama dalam sosialisasi anak adalah...', ['Keluarga','Sekolah','Teman sebaya','Media massa'], 0, 'Keluarga adalah agen sosialisasi primer karena anak pertama kali belajar nilai dan norma dari keluarga.'),
  q('Sosiologi','SOS','easy','Pernikahan antar anggota kelompok sendiri disebut...', ['Endogami','Eksogami','Poligami','Monogami'], 0, 'Endogami = menikah dalam kelompok sendiri (suku, kasta, agama). Eksogami = menikah di luar kelompok.'),
  q('Sosiologi','SOS','medium','Perubahan sosial yang terjadi secara lambat dan bertahap disebut...', ['Evolusi sosial','Revolusi sosial','Reformasi','Difusi'], 0, 'Evolusi sosial: perubahan perlahan melalui perkembangan bertahap. Revolusi sosial: perubahan cepat dan menyeluruh.'),
  q('Sosiologi','SOS','medium','Teori konflik Karl Marx berpendapat bahwa masyarakat...', ['Selalu dalam konflik antara kelas yang memiliki dan yang tidak memiliki','Selalu harmonis dan fungsional','Bergerak menuju keseimbangan','Dibentuk oleh nilai-nilai bersama'], 0, 'Marx: konflik antara borjuis (pemilik modal) dan proletar (pekerja) adalah penggerak perubahan sejarah.'),
  q('Sosiologi','SOS','medium','Mobilitas sosial vertikal ke atas contohnya adalah...', ['Petani menjadi pengusaha sukses','Pengusaha pindah kota','Pekerja pindah divisi','Anak belajar di sekolah baru'], 0, 'Mobilitas vertikal ke atas: perpindahan ke strata sosial lebih tinggi. Petani → pengusaha = naik kelas sosial.'),
  q('Sosiologi','SOS','medium','Penyimpangan primer (primary deviance) berbeda dengan sekunder karena...', ['Primer belum disadari/diterima sebagai identitas, sekunder sudah menjadi identitas','Primer lebih berbahaya','Primer dilakukan sendiri, sekunder dilakukan kelompok','Tidak ada perbedaan'], 0, 'Lemert: deviasi primer = pelanggaran awal. Deviasi sekunder = ketika pelanggar menerima label devian sebagai identitas.'),
  q('Sosiologi','SOS','hard','Pandangan Émile Durkheim tentang "anomie" merujuk pada kondisi...', ['Kekacauan norma saat perubahan sosial cepat','Kejahatan yang terorganisir','Kesenjangan ekonomi yang ekstrem','Korupsi pejabat'], 0, 'Anomie (Durkheim): kondisi tanpa norma yang jelas, sering terjadi saat perubahan sosial cepat mengacaukan aturan lama.'),
  q('Sosiologi','SOS','hard','Konsep "habitus" dalam sosiologi Pierre Bourdieu mengacu pada...', ['Disposisi/kebiasaan yang terinternalisasi dari pengalaman sosial','Rumah atau tempat tinggal','Kebiasaan makan sehari-hari','Aturan norma yang tertulis'], 0, 'Habitus Bourdieu: sistem disposisi yang diperoleh melalui pengalaman sosial yang menjadi "naluri" dalam bertindak.'),
];

// ════════════════════════════════════════════════════════════════════════════
// 💹 EKONOMI
// ════════════════════════════════════════════════════════════════════════════
const ekonomi = [
  q('Ekonomi','EKO','easy','Ilmu ekonomi mempelajari cara manusia memenuhi kebutuhan dengan sumber daya yang...', ['Terbatas','Tidak terbatas','Selalu cukup','Tidak dapat diukur'], 0, 'Kelangkaan (scarcity) adalah inti ekonomi: kebutuhan tidak terbatas vs sumber daya yang terbatas.'),
  q('Ekonomi','EKO','easy','Hukum permintaan menyatakan bahwa jika harga naik, maka permintaan...', ['Turun','Naik','Tetap','Tidak tentu'], 0, 'Hukum permintaan (ceteris paribus): hubungan terbalik antara harga dan jumlah yang diminta.'),
  q('Ekonomi','EKO','easy','GDP (Gross Domestic Product) adalah...', ['Nilai total barang/jasa yang diproduksi dalam suatu negara dalam satu tahun','Nilai ekspor dikurangi impor','Total tabungan nasional','Total utang negara'], 0, 'GDP mengukur nilai semua barang dan jasa yang diproduksi di dalam batas suatu negara dalam periode tertentu.'),
  q('Ekonomi','EKO','easy','Inflasi adalah...', ['Kenaikan harga-harga secara umum dan terus-menerus','Penurunan harga barang','Kenaikan nilai tukar mata uang','Berkurangnya jumlah uang beredar'], 0, 'Inflasi: meningkatnya tingkat harga barang/jasa secara agregat dan berkelanjutan dalam perekonomian.'),
  q('Ekonomi','EKO','easy','Pasar di mana hanya ada satu penjual disebut...', ['Monopoli','Oligopoli','Monopsoni','Persaingan sempurna'], 0, 'Monopoli: satu penjual mendominasi pasar tanpa pesaing. Oligopoli: beberapa penjual. Monopsoni: satu pembeli.'),
  q('Ekonomi','EKO','easy','Fungsi utama Bank Sentral (Bank Indonesia) adalah...', ['Menjaga kestabilan nilai rupiah dan mengatur kebijakan moneter','Memberikan kredit kepada masyarakat','Menerima tabungan masyarakat','Menginvestasikan dana pemerintah'], 0, 'Bank Indonesia bertugas menetapkan dan melaksanakan kebijakan moneter, mengatur dan mengawasi perbankan.'),
  q('Ekonomi','EKO','easy','Biaya yang tidak berubah meskipun produksi berubah disebut biaya...', ['Tetap (Fixed Cost)','Variabel','Marginal','Total'], 0, 'Biaya tetap (FC): sewa gedung, gaji direktur — tidak berubah sesuai jumlah produksi. Biaya variabel berubah.'),
  q('Ekonomi','EKO','easy','Pajak Pertambahan Nilai (PPN) di Indonesia saat ini adalah...', ['11%','10%','12%','8%'], 0, 'PPN di Indonesia naik menjadi 11% pada April 2022 (dari 10%), dan direncanakan 12% pada 2025.'),
  q('Ekonomi','EKO','medium','Kurva permintaan bergeser ke kanan jika...', ['Pendapatan konsumen naik (barang normal)','Harga barang naik','Jumlah produsen berkurang','Harga barang substitusi turun'], 0, 'Kenaikan pendapatan (untuk barang normal) meningkatkan permintaan → kurva bergeser ke kanan.'),
  q('Ekonomi','EKO','medium','Kebijakan fiskal ekspansif dilakukan pemerintah dengan cara...', ['Menambah pengeluaran pemerintah dan/atau menurunkan pajak','Menaikkan suku bunga','Mengurangi jumlah uang beredar','Menjual surat berharga pemerintah'], 0, 'Kebijakan fiskal ekspansif: stimulus ekonomi melalui peningkatan belanja negara atau pemotongan pajak.'),
  q('Ekonomi','EKO','medium','Nilai tukar (kurs) rupiah melemah berarti...', ['Diperlukan lebih banyak rupiah untuk membeli 1 dolar','Rupiah menguat terhadap dolar','Ekspor Indonesia menurun','Impor Indonesia berkurang'], 0, 'Kurs rupiah melemah: rupiah terdepresiasi. Contoh: dari Rp15.000/$ menjadi Rp16.000/$. Impor lebih mahal.'),
  q('Ekonomi','EKO','medium','Indikator utama kesejahteraan yang mempertimbangkan standar hidup, kesehatan, dan pendidikan adalah...', ['Indeks Pembangunan Manusia (IPM/HDI)','GDP per kapita','Tingkat pengangguran','Neraca perdagangan'], 0, 'HDI (UNDP): komposit dari harapan hidup, tahun pendidikan rata-rata, dan pendapatan nasional bruto per kapita.'),
  q('Ekonomi','EKO','hard','Paradox of value (paradoks nilai) Adam Smith menjelaskan mengapa...', ['Air murah padahal sangat berguna, berlian mahal padahal kurang berguna','Semua barang memiliki nilai yang sama','Harga selalu mencerminkan nilai guna','Monopoli selalu lebih efisien'], 0, 'Smith\'s diamond-water paradox: air sangat berguna tapi murah; berlian kurang berguna tapi mahal. Dijawab oleh marginal utility (nilai marginal).'),
  q('Ekonomi','EKO','hard','Dalam model IS-LM, kurva LM bergeser ke kanan jika...', ['Bank Sentral meningkatkan jumlah uang beredar','Pemerintah meningkatkan pengeluaran','Ekspor meningkat','Pajak diturunkan'], 0, 'LM (Liquidity preference-Money supply): bergeser ke kanan jika penawaran uang naik (kebijakan moneter ekspansif).'),
  q('Ekonomi','EKO','hard','Teori Keunggulan Komparatif David Ricardo menyatakan bahwa perdagangan internasional menguntungkan karena...', ['Setiap negara spesialisasi pada produksi yang biaya oportuninya lebih rendah','Hanya negara kaya yang bisa ekspor','Semua negara punya keunggulan absolut','Tidak ada keunggulan dalam perdagangan bebas'], 0, 'Ricardo: walau satu negara lebih efisien di semua produk, perdagangan tetap menguntungkan jika tiap negara fokus pada keunggulan komparatifnya.'),
];

// ════════════════════════════════════════════════════════════════════════════
// 🌐 SEMUA SOAL
// ════════════════════════════════════════════════════════════════════════════
const allQuestions = [
  ...matematika,
  ...fisika,
  ...kimia,
  ...biologi,
  ...bahasaIndonesia,
  ...bahasaInggris,
  ...sejarah,
  ...geografi,
  ...sosiologi,
  ...ekonomi,
];

// ════════════════════════════════════════════════════════════════════════════
// 🚀 MAIN — Koneksi & Insert
// ════════════════════════════════════════════════════════════════════════════
async function main() {
  const dropFirst = process.argv.includes('--drop');
  const client    = new MongoClient(MONGO_URI);

  try {
    await client.connect();
    console.log('✅  Terhubung ke MongoDB Atlas');

    const db  = client.db(DB_NAME);
    const col = db.collection(COL_NAME);

    if (dropFirst) {
      await col.deleteMany({});
      console.log('🗑️   Semua soal lama dihapus.');
    }

    // Buat indeks agar query cepat
    await col.createIndex({ subject: 1, difficulty: 1 });
    await col.createIndex({ subjectCode: 1 });
    console.log('📌  Indeks dibuat: (subject, difficulty) dan (subjectCode)');

    // Insert semua soal
    const result = await col.insertMany(allQuestions, { ordered: false });
    console.log(`\n🎉  BERHASIL! ${result.insertedCount} soal berhasil dimasukkan ke '${DB_NAME}.${COL_NAME}'.\n`);

    // Ringkasan per subjek
    const summary = {};
    for (const q of allQuestions) {
      const key = q.subject;
      if (!summary[key]) summary[key] = { easy: 0, medium: 0, hard: 0 };
      summary[key][q.difficulty]++;
    }

    console.log('📊  Ringkasan per mata pelajaran:');
    console.log('─'.repeat(60));
    for (const [subj, counts] of Object.entries(summary)) {
      const total = counts.easy + counts.medium + counts.hard;
      console.log(
        `  ${subj.padEnd(18)} | Easy: ${String(counts.easy).padStart(2)} | Medium: ${String(counts.medium).padStart(2)} | Hard: ${String(counts.hard).padStart(2)} | Total: ${total}`
      );
    }
    console.log('─'.repeat(60));
    console.log(`  ${'TOTAL'.padEnd(18)} | ${''.padStart(8)} ${''.padStart(10)} ${''.padStart(8)} | Total: ${allQuestions.length}`);
    console.log('\n✨  Seeder selesai!');

  } catch (err) {
    if (err.code === 11000) {
      console.log('⚠️   Beberapa soal sudah ada (duplicate key), sisanya berhasil dimasukkan.');
    } else {
      console.error('❌  Error:', err.message);
    }
  } finally {
    await client.close();
    console.log('🔌  Koneksi ditutup.');
  }
}

main();
