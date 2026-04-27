/// Represents the time remaining until the target event (UTBK 2026).
class Countdown {
  final int days;
  final int hours;
  final int minutes;
  final int seconds;

  const Countdown({
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
  });

  /// Factory for an empty/zero countdown.
  factory Countdown.zero() => const Countdown(days: 0, hours: 0, minutes: 0, seconds: 0);
}
