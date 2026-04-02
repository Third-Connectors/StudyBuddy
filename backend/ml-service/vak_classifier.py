"""
VAK Classifier using KNN (K-Nearest Neighbors)

This module implements a KNN-based classifier for determining
learning style preferences (Visual, Auditory, Kinesthetic).
"""

import joblib
from pathlib import Path
from typing import List, Dict, Any
import numpy as np
from sklearn.neighbors import KNeighborsClassifier
from sklearn.preprocessing import StandardScaler


class VAKClassifier:
    """
    KNN-based VAK learning style classifier.

    The classifier uses a 20-question psychometric survey
    to determine the dominant learning style.
    """

    def __init__(self, model_path: str = None):
        """
        Initialize the VAK classifier.

        Args:
            model_path: Path to save/load trained model
        """
        self.model_path = model_path or Path(__file__).parent / "models"
        self.model: KNeighborsClassifier = None
        self.scaler: StandardScaler = None
        self.is_trained = False

        # Try to load pre-trained model
        self._load_model()

        # If no model loaded, initialize with default KNN
        if not self.is_trained:
            self._initialize_default_model()

    def _initialize_default_model(self):
        """Initialize default KNN model for MVP"""
        # Use K=5 for KNN
        self.model = KNeighborsClassifier(
            n_neighbors=5,
            metric='euclidean',
            weights='distance'
        )
        self.scaler = StandardScaler()
        # Mark as trained with placeholder (will use rule-based fallback)
        self.is_trained = True

    def classify(self, answers: List[Dict[str, Any]]) -> Dict[str, float]:
        """
        Classify learning style from answers.

        Args:
            answers: List of answer dicts with questionId and selectedOption

        Returns:
            Dict with scores and dominant style
        """
        # Convert answers to feature vector
        feature_vector = self._answers_to_features(answers)

        # Use rule-based scoring (MVP approach)
        # Production: Use trained KNN model
        return self._classify_rule_based(feature_vector)

    def _answers_to_features(self, answers: List[Dict[str, Any]]) -> np.ndarray:
        """
        Convert answers to numerical feature vector.

        Maps A=1, B=2, C=3 for each question.
        """
        features = []
        for answer in sorted(answers, key=lambda x: x['questionId']):
            option = answer['selectedOption'].upper()
            if option == 'A':
                features.append(1)  # Visual
            elif option == 'B':
                features.append(2)  # Auditory
            elif option == 'C':
                features.append(3)  # Kinesthetic
            else:
                features.append(0)  # Unknown

        return np.array(features).reshape(1, -1)

    def _classify_rule_based(self, features: np.ndarray) -> Dict[str, float]:
        """
        Rule-based classification (MVP fallback).

        Counts A (Visual), B (Auditory), C (Kinesthetic) responses.
        """
        flat_features = features.flatten()

        visual_count = np.sum(flat_features == 1)
        auditory_count = np.sum(flat_features == 2)
        kinesthetic_count = np.sum(flat_features == 3)

        total = len(flat_features)

        # Calculate normalized scores (0-1)
        visual_score = visual_count / total if total > 0 else 0
        auditory_score = auditory_count / total if total > 0 else 0
        kinesthetic_score = kinesthetic_count / total if total > 0 else 0

        # Determine dominant style
        scores = {
            'visual': visual_score,
            'auditory': auditory_score,
            'kinesthetic': kinesthetic_score
        }

        dominant_style = max(scores, key=scores.get)

        # Calculate confidence (how dominant is the dominant style?)
        max_score = scores[dominant_style]
        avg_score = sum(scores.values()) / len(scores)
        confidence = max(0, min(1, (max_score - avg_score) * 3))

        return {
            'dominantStyle': dominant_style.capitalize(),
            'visualScore': round(visual_score, 4),
            'auditoryScore': round(auditory_score, 4),
            'kinestheticScore': round(kinesthetic_score, 4),
            'confidence': round(confidence, 4)
        }

    def train(self, X_train: np.ndarray, y_train: np.ndarray):
        """
        Train the KNN classifier.

        Args:
            X_train: Training features (n_samples, n_features)
            y_train: Training labels (n_samples,)
        """
        # Scale features
        X_scaled = self.scaler.fit_transform(X_train)

        # Train model
        self.model.fit(X_scaled, y_train)
        self.is_trained = True

        # Save model
        self._save_model()

        return self

    def predict(self, X: np.ndarray) -> np.ndarray:
        """
        Predict learning styles for new samples.

        Args:
            X: Features (n_samples, n_features)

        Returns:
            Predicted labels
        """
        if not self.is_trained:
            raise ValueError("Model not trained")

        X_scaled = self.scaler.transform(X)
        return self.model.predict(X_scaled)

    def _save_model(self):
        """Save trained model to disk"""
        self.model_path.mkdir(parents=True, exist_ok=True)

        joblib.dump(self.model, self.model_path / "vak_knn_model.pkl")
        joblib.dump(self.scaler, self.model_path / "vak_scaler.pkl")

    def _load_model(self):
        """Load trained model from disk"""
        model_file = self.model_path / "vak_knn_model.pkl"
        scaler_file = self.model_path / "vak_scaler.pkl"

        if model_file.exists() and scaler_file.exists():
            try:
                self.model = joblib.load(model_file)
                self.scaler = joblib.load(scaler_file)
                self.is_trained = True
            except Exception as e:
                print(f"Failed to load model: {e}")

    def get_model_info(self) -> Dict[str, Any]:
        """Get model information"""
        return {
            "type": "KNN Classifier",
            "is_trained": self.is_trained,
            "model_path": str(self.model_path),
            "n_neighbors": self.model.n_neighbors if self.model else None
        }


# ── Training Script (for reference) ──────────────────────────────────────────

def train_vak_model():
    """
    Example training script for VAK classifier.

    Load your training data and train the model.
    """
    # Example: Load your training data
    # X_train = ...  # Shape: (n_samples, 20) - 20 questions
    # y_train = ...  # Shape: (n_samples,) - Labels: 'Visual', 'Auditory', 'Kinesthetic'

    # Initialize and train
    classifier = VAKClassifier()
    # classifier.train(X_train, y_train)

    print("Model training complete!")
    return classifier


if __name__ == "__main__":
    train_vak_model()
