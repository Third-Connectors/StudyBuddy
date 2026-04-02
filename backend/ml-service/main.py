"""
Study Buddy ML Service - FastAPI

Machine Learning service for:
- VAK Classification (KNN)
- Schedule Optimization (Genetic Algorithm)
- LLM Prompt Processing
"""

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Dict, Any, Optional
import logging

from vak_classifier import VAKClassifier
from schedule_optimizer import ScheduleOptimizer

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize FastAPI app
app = FastAPI(
    title="Study Buddy ML Service",
    description="Machine Learning service for Study Buddy platform",
    version="1.0.0",
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Configure appropriately for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize ML models
vak_classifier = VAKClassifier()
schedule_optimizer = ScheduleOptimizer()


# ── Pydantic Models ───────────────────────────────────────────────────────────

class VakAnswer(BaseModel):
    questionId: int
    selectedOption: str  # 'A', 'B', or 'C'


class VakRequest(BaseModel):
    userId: str
    answers: List[VakAnswer]


class VakResponse(BaseModel):
    userId: str
    dominantStyle: str
    visualScore: float
    auditoryScore: float
    kinestheticScore: float
    confidence: float


class ScheduleEntry(BaseModel):
    id: str
    subject: str
    subjectCode: str
    startTime: str  # ISO format
    endTime: str
    location: Optional[str] = None
    isRecurring: bool = False
    recurringDays: List[str] = []


class ScheduleOptimizeRequest(BaseModel):
    userId: str
    schoolSchedule: List[ScheduleEntry]
    difficultSubjects: List[str]
    upcomingExams: List[str]  # ISO format dates
    vakStyle: Optional[str] = None


class ScheduleOptimizeResponse(BaseModel):
    schedules: List[ScheduleEntry]


# ── Routes ────────────────────────────────────────────────────────────────────

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {
        "status": "healthy",
        "service": "studybuddy-ml-service",
        "version": "1.0.0"
    }


@app.post("/api/v1/vak/classify", response_model=VakResponse)
async def classify_vak(request: VakRequest):
    """
    Classify user's learning style using KNN algorithm.

    Args:
        userId: User identifier
        answers: List of VAK assessment answers

    Returns:
        VAK classification result with scores
    """
    try:
        # Convert answers to format expected by classifier
        answer_data = [
            {"questionId": a.questionId, "selectedOption": a.selectedOption}
            for a in request.answers
        ]

        # Classify using KNN
        result = vak_classifier.classify(answer_data)

        return VakResponse(
            userId=request.userId,
            dominantStyle=result["dominantStyle"],
            visualScore=result["visualScore"],
            auditoryScore=result["auditoryScore"],
            kinestheticScore=result["kinestheticScore"],
            confidence=result["confidence"]
        )

    except Exception as e:
        logger.error(f"VAK classification error: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/api/v1/schedule/optimize", response_model=ScheduleOptimizeResponse)
async def optimize_schedule(request: ScheduleOptimizeRequest):
    """
    Generate optimized study schedule using Genetic Algorithm.

    Args:
        userId: User identifier
        schoolSchedule: Existing school schedule
        difficultSubjects: Subjects user finds difficult
        upcomingExams: List of upcoming exam dates
        vakStyle: User's VAK learning style (optional)

    Returns:
        Optimized study schedule
    """
    try:
        # Convert schedule entries
        school_schedule = [s.dict() for s in request.schoolSchedule]

        # Generate optimized schedule
        optimized = schedule_optimizer.generate(
            school_schedule=school_schedule,
            difficult_subjects=request.difficultSubjects,
            upcoming_exams=request.upcomingExams,
            vak_style=request.vakStyle
        )

        return ScheduleOptimizeResponse(schedules=optimized)

    except Exception as e:
        logger.error(f"Schedule optimization error: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/api/v1/vak/model/info")
async def get_vak_model_info():
    """Get information about the VAK classifier model"""
    return vak_classifier.get_model_info()


# ── Main ──────────────────────────────────────────────────────────────────────

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
