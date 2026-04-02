# 🚀 Study Buddy - Setup Guide

Quick start guide for developers.

---

## Prerequisites

### Required Software
- **Flutter**: 3.19+ (https://flutter.dev)
- **Node.js**: 18+ (https://nodejs.org)
- **Python**: 3.10+ (https://python.org)
- **Docker**: For databases (https://docker.com)

### Recommended IDE
- VS Code with Flutter, Dart, Python extensions
- Android Studio / IntelliJ IDEA

---

## Step 1: Install Dependencies

### Flutter Frontend
```bash
cd L:\StudyBuddy
flutter pub get
```

### NestJS Backend
```bash
cd L:\StudyBuddy\backend\api-gateway
npm install
```

### Python ML Service
```bash
cd L:\StudyBuddy\backend\ml-service

# Windows
python -m venv venv
venv\Scripts\activate

# Linux/Mac
python -m venv venv
source venv/bin/activate

pip install -r requirements.txt
```

---

## Step 2: Configure Environment

### Flutter App
Edit: `lib/core/constants/api_config.dart`

```dart
// Update with your local IP or backend URL
static const String baseUrl = 'http://192.168.1.100:3000/api/v1';
static const String mlServiceUrl = 'http://192.168.1.100:8000/api/v1';

// Already configured:
static const String geminiApiKey = 'AIzaSyB-ldUVNrHndQ84LblWey6kg7fZxGAglOk';
```

### NestJS Backend
```bash
cd L:\StudyBuddy\backend\api-gateway
copy .env.example .env
```

Edit `.env`:
```env
NODE_ENV=development
PORT=3000

# PostgreSQL
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_USER=studybuddy
POSTGRES_PASSWORD=YourSecurePassword123
POSTGRES_DB=studybuddy_users

# MongoDB
MONGODB_URI=mongodb://localhost:27017/studybuddy_content

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379

# JWT (CHANGE THESE IN PRODUCTION!)
JWT_SECRET=your_super_secret_jwt_key_change_this_in_production
JWT_REFRESH_SECRET=your_super_secret_refresh_key_change_this_in_production

# ML Service
ML_SERVICE_URL=http://localhost:8000/api/v1
```

---

## Step 3: Start Databases (Docker)

```bash
# PostgreSQL
docker run --name studybuddy-postgres \
  -e POSTGRES_PASSWORD=YourSecurePassword123 \
  -e POSTGRES_USER=studybuddy \
  -e POSTGRES_DB=studybuddy_users \
  -p 5432:5432 \
  -d postgres:15

# MongoDB
docker run --name studybuddy-mongo \
  -p 27017:27017 \
  -d mongo:6

# Redis
docker run --name studybuddy-redis \
  -p 6379:6379 \
  -d redis:7

# Verify all containers are running
docker ps
```

### Initialize PostgreSQL Schema
```bash
# Get container ID
docker ps | grep studybuddy-postgres

# Run schema
docker exec -i studybuddy-postgres psql -U studybuddy -d studybuddy_users < backend/api-gateway/src/config/database/postgres-schema.sql
```

---

## Step 4: Start Backend Services

### Terminal 1: NestJS API Gateway
```bash
cd L:\StudyBuddy\backend\api-gateway
npm run start:dev
```

Expected output:
```
╔═══════════════════════════════════════════════════════════╗
║           🎓 Study Buddy API Gateway                      ║
╠═══════════════════════════════════════════════════════════╣
║  Server running on: http://localhost:3000                 ║
║  API Prefix: /api/v1                                      ║
║  Swagger Docs: http://localhost:3000/api/docs             ║
╚═══════════════════════════════════════════════════════════╝
```

### Terminal 2: Python ML Service
```bash
cd L:\StudyBuddy\backend\ml-service
# Activate venv first (see Step 1)
python main.py
```

Expected output:
```
INFO:     Uvicorn running on http://0.0.0.0:8000
INFO:     Application startup complete.
```

---

## Step 5: Start Flutter App

```bash
cd L:\StudyBuddy
flutter run
```

### Run on Specific Device
```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device_id>

# Run on Chrome (web)
flutter run -d chrome

# Run on Windows
flutter run -d windows
```

---

## Step 6: Verify Setup

### Test API Gateway
Open browser: http://localhost:3000/api/docs

You should see Swagger UI with all API endpoints.

### Test ML Service
Open browser: http://localhost:8000/docs

You should see FastAPI Swagger UI.

### Test Health Check
```bash
curl http://localhost:3000/health
curl http://localhost:8000/health
```

### Test Flutter App
1. App should start on onboarding screen
2. Complete VAK assessment
3. Try AI tutor chat
4. Test schedule scanner (upload image)

---

## 🔧 Troubleshooting

### Port Already in Use
```bash
# Windows: Find and kill process on port 3000
netstat -ano | findstr :3000
taskkill /PID <PID> /F

# Linux/Mac
lsof -ti:3000 | xargs kill -9
```

### Docker Issues
```bash
# Check Docker is running
docker --version
docker ps

# Restart Docker Desktop
# Windows: System tray → Docker Desktop → Quit → Restart
# Mac: Menu bar → Docker → Quit → Restart
```

### Flutter Build Issues
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

### Database Connection Failed
1. Check Docker containers are running: `docker ps`
2. Verify credentials in `.env`
3. Test connection:
   ```bash
   # PostgreSQL
   docker exec -it studybuddy-postgres psql -U studybuddy -d studybuddy_users
   
   # MongoDB
   docker exec -it studybuddy-mongo mongosh
   ```

---

## 📱 Firebase Setup (Optional - for Push Notifications)

1. Go to https://console.firebase.google.com
2. Create new project: "Study Buddy"
3. Add Android app:
   - Package name: `com.example.studybuddy`
   - Download `google-services.json` → `android/app/`
4. Add iOS app:
   - Bundle ID: `com.example.studybuddy`
   - Download `GoogleService-Info.plist` → `ios/Runner/`
5. Enable Cloud Messaging
6. Run:
   ```bash
   flutterfire configure
   ```

---

## 🎯 Default Test Credentials

After first run, use:
- **Email**: admin@studybuddy.id
- **Password**: admin123

(Or register a new account via the app)

---

## 📚 Next Steps

1. **Customize API URLs** for your network
2. **Change JWT secrets** in `.env`
3. **Configure Firebase** for push notifications
4. **Test all features**:
   - [ ] Login/Register
   - [ ] VAK Assessment
   - [ ] AI Tutor Chat
   - [ ] Schedule Scanner
   - [ ] Quiz System
   - [ ] Leaderboard

---

## 📞 Need Help?

1. Check `IMPLEMENTATION_PROGRESS.md` for status
2. Review API docs at `/api/docs`
3. Check backend logs in terminal
4. Review Flutter debug console

---

**Happy Coding! 🎓🚀**
