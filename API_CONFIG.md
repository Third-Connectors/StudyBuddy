# 🔑 Study Buddy - API Configuration Guide

This guide explains where and how to configure all API keys and endpoints for Study Buddy.

---

## 📋 Table of Contents

1. [Quick Start](#quick-start)
2. [Backend API Configuration](#backend-api-configuration)
3. [Google Gemini API](#google-gemini-api)
4. [Firebase Configuration](#firebase-configuration)
5. [Environment Variables (Optional)](#environment-variables)
6. [Testing Your Configuration](#testing-your-configuration)

---

## 🚀 Quick Start

**File to edit:** `lib/core/constants/api_config.dart`

```dart
abstract final class ApiConfig {
  // 1. Your backend API URL
  static const String baseUrl = 'https://your-api.studybuddy.id/v1';
  
  // 2. Your Google Gemini API Key
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY';
  
  // 3. API Key for your backend (if required)
  static const String apiKey = 'YOUR_BACKEND_API_KEY';
}
```

---

## 🔌 Backend API Configuration

### Location: `lib/core/constants/api_config.dart`

### 1. Base URL

```dart
static const String baseUrl = 'https://your-api.studybuddy.id/v1';
```

**What to do:**
- Replace with your actual backend API URL
- Include the version path (e.g., `/v1`)
- Use HTTPS in production

**Examples:**
```dart
// Development (local)
static const String baseUrl = 'http://192.168.1.100:3000/api';

// Staging
static const String baseUrl = 'https://staging-api.studybuddy.id/v1';

// Production
static const String baseUrl = 'https://api.studybuddy.id/v1';
```

### 2. Backend API Key (Optional)

```dart
static const String apiKey = '';
```

**What to do:**
- Leave empty if your backend doesn't require an API key
- Add your API key if you have one
- Get this from your backend's admin panel

### 3. API Endpoints

All endpoints are defined in `ApiEndpoints` class in the same file:

```dart
abstract final class ApiEndpoints {
  // Authentication
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  
  // VAK Assessment
  static const String vakQuestions = '/vak/questions';
  static const String vakSubmit = '/vak/submit';
  
  // AI Tutor
  static const String tutorChat = '/tutor/chat';
  
  // Schedule Scanner
  static const String scannerUpload = '/scanner/upload';
  
  // ... and more
}
```

**What to do:**
- Modify endpoint paths to match your backend API
- Add new endpoints as needed

---

## 🤖 Google Gemini API

### Location: `lib/core/constants/api_config.dart`

### 1. Get Your Gemini API Key

**Steps:**
1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Sign in with your Google account
3. Click "Create API Key"
4. Copy the generated key

### 2. Configure in Study Buddy

```dart
static const String geminiApiKey = 'YOUR_GEMINI_API_KEY_HERE';
```

**⚠️ IMPORTANT:** Keep your API key secret! Never commit it to version control.

### 3. Gemini Models

```dart
// For text chat (Socratic Tutor)
static const String geminiModel = 'gemini-1.5-flash';

// For vision/OCR tasks
static const String geminiVisionModel = 'gemini-1.5-flash';
```

**Available models:**
- `gemini-pro` - Original Gemini Pro model
- `gemini-1.5-pro` - Most capable model
- `gemini-1.5-flash` - Fast, efficient (recommended)

### 4. Usage in Code

The Gemini API is used in:
- `lib/features/study/data/repositories/tutor_repository.dart` - Socratic Tutor
- `lib/features/study/data/repositories/schedule_repository.dart` - OCR Processing

**Example (Tutor Repository):**
```dart
// Direct Gemini API call (optional)
final response = await _geminiClient.post(
  '/models/${ApiConfig.geminiModel}:generateContent?key=$geminiApiKey',
  {
    'contents': [
      {
        'parts': [
          {'text': 'Your prompt here'},
        ],
      },
    ],
  },
);
```

---

## 🔥 Firebase Configuration

### For Push Notifications

### 1. Create Firebase Project

**Steps:**
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Add project"
3. Follow the setup wizard
4. Enable Cloud Messaging

### 2. Add Firebase to Your Flutter App

**Steps:**
1. Install Firebase CLI:
   ```bash
   npm install -g firebase-tools
   ```

2. Login to Firebase:
   ```bash
   firebase login
   ```

3. Create Flutter app in Firebase:
   ```bash
   cd L:\StudyBuddy
   flutterfire configure
   ```

4. This will:
   - Create `lib/firebase_options.dart`
   - Add Firebase configuration for Android & iOS

### 3. Add Dependencies

Already added to `pubspec.yaml`:
```yaml
dependencies:
  firebase_core: ^2.x.x
  firebase_messaging: ^14.x.x
  flutter_local_notifications: ^16.x.x
```

Run:
```bash
flutter pub get
```

### 4. Platform-Specific Setup

**Android:**
- `google-services.json` → `android/app/`
- Update `android/app/build.gradle`:
  ```gradle
  apply plugin: 'com.google.gms.google-services'
  ```

**iOS:**
- `GoogleService-Info.plist` → `ios/Runner/`
- Update `ios/Runner/AppDelegate.swift`:
  ```swift
  import Firebase
  FirebaseApp.configure()
  ```

### 5. Update Notification Service

Edit: `lib/core/services/notification_service.dart`

Replace placeholder code with actual Firebase implementation (see comments in file).

---

## 🔐 Environment Variables (Recommended for Production)

Instead of hardcoding API keys, use environment variables.

### Option 1: Flutter Dotenv

1. Add dependency:
   ```yaml
   dependencies:
     flutter_dotenv: ^5.1.0
   ```

2. Create `.env` file (add to `.gitignore`):
   ```
   GEMINI_API_KEY=your_key_here
   API_BASE_URL=https://api.studybuddy.id/v1
   ```

3. Load in `main.dart`:
   ```dart
   import 'package:flutter_dotenv/flutter_dotenv.dart';
   
   Future<void> main() async {
     await dotenv.load(fileName: '.env');
     // ... rest of main
   }
   ```

4. Use in `api_config.dart`:
   ```dart
   static const String geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');
   ```

### Option 2: Build Flavors

For different environments (dev, staging, prod), use Flutter build flavors.

---

## ✅ Testing Your Configuration

### 1. Test Backend Connection

Run the app and try:
- Login/Register
- Fetch user profile
- Any API call

Check debug console for logs from `ApiClient`.

### 2. Test Gemini API

Open `lib/features/study/data/repositories/tutor_repository.dart` and:
- Uncomment the Gemini API call code
- Send a message in the tutor chat
- Check if you get a response

### 3. Test Firebase

After Firebase setup:
```bash
flutter run
```

Check console for Firebase initialization logs.

---

## 📁 Files You Need to Edit

| File | What to Configure |
|------|-------------------|
| `lib/core/constants/api_config.dart` | Backend URL, Gemini API key, endpoints |
| `lib/core/services/notification_service.dart` | Firebase notifications |
| `lib/features/auth/data/repositories/auth_repository.dart` | Auth API calls |
| `lib/features/study/data/repositories/tutor_repository.dart` | Gemini API for tutor |
| `lib/features/study/data/repositories/schedule_repository.dart` | OCR API |
| `android/app/google-services.json` | Firebase Android config |
| `ios/Runner/GoogleService-Info.plist` | Firebase iOS config |

---

## 🛠️ Troubleshooting

### "API key not configured" error
- Check `api_config.dart` has your API key
- Restart the app after changing config

### "Connection timeout" error
- Check your backend URL is correct
- Verify backend is running
- Check internet connection

### "Firebase not initialized" error
- Run `flutterfire configure`
- Ensure `google-services.json` / `GoogleService-Info.plist` are in correct location

### Gemini API returns 403
- API key might be invalid
- Check API key permissions in Google Cloud Console
- Verify billing is enabled (if required)

---

## 📞 Need Help?

1. Check the inline comments in each file
2. Review `lib/core/constants/api_config.dart` for all configuration options
3. See placeholder comments (`⚠️ PLACEHOLDER`) for implementation hints

---

**Last Updated:** March 31, 2026  
**Version:** 1.0.0
