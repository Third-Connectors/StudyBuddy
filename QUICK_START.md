# 🚀 Quick Start - Study Buddy Setup

**Ikuti step ini BERURUTAN, jangan skip!**

---

## ⚡ STEP 1: Supabase Setup (15 menit)

### 1. Buat Project
```
1. Buka: https://supabase.com
2. Sign In (GitHub/Email)
3. "New Project"
4. Isi:
   - Name: study-buddy
   - Password: [BUAT PASSWORD - SIMPAN!]
   - Region: Singapore
   - Plan: Free
5. Tunggu 2 menit
```

### 2. Copy Credentials
```
1. Settings ⚙️ → API
2. Copy:
   ✓ Project URL: https://xxx.supabase.co
   ✓ anon/public key: eyJhbG...
3. Simpan di notepad!
```

### 3. Setup Database
```
1. Klik "SQL Editor" di sidebar
2. "New query"
3. Copy-paste SQL dari file: SETUP_SUPABASE_FIREBASE.md
   (Bagian "1.2 Setup Database Schema")
4. Klik "Run"
5. Verify: "Table Editor" → Harus ada 7 tables
```

---

## 🔥 STEP 2: Firebase Setup (20 menit)

### 1. Buat Project
```
1. Buka: https://console.firebase.google.com
2. "Create a project"
3. Name: study-buddy-[nama]
4. Analytics: ON
5. Tunggu 30 detik
```

### 2. Tambah Android App
```
1. Klik icon Android 🤖
2. Package name: com.example.studybuddy
   (Cek di: android/app/build.gradle → namespace)
3. "Register app"
4. Download google-services.json
5. Pindahkan ke: L:\StudyBuddy\android\app\
```

### 3. Enable Services
```
1. Authentication → Get started
   ✓ Email/Password: Enable
2. Cloud Messaging: Sudah aktif ✅
```

### 4. Install FlutterFire CLI
```bash
# Terminal 1:
dart pub global activate flutterfire_cli

# Windows - jika error, tambah PATH:
# %LOCALAPPDATA%\Pub\Cache\bin

# Terminal 2 (restart):
cd L:\StudyBuddy
firebase login
flutterfire configure --project=study-buddy-[id] --platforms=android --out=lib/firebase_options.dart
```

---

## 📱 STEP 3: Flutter Config (10 menit)

### 1. Install Dependencies
```bash
cd L:\StudyBuddy
flutter pub get
```

### 2. Update main.dart
```
GANTI SELURUH ISI lib/main.dart dengan code dari:
SETUP_SUPABASE_FIREBASE.md (Bagian 3.2)

PENTING: Ganti 2 value ini:
- Supabase URL
- Supabase anon key
```

### 3. Update Android Files
```
✓ android/build.gradle - tambah google-services classpath
✓ android/app/build.gradle - tambah apply plugin di bawah
✓ AndroidManifest.xml - tambah permissions
```

(Semua ada di SETUP_SUPABASE_FIREBASE.md Bagian 3.3)

---

## 🚀 STEP 4: Run App (5 menit)

```bash
cd L:\StudyBuddy
flutter clean
flutter pub get
flutter run
```

**Expected:**
- ✅ App starts
- ✅ No errors
- ✅ Onboarding screen muncul

---

## ✅ Checklist

- [ ] Supabase project created
- [ ] SQL schema executed
- [ ] Firebase project created
- [ ] google-services.json downloaded & placed
- [ ] flutterfire configure executed
- [ ] main.dart updated dengan Supabase URL & key
- [ ] Android files updated
- [ ] flutter pub get success
- [ ] App runs without errors

---

## 📚 Files Reference

| File | Purpose |
|------|---------|
| `SETUP_SUPABASE_FIREBASE.md` | **FULL GUIDE** - Baca ini dulu! |
| `SUPABASE_VS_POSTGRESQL.md` | Comparison (kenapa pilih Supabase) |
| `FIREBASE_SETUP.md` | Firebase detailed guide |
| `lib/core/constants/supabase_config.dart` | Supabase credentials |
| `lib/core/services/supabase_service.dart` | Supabase helper |
| `lib/core/providers/supabase_provider.dart` | Riverpod providers |

---

## 🐛 Troubleshooting

**Error: "google-services.json missing"**
```bash
# Pastikan file di:
L:\StudyBuddy\android\app\google-services.json

# Clean rebuild:
cd android && gradlew clean && cd ..
flutter clean && flutter pub get && flutter run
```

**Error: "flutterfire not found"**
```bash
dart pub global activate flutterfire_cli
# Tambah ke PATH: %LOCALAPPDATA%\Pub\Cache\bin
```

**App crash on startup**
```bash
flutter run -v  # Lihat detailed logs
```

---

**Total Time: ~50 menit**

**MULAI DARI STEP 1 → JANGAN SKIP!**
