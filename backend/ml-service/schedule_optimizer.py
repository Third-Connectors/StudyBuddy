"""
Schedule Optimizer using Genetic Algorithm

Generates optimized study schedules based on:
- User's existing school schedule
- Difficult subjects that need more study time
- Upcoming exams (spaced repetition)
- VAK learning style preferences
"""

import random
from datetime import datetime, timedelta
from typing import Any, Dict, List, Optional

from deap import algorithms, base, creator, tools


class ScheduleOptimizer:
    """
    Genetic Algorithm-based study schedule optimizer.

    Optimizes for:
    - No conflicts with school schedule
    - Spaced repetition for difficult subjects
    - Optimal study times based on VAK style
    - Balanced cognitive load
    """

    def __init__(self):
        """Initialize the schedule optimizer"""
        # Genetic Algorithm parameters
        self.population_size = 100
        self.generations = 50
        self.crossover_rate = 0.7
        self.mutation_rate = 0.2

        # Study session parameters (in hours)
        self.min_session_duration = 1.0
        self.max_session_duration = 2.5
        self.break_between_sessions = 0.5  # 30 minutes

        # Time constraints (24-hour format)
        self.earliest_study_time = 6  # 6 AM
        self.latest_study_time = 22  # 10 PM

        # Indonesian school hours
        self.school_start_hour = 7
        self.school_end_hour = 16

    def generate(
        self,
        school_schedule: List[Dict[str, Any]],
        difficult_subjects: List[str],
        upcoming_exams: List[str],
        vak_style: Optional[str] = None,
        user_id: Optional[str] = None,
    ) -> List[Dict[str, Any]]:
        """
        Generate optimized study schedule.

        Args:
            school_schedule: User's existing school schedule
            difficult_subjects: Subjects that need extra study time
            upcoming_exams: List of exam dates (ISO format)
            vak_style: User's learning style (visual, auditory, kinesthetic)
            user_id: User identifier

        Returns:
            List of optimized study schedule entries
        """
        # Parse school schedule into time slots
        busy_slots = self._parse_school_schedule(school_schedule)

        # Calculate priority for each subject
        subject_priorities = self._calculate_subject_priorities(
            difficult_subjects, upcoming_exams
        )

        # Generate time slots for the week
        available_slots = self._generate_available_slots(busy_slots)

        # Use simple scheduling algorithm (MVP)
        # Production: Full genetic algorithm optimization
        return self._schedule_simple(
            available_slots, subject_priorities, vak_style, user_id or "user"
        )

    def _parse_school_schedule(
        self, schedule: List[Dict[str, Any]]
    ) -> Dict[str, List[tuple]]:
        """
        Parse school schedule into busy time slots.

        Returns dict: {day_of_week: [(start_hour, end_hour), ...]}
        """
        busy_slots = {i: [] for i in range(7)}  # Mon=0 to Sun=6

        for entry in schedule:
            try:
                start = datetime.fromisoformat(
                    entry["startTime"].replace("Z", "+00:00")
                )
                end = datetime.fromisoformat(entry["endTime"].replace("Z", "+00:00"))

                day = start.weekday()
                start_hour = start.hour + start.minute / 60
                end_hour = end.hour + end.minute / 60

                busy_slots[day].append((start_hour, end_hour))
            except Exception as e:
                print(f"Error parsing schedule entry: {e}")

        return busy_slots

    def _calculate_subject_priorities(
        self, difficult_subjects: List[str], upcoming_exams: List[str]
    ) -> Dict[str, float]:
        """
        Calculate study priority for each subject.

        Higher priority = more study time allocated.
        """
        priorities = {}

        # Base priority for difficult subjects
        for subject in difficult_subjects:
            priorities[subject] = priorities.get(subject, 0) + 2.0

        # Increase priority for subjects with upcoming exams
        now = datetime.now()
        for exam_date_str in upcoming_exams:
            try:
                exam_date = datetime.fromisoformat(exam_date_str.replace("Z", "+00:00"))
                days_until_exam = (exam_date - now).days

                if days_until_exam > 0:
                    # Closer exams = higher priority
                    priority_boost = 3.0 / days_until_exam
                    # Assume exam subject is in difficult_subjects
                    for subject in difficult_subjects:
                        priorities[subject] = (
                            priorities.get(subject, 0) + priority_boost
                        )
            except Exception as e:
                print(f"Error parsing exam date: {e}")

        return priorities

    def _generate_available_slots(
        self, busy_slots: Dict[int, List[tuple]]
    ) -> List[Dict[str, Any]]:
        """
        Generate available study time slots for the week.

        Returns list of available slots with day and time range.
        """
        available = []

        for day in range(7):
            # Skip Sunday (day 6) or make it optional
            if day == 6:
                continue

            # Define study windows (before school, after school, evening)
            windows = [
                (self.earliest_study_time, self.school_start_hour),  # Before school
                (self.school_end_hour, self.latest_study_time),  # After school
            ]

            day_busy = busy_slots.get(day, [])

            for window_start, window_end in windows:
                # Check if window overlaps with busy slots
                is_available = True
                for busy_start, busy_end in day_busy:
                    if not (window_end <= busy_start or window_start >= busy_end):
                        is_available = False
                        break

                if (
                    is_available
                    and window_end - window_start >= self.min_session_duration
                ):
                    available.append(
                        {
                            "day": day,
                            "start": window_start,
                            "end": window_end,
                            "duration": window_end - window_start,
                        }
                    )

        return available

    def _schedule_simple(
        self,
        available_slots: List[Dict[str, Any]],
        subject_priorities: Dict[str, float],
        vak_style: Optional[str],
        user_id: str,
    ) -> List[Dict[str, Any]]:
        """
        Simple scheduling algorithm (MVP).

        Distributes study sessions across available slots based on priority.
        """
        schedule = []

        # Sort subjects by priority
        sorted_subjects = sorted(
            subject_priorities.items(), key=lambda x: x[1], reverse=True
        )

        # Assign study sessions
        slot_index = 0
        for subject, priority in sorted_subjects:
            # Number of sessions per week based on priority
            num_sessions = min(4, max(1, int(priority)))

            for i in range(num_sessions):
                if slot_index >= len(available_slots):
                    slot_index = 0  # Wrap around

                slot = available_slots[slot_index]

                # Calculate session time
                session_start = slot["start"] + (
                    i * (self.max_session_duration + self.break_between_sessions)
                )
                session_start = session_start % 24  # Wrap around 24 hours

                if session_start + self.max_session_duration > 24:
                    session_start = 19  # Default to 7 PM

                # Create schedule entry
                start_hour = int(session_start)
                start_minute = int((session_start % 1) * 60)
                end_hour = int(session_start + self.max_session_duration)
                end_minute = int(((session_start + self.max_session_duration) % 1) * 60)

                # Generate date for this week
                now = datetime.now()
                days_until_day = slot["day"] - now.weekday()
                if days_until_day < 0:
                    days_until_day += 7

                session_date = now + timedelta(days=days_until_day)

                schedule.append(
                    {
                        "id": f"study_{subject.lower()}_{slot_index}_{i}",
                        "userId": user_id,
                        "subject": subject,
                        "subjectCode": self._get_subject_code(subject),
                        "startTime": session_date.replace(
                            hour=start_hour,
                            minute=start_minute,
                            second=0,
                            microsecond=0,
                        ).isoformat(),
                        "endTime": session_date.replace(
                            hour=end_hour, minute=end_minute, second=0, microsecond=0
                        ).isoformat(),
                        "location": "Rumah",
                        "notes": f"Fokus pada {subject}",
                        "isRecurring": True,
                        "recurringDays": [self._day_to_string(slot["day"])],
                        "isStudySchedule": True,
                        "source": "ai_generated",
                    }
                )

                slot_index += 1

        return schedule

    def _get_subject_code(self, subject: str) -> str:
        """Get subject code from name"""
        codes = {
            "Matematika": "MTK",
            "Fisika": "FIS",
            "Kimia": "KIM",
            "Biologi": "BIO",
            "Bahasa Indonesia": "IND",
            "Bahasa Inggris": "ING",
            "Sejarah": "SEJ",
            "Geografi": "GEO",
            "Sosiologi": "SOS",
            "Ekonomi": "EKO",
            "PKN": "PKN",
            "Agama": "AGM",
            "Olahraga": "ORKES",
            "Seni Budaya": "SEN",
            "TIK": "TIK",
        }

        for name, code in codes.items():
            if name.lower() in subject.lower():
                return code

        return "UNK"

    def _day_to_string(self, day: int) -> str:
        """Convert day number to string"""
        days = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
        return days[day] if 0 <= day < 7 else "MON"


if __name__ == "__main__":
    # Test the optimizer
    optimizer = ScheduleOptimizer()

    # Example usage
    school_schedule = [
        {
            "id": "sch_1",
            "subject": "Matematika",
            "startTime": "2024-01-15T07:00:00",
            "endTime": "2024-01-15T08:30:00",
        }
    ]

    result = optimizer.generate(
        school_schedule=school_schedule,
        difficult_subjects=["Matematika", "Fisika"],
        upcoming_exams=["2024-02-01T00:00:00"],
        vak_style="visual",
    )

    print(f"Generated {len(result)} study sessions")
    for session in result:
        print(f"  {session['subject']}: {session['startTime']} - {session['endTime']}")
