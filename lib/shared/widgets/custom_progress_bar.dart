import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// A reusable, rounded linear progress bar used across multiple screens:
/// - Onboarding step indicator (Screen 2)
/// - Study overall progress card
/// - Individual subject progress in the subject list
class CustomProgressBar extends StatelessWidget {
  /// Progress value from 0.0 (empty) to 1.0 (full). Clamped automatically.
  final double progress;

  /// The filled/active color. Defaults to [AppColors.primaryOrange].
  final Color? activeColor;

  /// The unfilled track color. Defaults to [AppColors.progressTrack].
  final Color? trackColor;

  /// Height of the bar in logical pixels. Defaults to 8.
  final double height;

  /// Custom border radius. Defaults to a fully rounded pill shape.
  final BorderRadius? borderRadius;

  const CustomProgressBar({
    super.key,
    required this.progress,
    this.activeColor,
    this.trackColor,
    this.height = 8.0,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    final radius = borderRadius ?? BorderRadius.circular(height);

    return ClipRRect(
      borderRadius: radius,
      child: LinearProgressIndicator(
        value: clampedProgress,
        backgroundColor: trackColor ?? AppColors.progressTrack,
        valueColor: AlwaysStoppedAnimation<Color>(
          activeColor ?? AppColors.primaryOrange,
        ),
        minHeight: height,
      ),
    );
  }
}
