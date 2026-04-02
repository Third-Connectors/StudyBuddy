# Study Buddy - Backend Services

Monorepo containing all backend services for Study Buddy platform.

## Architecture

```
backend/
├── api-gateway/          # NestJS API Gateway (Port 3000)
├── ml-service/           # Python FastAPI ML Service (Port 8000)
└── docs/                 # API Documentation
```

## Services

### 1. API Gateway (NestJS)
- **Port**: 3000
- **Purpose**: Main API gateway, authentication, business logic
- **Database**: PostgreSQL (user data), MongoDB (content), Redis (cache)

### 2. ML Service (FastAPI)
- **Port**: 8000
- **Purpose**: Machine learning inference
- **Models**: VAK KNN Classifier, Genetic Algorithm Scheduler

## Quick Start

### Prerequisites
- Node.js 18+
- Python 3.10+
- PostgreSQL 15+
- MongoDB 6+
- Redis 7+

### API Gateway Setup

```bash
cd api-gateway
npm install
cp .env.example .env
# Configure .env with your database credentials
npm run start:dev
```

### ML Service Setup

```bash
cd ml-service
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
python main.py
```

## API Documentation

Once running, access Swagger docs at:
- API Gateway: http://localhost:3000/api/docs
- ML Service: http://localhost:8000/docs

## Environment Variables

See `.env.example` in each service directory for required environment variables.

## Testing

```bash
# API Gateway
cd api-gateway
npm run test

# ML Service
cd ml-service
pytest
```

## Deployment

See individual service README files for deployment instructions.
