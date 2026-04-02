# Study Buddy ML Service - Python FastAPI

Machine Learning service for Study Buddy platform.

## Features

- **VAK Classification**: KNN-based learning style classifier
- **Schedule Optimization**: Genetic Algorithm for study schedule generation
- **LLM Prompt Processing**: Advanced prompt engineering for AI tutor

## Setup

### Prerequisites
- Python 3.10+
- pip

### Installation

```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
# Windows:
venv\Scripts\activate
# Linux/Mac:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run development server
uvicorn main:app --reload --port 8000

# Run production server
uvicorn main:app --host 0.0.0.0 --port 8000 --workers 4
```

## API Documentation

Once running, access Swagger docs at:
- http://localhost:8000/docs
- http://localhost:8000/redoc

## Endpoints

### VAK Classification
- `POST /api/v1/vak/classify` - Classify learning style using KNN

### Schedule Optimization
- `POST /api/v1/schedule/optimize` - Generate optimized study schedule using Genetic Algorithm

### Health Check
- `GET /health` - Service health status

## Model Training

To train the VAK classifier:

```bash
python train_vak_model.py
```

## Environment Variables

Copy `.env.example` to `.env` and configure:

```bash
MODEL_PATH=./models
LOG_LEVEL=INFO
```
