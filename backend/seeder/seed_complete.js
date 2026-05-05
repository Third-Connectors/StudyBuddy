// ════════════════════════════════════════════════════════════════════════════
// 🌱 STUDYBUDDY — COMPLETE DATA SEEDER
// ════════════════════════════════════════════════════════════════════════════
// Seeding User Profiles, VAK Questions, Quizzes, and VAK Study Materials.
// ════════════════════════════════════════════════════════════════════════════

require('dotenv').config({ path: '../api-gateway/.env' });
const { MongoClient } = require('mongodb');
const { Client } = require('pg');
const bcrypt = require('bcrypt');
const crypto = require('crypto');

const MONGO_URI = process.env.MONGODB_URI;
const DATABASE_URL = process.env.DATABASE_URL;

if (!MONGO_URI) {
  console.error('❌ MONGODB_URI not found in .env');
  process.exit(1);
}

// ─── POSTGRES DATA (Users, Profiles, Stats) ─────────────────────────────────
const profilesToSeed = [
  {
    email: 'rfrizqifauzan@gmail.com',
    name: 'Rizqi Fauzan',
    role: 'student',
    schoolName: 'SMA Negeri 1 Jakarta',
    gradeLevel: 'XII-MIPA 1',
    learningStyle: 'visual',
    xp: 5200,
    level: 11,
  },
  {
    email: 'rizqifauzan.rf@gmail.com',
    name: 'Rizqi Fauzan RF',
    role: 'student',
    schoolName: 'SMA Negeri 3 Bandung',
    gradeLevel: 'XI-IPS 2',
    learningStyle: 'auditory',
    xp: 3400,
    level: 7,
  },
  {
    email: 'budi@sman9.co.id',
    name: 'Budi Siregar',
    role: 'teacher',
    schoolName: 'SMA Kristen Yusuf',
    gradeLevel: 'XII-MIPA 4',
    learningStyle: 'visual',
    xp: 12000,
    level: 25,
  },
  {
    email: 'rizal.visual@gmail.com',
    name: 'Rizal Hakim',
    role: 'student',
    schoolName: 'SMA Negeri 8 Jakarta',
    gradeLevel: 'XI-MIPA 1',
    learningStyle: 'visual',
    xp: 2800,
    level: 6,
  },
  {
    email: 'dimas.auditory@gmail.com',
    name: 'Dimas Aditya',
    role: 'student',
    schoolName: 'SMK Negeri 1 Bogor',
    gradeLevel: 'XII-RPL 2',
    learningStyle: 'auditory',
    xp: 3200,
    level: 7,
  },
  {
    email: 'andre.kinesthetic@gmail.com',
    name: 'Andre Wijaya',
    role: 'student',
    schoolName: 'SMA LabSchool Jakarta',
    gradeLevel: 'XII-MIPA 3',
    learningStyle: 'kinesthetic',
    xp: 4500,
    level: 9,
  },
  {
    email: 'herry.smart@gmail.com',
    name: 'Herry Prasetyo',
    role: 'student',
    schoolName: 'SMA Negeri 1 Bandung',
    gradeLevel: 'XII-IPS 1',
    learningStyle: 'kinesthetic',
    xp: 6200,
    level: 12,
  },
];

// ─── MONGODB DATA (Study Materials matching VAK) ────────────────────────────
const createMaterial = (title, subject, subjectCode, gradeLevel, content, contentType, difficulty, estimatedMinutes, vakStyles, tags) => ({
  title, subject, subjectCode, gradeLevel, content, contentType,
  difficulty, estimatedMinutes, vakStyles, views: 0, likes: 0,
  isPublished: true, tags, publishedAt: new Date(), createdAt: new Date(), updatedAt: new Date()
});

const materials = [
  // ── 🔬 SEL HEWAN DAN TUMBUHAN
  createMaterial(
    'Visual Mind Map: Sel Hewan dan Tumbuhan',
    'Biologi', 'BIO', 'XI',
    '# Sel Hewan dan Tumbuhan\n\nMind map ini menampilkan struktur organel sel secara spasial.\n\n![Mind Map](https://images.unsplash.com/photo-1530210124550-912dc1381cb8)\n\n**Visual Checklist:**\n- Mitokondria: Berwarna merah/oranye\n- Kloroplas: Berwarna hijau\n- Retikulum Endoplasma: Berwarna ungu melingkar di dekat nukleus.',
    'text', 'easy', 15, ['visual'], ['mindmap', 'sel', 'biologi']
  ),
  createMaterial(
    'Audio Podcast: Struktur Sel Hewan dan Tumbuhan',
    'Biologi', 'BIO', 'XI',
    '# Sel Hewan dan Tumbuhan (Auditory)\n\nAudio monolog interaktif yang menjelaskan perbedaan struktur sel hewan dan tumbuhan melalui pendengaran.\n\n- Mengidentifikasi organel berdasarkan suara atau ritme yang dibacakan keras-keras.\n- Memahami fungsi kloroplas dan dinding sel melalui analogi lisan.',
    'text', 'easy', 18, ['auditory'], ['podcast', 'sel', 'biologi']
  ),
  createMaterial(
    'Praktik 3D: Membuat Model Sel Hewan dan Tumbuhan',
    'Biologi', 'BIO', 'XI',
    '# Sel Hewan dan Tumbuhan (Kinesthetic)\n\n**Aktivitas Fisik:**\n1. Ambil styrofoam atau plastisin.\n2. Bentuk nukleus menggunakan plastisin merah.\n3. Bentuk vakuola besar menggunakan plastisin biru.\n4. Rangkai sel utuh untuk membangun ingatan taktil.',
    'text', 'easy', 35, ['kinesthetic'], ['praktik', 'sel', 'biologi']
  ),

  // ── 🧪 REAKSI REDOKS
  createMaterial(
    'Infografis: Reaksi Redoks dan Elektrokimia',
    'Kimia', 'KIM', 'XII',
    '# Reaksi Redoks (Visual)\n\nInfografis ini menggambarkan alur transfer elektron dalam sel Volta.\n\n![Redoks](https://images.unsplash.com/photo-1532187863486-abf9c34a6214)\n\n- **Katoda**: Kutub positif (+), tempat reduksi.\n- **Anoda**: Kutub negatif (-), tempat oksidasi.',
    'text', 'medium', 20, ['visual'], ['redoks', 'elektrokimia', 'kimia']
  ),
  createMaterial(
    'Audio Podcast: Reaksi Redoks dan Elektrokimia',
    'Kimia', 'KIM', 'XII',
    '# Reaksi Redoks (Auditory)\n\nPanduan diskusi audio tentang konsep reduksi dan oksidasi.\n\n- Dengarkan bagaimana elektron berpindah dari anoda ke katoda.\n- Pembahasan tentang cara menghitung biloks secara naratif.',
    'text', 'medium', 22, ['auditory'], ['podcast', 'redoks', 'kimia']
  ),
  createMaterial(
    'Aktivitas Praktikum: Membuat Baterai dari Lemon (Redoks)',
    'Kimia', 'KIM', 'XII',
    '# Reaksi Redoks (Kinesthetic)\n\n**Aktivitas Kinestetik:**\n1. Sediakan 3 buah lemon, koin tembaga, dan paku seng.\n2. Tusukkan koin dan paku ke dalam lemon.\n3. Hubungkan dengan kabel untuk menghasilkan listrik (Sel Volta).\n4. Ukur tegangannya dengan voltmeter.',
    'text', 'medium', 40, ['kinesthetic'], ['praktik', 'eksperimen', 'kimia']
  ),

  // ── 🏎️ HUKUM NEWTON
  createMaterial(
    'Visual Diagram: Hukum I, II, III Newton',
    'Fisika', 'FIS', 'X',
    '# Hukum Newton (Visual)\n\nBagan alur komprehensif yang membedakan Hukum I, II, dan III Newton dengan grafik vektor gaya.\n\n- Gambar anak panah arah gaya (F).\n- Ilustrasi mobil melaju, orang mengerem, dan gaya pegas.',
    'text', 'easy', 15, ['visual'], ['diagram', 'newton', 'fisika']
  ),
  createMaterial(
    'Podcast Belajar: Memahami Hukum Newton',
    'Fisika', 'FIS', 'X',
    '# Hukum Newton (Auditory)\n\nMateri ini didesain sebagai audio penjelasan lisan.\n\n- **Hukum I Newton**: Benda diam akan tetap diam.\n- **Hukum II Newton**: Percepatan sebanding dengan resultan gaya.\n- **Hukum III Newton**: Aksi = -Reaksi.\n\nCobalah mendengarkan penjelasan ini berulang-ulang atau membacakannya keras-keras.',
    'text', 'easy', 25, ['auditory'], ['hukum-newton', 'fisika', 'podcast']
  ),
  createMaterial(
    'Eksperimen Mandiri: Pembuktian Hukum II Newton dengan Mobil Mainan',
    'Fisika', 'FIS', 'X',
    '# Hukum Newton (Kinesthetic)\n\n**Aktivitas Hands-on:**\n1. Letakkan mobil mainan di lantai.\n2. Dorong perlahan, lalu dorong dengan gaya lebih besar.\n3. Catat bagaimana mobil melaju lebih cepat dengan gaya besar (F = m.a).',
    'text', 'easy', 30, ['kinesthetic'], ['eksperimen', 'newton', 'fisika']
  ),

  // ── 📐 KALKULUS INTEGRAL
  createMaterial(
    'Flowchart Visual: Kalkulus Integral',
    'Matematika', 'MTK', 'XII',
    '# Kalkulus Integral (Visual)\n\nFlowchart berwarna cerah yang menjabarkan teknik integral substitusi dan integral parsial.\n\n- Merah untuk teknik substitusi\n- Biru untuk teknik parsial',
    'text', 'hard', 20, ['visual'], ['flowchart', 'integral', 'matematika']
  ),
  createMaterial(
    'Audio Guide: Berpikir Logis Integral',
    'Matematika', 'MTK', 'XII',
    '# Kalkulus Integral (Auditory)\n\nAudio penjelasan langkah demi langkah dalam menentukan luas daerah di bawah kurva.\n\n- Bagaimana batas bawah dan batas atas diintegrasikan lisan.',
    'text', 'hard', 25, ['auditory'], ['audio', 'integral', 'matematika']
  ),
  createMaterial(
    'Simulasi Langkah-demi-Langkah: Kalkulus Integral',
    'Matematika', 'MTK', 'XII',
    '# Kalkulus Integral (Kinesthetic)\n\n**Latihan Fisik & Prosedural:**\n1. Integralkan f(x) = x² + 2x secara bertahap.\n2. Tuliskan langkah per langkah menggunakan pulpen warna berbeda.\n3. Kerjakan 10 soal latihan tanpa henti untuk membangun muscle memory.',
    'text', 'hard', 35, ['kinesthetic'], ['integral', 'matematika', 'latihan']
  ),
];

// ─── MONGODB DATA (Quizzes with various subjects/styles) ──────────────────────
const createQuiz = (title, subject, subjectCode, gradeLevel, description, difficulty, durationMinutes, xpReward, questions, vakStyles) => ({
  title, subject, subjectCode, gradeLevel, description, difficulty,
  questionCount: questions.length, durationMinutes, xpReward, questions,
  tags: [subject.toLowerCase(), difficulty], vakStyles, isPublished: true,
  attempts: 0, averageScore: 0, createdAt: new Date(), updatedAt: new Date()
});

const quizzes = [
  createQuiz(
    'Kuis Visual: Geometri Ruang',
    'Matematika', 'MTK', 'XII',
    'Kuis geometri dengan fokus pada representasi spasial dan visualisasi kubus/balok.',
    'easy', 15, 100,
    [
      {
        id: 'q1',
        question: 'Sebuah kubus ABCD.EFGH memiliki rusuk 6 cm. Jarak titik A ke titik C adalah...',
        options: ['6√2 cm', '6√3 cm', '6 cm', '12 cm'],
        correctIndex: 0,
        explanation: 'Jarak A ke C adalah diagonal bidang. d = s√2 = 6√2 cm.'
      }
    ],
    ['visual']
  ),
  createQuiz(
    'Kuis Auditory: Sastra Indonesia',
    'B. Indonesia', 'IND', 'XI',
    'Kuis yang menguji pemahaman teks dan analisis lisan.',
    'easy', 10, 80,
    [
      {
        id: 'q1',
        question: 'Unsur intrinsik puisi yang berkaitan dengan rima dan irama lisan adalah...',
        options: ['Musikalisasi', 'Diksi', 'Amanat', 'Tema'],
        correctIndex: 0,
        explanation: 'Musikalisasi atau ritme puisi berkaitan dengan pembacaan dan rima lisan.'
      }
    ],
    ['auditory']
  ),
  createQuiz(
    'Kuis Kinesthetic: Fisika Dinamika',
    'Fisika', 'FIS', 'XI',
    'Kuis penyelesaian soal langkah demi langkah dinamika Newton.',
    'medium', 20, 150,
    [
      {
        id: 'q1',
        question: 'Sebuah balok ditarik dengan gaya 50 N pada lantai licin. Massa balok 10 kg. Percepatannya...',
        options: ['5 m/s²', '0.2 m/s²', '500 m/s²', '25 m/s²'],
        correctIndex: 0,
        explanation: 'F = ma -> a = F/m = 50 / 10 = 5 m/s².'
      }
    ],
    ['kinesthetic']
  ),
];

// ─── MAIN FUNCTION ──────────────────────────────────────────────────────────
async function main() {
  console.log('🌱 Starting comprehensive seeder...\n');

  // 1. Seed PostgreSQL (Supabase/Heroku/Local)
  if (DATABASE_URL) {
    console.log('🔌 Connecting to PostgreSQL...');
    const pgClient = new Client({
      connectionString: DATABASE_URL,
      ssl: { rejectUnauthorized: false }
    });

    try {
      await pgClient.connect();
      console.log('✅ Connected to PostgreSQL');

      // Drop FK constraint if exists to allow insert of arbitrary user IDs
      await pgClient.query('ALTER TABLE profiles DROP CONSTRAINT IF EXISTS profiles_id_fkey;');

      // Check tables
      const res = await pgClient.query(`
        SELECT table_name FROM information_schema.tables 
        WHERE table_schema = 'public'
      `);
      const tableNames = res.rows.map(r => r.table_name);
      console.log('📌 Found PostgreSQL tables:', tableNames);

      if (tableNames.includes('profiles')) {
        console.log('Seeding / updating rich data in profiles table...');

        const emails = profilesToSeed.map(s => `'${s.email}'`).join(',');
        await pgClient.query(`DELETE FROM profiles WHERE email IN (${emails})`);

        for (const p of profilesToSeed) {
          const id = crypto.randomUUID();
          await pgClient.query(`
            INSERT INTO profiles (id, email, name, role, school_name, grade_level, learning_style, xp, level, study_streak_days, created_at, updated_at)
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, 15, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
          `, [id, p.email, p.name, p.role, p.schoolName, p.gradeLevel, p.learningStyle, p.xp, p.level]);
        }
        console.log(`🎉 Successfully seeded/updated ${profilesToSeed.length} users in PostgreSQL 'profiles' table.`);
      } else {
        console.log('⚠️ PostgreSQL profiles table was missing, skipping Postgres insert.');
      }

    } catch (err) {
      console.error('❌ PostgreSQL error:', err.message);
    } finally {
      await pgClient.end();
    }
  } else {
    console.log('ℹ️ No DATABASE_URL found in .env, skipping PostgreSQL seeding.');
  }

  // 2. Seed MongoDB
  if (MONGO_URI) {
    console.log('\n🔌 Connecting to MongoDB Atlas...');
    const mongoClient = new MongoClient(MONGO_URI);

    try {
      await mongoClient.connect();
      console.log('✅ Connected to MongoDB Atlas');

      const targetDbs = ['studybuddy', 'studybuddy_content', 'test'];

      for (const dbName of targetDbs) {
        const db = mongoClient.db(dbName);
        console.log(`\n📦 Database: '${dbName}'`);

        // Seed materials
        const colMaterials = db.collection('studymaterials');
        await colMaterials.deleteMany({});
        const resMat = await colMaterials.insertMany(materials);
        console.log(`  └─ 📚 ${resMat.insertedCount} study materials seeded in 'studymaterials'`);

        // Seed quizzes
        const colQuizzes = db.collection('quizzes');
        await colQuizzes.deleteMany({});
        const resQuiz = await colQuizzes.insertMany(quizzes);
        console.log(`  └─ 🎯 ${resQuiz.insertedCount} quizzes seeded in 'quizzes'`);
      }
      console.log('\n🎉 MongoDB Seeding Complete!');

    } catch (err) {
      console.error('❌ MongoDB error:', err.message);
    } finally {
      await mongoClient.close();
    }
  }

  console.log('\n✨ Complete Seeding process finished successfully.');
}

main();
