# 🚀 Study Buddy - Setup Guide (Supabase + Firebase)

Panduan **LENGKAP** untuk setup Study Buddy dari NOL.

---

## 📋 Overview Arsitektur

```
Flutter App
    ↓
┌─────────────────────┐
│   SUPABASE          │  (Backend-as-a-Service)
│   ├── Auth          │  ← Authentication
│   ├── PostgreSQL    │  ← Database
│   ├── Realtime      │  ← Live updates
│   └── REST API      │  ← Auto-generated
└─────────────────────┘
    ↓
┌─────────────────────┐
│   FIREBASE          │  (Push Notifications)
│   └── FCM           │  ← Cloud Messaging
└─────────────────────┘
    ↓
┌─────────────────────┐
│   GOOGLE GEMINI     │  ← AI Tutor & OCR
└─────────────────────┘
```

---

## 🎯 Setup Order (WAJIB BERURUTAN!)

```
Step 1: Supabase Setup        (15 menit)  ← MULAI DARI SINI
   ↓
Step 2: Firebase Setup        (20 menit)
   ↓
Step 3: Flutter App Config    (10 menit)
   ↓
Step 4: Test & Run            (5 menit)
```

---

# STEP 1: SUPABASE SETUP ⚡

## 1.1 Buat Supabase Account & Project

### A. Daftar Account

1. Buka: https://supabase.com
2. Klik **"Start your project"** atau **"Sign In"**
3. Login dengan **GitHub** (recommended) atau Email
4. Complete registration

### B. Buat New Project

1. Klik **"New Project"** (tombol hijau)
2. Isi form:
   ```
   Organization: Study Buddy (atau nama kamu)
   Project name: study-buddy
   Database Password: [BUAT PASSWORD KUAT - SIMPAN INI!]
   Region: Southeast Asia (Singapore) ← TERDEKAT
   Pricing plan: Free
   ```
3. Klik **"Create new project"**
4. **TUNGGU 2-3 menit** sampai database ready

### C. Dapatkan API Credentials

Setelah project ready:

1. Buka: **Settings** (icon gear ⚙️ di sidebar kiri bawah)
2. Klik **API**
3. Copy 2 hal ini:
   ```
   Project URL: https://xxxxxxxxxxxxx.supabase.co
   anon/public key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   ```
4. **SIMPAN DI NOTEPAD SEMENTARA** ⚠️

---

## 1.2 Setup Database Schema

### A. Buka SQL Editor

1. Di Supabase Dashboard, klik **SQL Editor** (sidebar kiri)
2. Klik **"New query"**

### B. Copy-Paste Schema Ini

```sql
-- ═══════════════════════════════════════════════════════
-- Study Buddy Database Schema
-- ═══════════════════════════════════════════════════════

-- 1. USERS TABLE (extend auth.users)
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  name VARCHAR(255) NOT NULL,
  role VARCHAR(50) DEFAULT 'student',
  school_name VARCHAR(255),
  grade_level VARCHAR(50),
  profile_image_url TEXT,
  learning_style VARCHAR(50), -- visual, auditory, kinesthetic
  xp INTEGER DEFAULT 0,
  level INTEGER DEFAULT 1,
  study_streak_days INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. VAK RESULTS
CREATE TABLE IF NOT EXISTS public.vak_results (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  visual_score DECIMAL(5,4) NOT NULL,
  auditory_score DECIMAL(5,4) NOT NULL,
  kinesthetic_score DECIMAL(5,4) NOT NULL,
  dominant_style VARCHAR(50) NOT NULL,
  confidence_score DECIMAL(5,4),
  answers JSONB NOT NULL,
  completed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. TUTOR SESSIONS
CREATE TABLE IF NOT EXISTS public.tutor_sessions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  title VARCHAR(255) NOT NULL,
  subject VARCHAR(100),
  messages JSONB DEFAULT '[]'::jsonb,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  last_message_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. SCHEDULES
CREATE TABLE IF NOT EXISTS public.schedules (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  subject VARCHAR(100) NOT NULL,
  subject_code VARCHAR(10),
  start_time TIMESTAMP WITH TIME ZONE NOT NULL,
  end_time TIMESTAMP WITH TIME ZONE NOT NULL,
  location VARCHAR(255),
  notes TEXT,
  is_recurring BOOLEAN DEFAULT false,
  recurring_days TEXT[] DEFAULT '{}',
  is_school_schedule BOOLEAN DEFAULT false,
  is_study_schedule BOOLEAN DEFAULT false,
  source VARCHAR(50) DEFAULT 'manual', -- manual, ocr, ai_generated
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. QUIZZES (Content)
CREATE TABLE IF NOT EXISTS public.quizzes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  subject VARCHAR(100) NOT NULL,
  subject_code VARCHAR(10),
  grade_level VARCHAR(50),
  description TEXT,
  difficulty VARCHAR(20) DEFAULT 'medium', -- easy, medium, hard
  questions JSONB NOT NULL,
  question_count INTEGER NOT NULL,
  duration_minutes INTEGER NOT NULL,
  xp_reward INTEGER DEFAULT 100,
  tags TEXT[] DEFAULT '{}',
  is_published BOOLEAN DEFAULT false,
  attempts INTEGER DEFAULT 0,
  average_score DECIMAL(5,2) DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 6. QUIZ RESULTS
CREATE TABLE IF NOT EXISTS public.quiz_results (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  quiz_id UUID REFERENCES public.quizzes(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  answers INTEGER[] NOT NULL,
  correct_count INTEGER NOT NULL,
  score DECIMAL(5,2) NOT NULL,
  xp_earned INTEGER NOT NULL,
  time_spent_seconds INTEGER NOT NULL,
  completed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 7. LEADERBOARD CACHE
CREATE TABLE IF NOT EXISTS public.leaderboard_cache (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  timeframe VARCHAR(20) NOT NULL, -- daily, weekly, monthly, alltime
  entries JSONB NOT NULL,
  generated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  expires_at TIMESTAMP WITH TIME ZONE NOT NULL
);

-- INDEXES
CREATE INDEX IF NOT EXISTS idx_profiles_email ON public.profiles(email);
CREATE INDEX IF NOT EXISTS idx_profiles_xp ON public.profiles(xp DESC);
CREATE INDEX IF NOT EXISTS idx_vak_results_user ON public.vak_results(user_id);
CREATE INDEX IF NOT EXISTS idx_tutor_sessions_user ON public.tutor_sessions(user_id, last_message_at DESC);
CREATE INDEX IF NOT EXISTS idx_schedules_user ON public.schedules(user_id, start_time);
CREATE INDEX IF NOT EXISTS idx_quizzes_subject ON public.quizzes(subject, difficulty);
CREATE INDEX IF NOT EXISTS idx_quiz_results_user ON public.quiz_results(user_id, completed_at DESC);
CREATE INDEX IF NOT EXISTS idx_leaderboard_timeframe ON public.leaderboard_cache(timeframe, expires_at);

-- ROW LEVEL SECURITY (RLS)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.vak_results ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tutor_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.schedules ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quizzes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quiz_results ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.leaderboard_cache ENABLE ROW LEVEL SECURITY;

-- POLICIES

-- Profiles: Users can view & update own profile
CREATE POLICY "Users can view own profile"
  ON public.profiles FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON public.profiles FOR UPDATE
  USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
  ON public.profiles FOR INSERT
  WITH CHECK (auth.uid() = id);

-- VAK Results: Users can view & insert own
CREATE POLICY "Users can view own VAK results"
  ON public.vak_results FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own VAK results"
  ON public.vak_results FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Tutor Sessions: Users can CRUD own sessions
CREATE POLICY "Users can manage own tutor sessions"
  ON public.tutor_sessions FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Schedules: Users can CRUD own schedules
CREATE POLICY "Users can manage own schedules"
  ON public.schedules FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Quizzes: Everyone can view published quizzes
CREATE POLICY "Anyone can view published quizzes"
  ON public.quizzes FOR SELECT
  USING (is_published = true);

-- Quiz Results: Users can view & insert own
CREATE POLICY "Users can view own quiz results"
  ON public.quiz_results FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own quiz results"
  ON public.quiz_results FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Leaderboard: Everyone can view
CREATE POLICY "Anyone can view leaderboard"
  ON public.leaderboard_cache FOR SELECT
  USING (true);

-- FUNCTION: Auto-create profile on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, name)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'name', split_part(NEW.email, '@', 1))
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- TRIGGER: Call function on signup
CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- FUNCTION: Update updated_at timestamp
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- TRIGGERS: Auto-update updated_at
CREATE TRIGGER update_profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_schedules_updated_at
  BEFORE UPDATE ON public.schedules
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_quizzes_updated_at
  BEFORE UPDATE ON public.quizzes
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();
```

### C. Execute Schema

1. Klik **"Run"** (atau Ctrl+Enter)
2. Tunggu sampai selesai (~5 detik)
3. **Harus muncul**: "Success. No rows returned"
4. **Verify**: Klik **Table Editor** di sidebar → Harus ada 7 tables

---

## 1.3 Test Supabase di Browser

### A. Insert Test Data

Di SQL Editor, jalankan:

```sql
-- Insert sample quiz
INSERT INTO public.quizzes (
  title, subject, subject_code, grade_level,
  description, difficulty, questions,
  question_count, duration_minutes, xp_reward, is_published
) VALUES (
  'Latihan Matematika - Aljabar',
  'Matematika', 'MTK', '11',
  'Latihan soal aljabar untuk kelas 11',
  'medium',
  '[
    {
      "id": "q1",
      "question": "Jika 2x + 3 = 11, maka nilai x adalah...",
      "options": ["2", "3", "4", "5"],
      "correctIndex": 2,
      "explanation": "2x + 3 = 11 → 2x = 8 → x = 4"
    }
  ]'::jsonb,
  1, 30, 100, true
);

-- Verify
SELECT title, subject FROM public.quizzes WHERE is_published = true;
```

**Expected**: 1 row returned ✅

---

# STEP 2: FIREBASE SETUP 🔥

## 2.1 Buat Firebase Project

### A. Buka Firebase Console

1. Buka: https://console.firebase.google.com
2. Login dengan **Google Account**
3. Klik **"Create a project"** atau **"Add project"**

### B. Isi Project Details

```
Step 1:
✓ Project name: study-buddy-[nama-kamu]
  (contoh: study-buddy-rizqi)
✓ Google Analytics: ON (recommended)
→ Klik "Continue"

Step 2:
✓ Google Analytics account: Pilih default
→ Klik "Create project"

Step 3:
→ Tunggu ~30 detik
→ Klik "Continue"
```

---

## 2.2 Tambah Android App

### A. Klik Icon Android 🤖

1. Di Firebase Console homepage, klik icon **Android**
2. Atau: Project Settings ⚙️ → "Your apps" → **"Add app"** → Android

### B. Isi Android App Details

```
Android package name: com.example.studybuddy
  ⚠️ PENTING: Harus SAMA dengan di android/app/build.gradle
  
App nickname (optional): Study Buddy Android

Debug signing certificate SHA-1:
  (Optional tapi recommended)
  Buka terminal, jalankan:
  
  Windows:
  keytool -list -v -keystore %USERPROFILE%\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android
  
  Copy SHA1 value (format: XX:XX:XX:...)
```

**Cara cek package name:**

```bash
# Buka file ini:
L:\StudyBuddy\android\app\build.gradle

# Cari baris ini:
namespace "com.example.studybuddy"
# ATAU
applicationId "com.example.studybuddy"

# Gunakan value yang sama!
```

### C. Register App

1. Klik **"Register app"**
2. Firebase akan generate config file

---

## 2.3 Download `google-services.json`

### A. Download File

1. Firebase akan show file `google-services.json`
2. Klik **"Download google-services.json"**
3. File akan ter-download ke komputer

### B. Pindahkan File

```
Source: Downloads folder
Target: L:\StudyBuddy\android\app\google-services.json

CARA:
1. Buka File Explorer
2. Buka folder Downloads
3. Copy file google-services.json
4. Paste ke: L:\StudyBuddy\android\app\
```

**Verify:**
```
✅ File ada di: L:\StudyBuddy\android\app\google-services.json
❌ BUKAN di: L:\StudyBuddy\google-services.json
❌ BUKAN di: L:\StudyBuddy\android\google-services.json
```

### C. Klik Next di Firebase Console

---

## 2.4 Tambah iOS App (OPTIONAL - Skip jika tidak ada Mac)

### Jika punya Mac/iOS device:

1. Klik icon **iOS** 🍎
2. Bundle ID: `com.example.studybuddy`
3. Download `GoogleService-Info.plist`
4. Letakkan di: `L:\StudyBuddy\ios\Runner\GoogleService-Info.plist`

### Jika TIDAK punya Mac:

**SKIP step ini** → Klik **"Next"** → **"Continue to console"**

---

## 2.5 Enable Firebase Services

### A. Firebase Authentication

1. Sidebar kiri → **Authentication**
2. Klik **"Get started"**
3. Tab **"Sign-in method"**
4. **Email/Password**:
   - Klik → Toggle **Enable**
   - Klik **Save**

### B. Firebase Cloud Messaging (FCM)

1. Sidebar kiri → **Cloud Messaging**
2. **Sudah otomatis aktif** ✅
3. Tidak perlu setup apapun

### C. Firebase Analytics

1. Sidebar kiri → **Analytics** → **Dashboard**
2. **Sudah otomatis aktif** ✅

---

## 2.6 Install FlutterFire CLI

### A. Install Dart Package

```bash
# Buka terminal di manapun
dart pub global activate flutterfire_cli
```

**Expected output:**
```
Package flutterfire_cli is currently active at version X.X.X
Installed executable flutterfire.
Activated flutterfire_cli X.X.X.
```

### B. Tambahkan ke PATH (Windows)

```powershell
# Cek apakah sudah ter-install
flutterfire --version

# Jika error "command not found", tambahkan ke PATH:

# Cara 1: Temporary (hanya terminal ini)
$env:PATH += ";$env:LOCALAPPDATA\Pub\Cache\bin"

# Cara 2: Permanent (recommended)
# 1. Tekan Win + R
# 2. Ketik: sysdm.cpl
# 3. Tab "Advanced" → "Environment Variables"
# 4. Di "User variables", pilih "Path" → Edit
# 5. New → Paste: %LOCALAPPDATA%\Pub\Cache\bin
# 6. OK → OK → OK
# 7. RESTART terminal
```

### C. Verify Installation

```bash
# Restart terminal dulu
flutterfire --version
```

**Expected:** `flutterfire_cli version X.X.X`

---

## 2.7 Generate Firebase Config

### A. Login ke Firebase

```bash
# Navigate ke project root
cd L:\StudyBuddy

# Login (akan buka browser)
firebase login

# Jika belum install Firebase CLI:
npm install -g firebase-tools
firebase login
```

**Expected:** Browser terbuka → Login dengan Google → "Success!"

### B. Run FlutterFire Configure

```bash
cd L:\StudyBuddy

flutterfire configure \
  --project=study-buddy-[project-id-kamu] \
  --platforms=android \
  --out=lib/firebase_options.dart
```

**Ganti `[project-id-kamu]`:**
- Lihat di Firebase Console URL:
  `https://console.firebase.google.com/project/study-buddy-rizqi/overview`
  Project ID = `study-buddy-rizqi`

**Interactive prompts:**
```
? Select a Firebase project: study-buddy-rizqi
? Which platforms should your configuration support?
  ✓ android
  (uncheck ios, web jika tidak perlu)
```

**Expected output:**
```
i Found 1 Firebase project.
✔ Fetching config
✔ Writing configuration to lib/firebase_options.dart
✔ Firebase configuration file written successfully!
```

### C. Verify File Generated

```bash
# Cek file ada
dir L:\StudyBuddy\lib\firebase_options.dart
```

**File harus ada** ✅

---

# STEP 3: FLUTTER APP CONFIG 📱

## 3.1 Install Dependencies

```bash
cd L:\StudyBuddy

# Tambah Supabase SDK
flutter pub add supabase_flutter

# Install semua dependencies
flutter pub get
```

**Expected:** `Got dependencies!`

---

## 3.2 Update `main.dart`

Buka: `lib/main.dart`

Ganti **SELURUH ISI FILE** dengan ini:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';

import 'core/theme/app_theme.dart';
import 'core/services/notification_service.dart';
import 'features/main_navigation/presentation/main_navigation_screen.dart';
import 'features/onboarding/presentation/onboarding_screen_1.dart';

/// Entry point untuk Study Buddy.
void main() async {
  // 1. Initialize Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Lock orientation to portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 3. Configure system UI
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // 4. 🔥 Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 5. ⚡ Initialize Supabase
  await Supabase.initialize(
    url: 'https://YOUR_PROJECT_ID.supabase.co', // ← GANTI INI
    anonKey: 'YOUR_ANON_KEY', // ← GANTI INI
  );

  // 6. 📬 Initialize Notifications
  await NotificationService.instance.initialize();
  await NotificationService.instance.requestPermission();

  // 7. Run app
  runApp(
    const ProviderScope(child: StudyBuddyApp()),
  );
}

/// Root MaterialApp widget.
class StudyBuddyApp extends StatelessWidget {
  const StudyBuddyApp({super.key});

  static final Map<String, WidgetBuilder> _routes = {
    '/onboarding1': (_) => const OnboardingScreen1(),
    '/home': (_) => const MainNavigationScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Buddy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/onboarding1',
      routes: _routes,
      scrollBehavior: const _StudyBuddyScrollBehaviour(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: MediaQuery.of(context).textScaler.clamp(
              minScaleFactor: 0.85,
              maxScaleFactor: 1.15,
            ),
          ),
          child: child!,
        );
      },
    );
  }
}

class _StudyBuddyScrollBehaviour extends ScrollBehavior {
  const _StudyBuddyScrollBehaviour();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
```

### ⚠️ PENTING: Ganti 2 Value Ini!

```dart
// Di baris ~35-36:

await Supabase.initialize(
  url: 'https://xxxxxxxxxxxxx.supabase.co',  // ← GANTI dengan Project URL kamu
  anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',  // ← GANTI dengan anon key kamu
);
```

**Cara dapat:**
1. Buka Supabase Dashboard
2. Settings ⚙️ → API
3. Copy **Project URL** dan **anon/public key**
4. Paste ke `main.dart`

---

## 3.3 Update Android Configuration

### A. `android/build.gradle`

Buka: `L:\StudyBuddy\android\build.gradle`

Tambahkan di dalam `dependencies`:

```gradle
buildscript {
    ext.kotlin_version = '1.9.10'
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        
        // 🔥 TAMBAHKAN INI:
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

### B. `android/app/build.gradle`

Buka: `L:\StudyBuddy\android\app\build.gradle`

Tambahkan di **PALING BAWAH** file:

```gradle
// 🔥 TAMBAHKAN INI DI BARIS TERAKHIR:
apply plugin: 'com.google.gms.google-services'
```

Pastikan `minSdkVersion >= 21`:

```gradle
android {
    defaultConfig {
        minSdkVersion 21  // ← Minimal 21
        targetSdkVersion 34
        // ...
    }
}
```

### C. `android/app/src/main/AndroidManifest.xml`

Buka: `L:\StudyBuddy\android\app\src\main\AndroidManifest.xml`

Tambahkan permissions di dalam `<manifest>`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    
    <!-- 🔥 TAMBAHKAN PERMISSIONS INI: -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
    <uses-permission android:name="android.permission.VIBRATE"/>
    <uses-permission android:name="android.permission.WAKE_LOCK"/>
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
    
    <application
        android:label="Study Buddy"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        
        <!-- ... existing config ... -->
        
    </application>
</manifest>
```

---

# STEP 4: TEST & RUN 🚀

## 4.1 Clean & Rebuild

```bash
cd L:\StudyBuddy

# Clean build
flutter clean

# Get dependencies
flutter pub get

# Rebuild
flutter pub run build_runner build --delete-conflicting-outputs
```

## 4.2 Run App

```bash
# Run on connected device/emulator
flutter run
```

**Expected:**
- App starts tanpa error
- Firebase initialized (lihat logs)
- Supabase connected
- Onboarding screen muncul

## 4.3 Test Firebase

Buka terminal baru:

```bash
# Monitor logs
flutter logs | grep -i firebase
```

**Expected logs:**
```
✅ Firebase initialized
🔑 FCM Token: dQw4w9WgXcQ...
🔔 Notification permission granted
```

## 4.4 Test Supabase

Di app, coba **Register** atau **Login**:

1. Buka app → Onboarding → Register
2. Isi email & password
3. Submit

**Verify di Supabase:**
1. Buka Supabase Dashboard
2. **Authentication** → **Users**
3. Harus ada user baru ✅
4. **Table Editor** → **profiles**
5. Harus ada profile baru ✅

---

# 🐛 Troubleshooting

## Error: "FirebaseException: No Firebase App"

**Solusi:**
```dart
// Pastikan Firebase.initializeApp() dipanggil SEBELUM runApp()
// Sudah benar di main.dart
```

## Error: "google-services.json missing"

**Solusi:**
1. Pastikan file di: `L:\StudyBuddy\android\app\google-services.json`
2. Clean rebuild:
   ```bash
   cd android
   gradlew clean
   cd ..
   flutter clean
   flutter pub get
   flutter run
   ```

## Error: "flutterfire command not found"

**Solusi:**
```bash
# Install ulang
dart pub global activate flutterfire_cli

# Windows - tambahkan ke PATH
# Win+R → sysdm.cpl → Advanced → Environment Variables
# Edit PATH → Add: %LOCALAPPDATA%\Pub\Cache\bin

# Restart terminal
flutterfire --version
```

## Error: "Supabase init failed"

**Solusi:**
1. Cek URL & anonKey benar (no typo)
2. Cek internet connection
3. Test di browser:
   ```
   https://YOUR_PROJECT_ID.supabase.co/rest/v1/
   ```
   Harus return JSON

## App crash saat startup

**Solusi:**
```bash
# Lihat detailed logs
flutter run -v

# Common fixes:
flutter clean
flutter pub get
flutter run
```

---

# ✅ Final Checklist

Sebelum bilang "setup selesai", pastikan semua ini:

## Supabase ✅
- [ ] Account created
- [ ] Project created (region: Singapore)
- [ ] Database password saved
- [ ] SQL schema executed successfully
- [ ] 7 tables created
- [ ] RLS policies active
- [ ] Test data inserted
- [ ] Project URL copied
- [ ] Anon key copied

## Firebase ✅
- [ ] Project created
- [ ] Android app registered
- [ ] `google-services.json` downloaded
- [ ] File placed di `android/app/`
- [ ] FlutterFire CLI installed
- [ ] `flutterfire configure` executed
- [ ] `lib/firebase_options.dart` generated
- [ ] Authentication enabled (Email/Password)
- [ ] Cloud Messaging active

## Flutter App ✅
- [ ] `supabase_flutter` added to pubspec
- [ ] `main.dart` updated dengan Supabase init
- [ ] Supabase URL & anonKey replaced
- [ ] Android `build.gradle` updated
- [ ] `AndroidManifest.xml` permissions added
- [ ] `flutter pub get` executed
- [ ] App runs without errors

## Test ✅
- [ ] Firebase initialized (logs show ✅)
- [ ] Supabase connected
- [ ] User registration works
- [ ] Profile created di database
- [ ] FCM token received

---

# 📚 Next Steps

Setelah setup selesai:

1. **Customize App**
   - Update branding
   - Add app icon
   - Customize colors

2. **Test All Features**
   - VAK Assessment
   - AI Tutor Chat
   - Schedule Scanner
   - Quiz System
   - Leaderboard

3. **Deploy**
   - Build APK: `flutter build apk --release`
   - Build App Bundle: `flutter build appbundle`
   - Upload ke Play Store

---

**Setup Time Estimate:**
- Supabase: 15 menit
- Firebase: 20 menit
- Flutter Config: 10 menit
- Testing: 5 menit
- **TOTAL: ~50 menit**

**Happy Coding! 🎓🚀**
