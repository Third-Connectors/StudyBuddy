import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';

/// The first onboarding screen — the app's "welcome splash".
///
/// Layout (top → bottom):
/// 1. Light periwinkle-blue background
/// 2. A massive orange dome (arch/stadium top + rectangle bottom) rising from
///    about 30% from the top, containing the mascot face near the top.
/// 3. Bold all-caps hero text: "UPGRADE YOUR SKILLS STARTING NOW" in a bubbly font.
/// 4. A dark-green pill "Let's Start!" CTA button.
class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);

    // The orange dome starts at ~25% from the top of the screen
    final double domeTop = size.height * 0.22;
    // The face center is positioned within the upper portion of the dome
    final double faceCenterY = domeTop + size.height * 0.14;

    return Scaffold(
      backgroundColor: AppColors.onboardingTopBlue,
      body: Stack(
        children: [
          // ── 1. Orange Dome Shape ───────────────────────────────────────
          Positioned(
            top: domeTop,
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomPaint(
              painter: _DomePainter(),
            ),
          ),

          // ── 2. Mascot Face ────────────────────────────────────────────
          Positioned(
            top: faceCenterY - size.width * 0.20,
            left: 0,
            right: 0,
            child: SizedBox(
              height: size.width * 0.50,
              child: CustomPaint(
                painter: _FacePainter(),
              ),
            ),
          ),

          // ── 3. Hero text ──────────────────────────────────────────────
          Positioned(
            top: size.height * 0.52,
            left: 28,
            right: 28,
            child: Text(
              'UPGRADE\nYOUR SKILLS\nSTARTING NOW',
              textAlign: TextAlign.center,
              style: GoogleFonts.titanOne(
                fontSize: _heroFontSize(size),
                color: AppColors.textWhite,
                height: 1.15,
                letterSpacing: 1.2,
              ),
            ),
          ),

          // ── 4. CTA button ─────────────────────────────────────────────
          Positioned(
            bottom: padding.bottom + 40,
            left: 60,
            right: 60,
            child: _LetStartButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed('/onboarding2'),
            ),
          ),
        ],
      ),
    );
  }

  /// Scales the hero font down slightly on very small screens.
  double _heroFontSize(Size size) {
    if (size.width < 360) return 30.0;
    if (size.width < 400) return 34.0;
    return 38.0;
  }
}

// ── Dome Shape Painter ──────────────────────────────────────────────────────

/// Paints the orange arch-topped rectangle that fills from the dome top to the
/// bottom of the screen. The top edge is a semicircular arch.
class _DomePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.primaryOrange;

    // The arch radius is half the width so the top forms a perfect semicircle
    final double archRadius = size.width * 0.44;
    final double cx = size.width / 2;

    final path = Path();
    // Start at bottom-left
    path.moveTo(0, size.height);
    // Line up the left side to where the arch begins
    path.lineTo(0, archRadius);
    // Draw the semicircular arch at the top
    path.arcTo(
      Rect.fromCenter(
        center: Offset(cx, archRadius),
        width: size.width,
        height: archRadius * 2,
      ),
      math.pi, // start angle (left)
      math.pi, // sweep angle (semicircle going right)
      false,
    );
    // Line down the right side
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Mascot Face Painter ─────────────────────────────────────────────────────

/// Draws the mascot's eyes and mouth at the center of its bounding box.
class _FacePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.40;

    // ── Eye geometry ──────────────────────────────────────────────────────
    final double eyeSpacing = size.width * 0.10;
    final double eyeW = size.width * 0.10;
    final double eyeH = eyeW * 0.80;

    final Offset leftEyeCenter = Offset(cx - eyeSpacing, cy);
    final Offset rightEyeCenter = Offset(cx + eyeSpacing, cy);

    final whitePaint = Paint()..color = Colors.white;
    final darkPaint = Paint()..color = const Color(0xFF1A1A2E);
    final highlightPaint = Paint()..color = Colors.white;

    // White eye sclera — semicircle (flat at bottom, rounded on top)
    for (final eyeCenter in [leftEyeCenter, rightEyeCenter]) {
      final eyeRect = Rect.fromCenter(
        center: eyeCenter,
        width: eyeW * 2,
        height: eyeH * 2,
      );
      // Draw top half-circle for white part of eye
      canvas.drawArc(eyeRect, math.pi, math.pi, true, whitePaint);
    }

    // Dark pupils — circles sitting at the bottom-center of each eye
    final double pupilR = eyeW * 0.52;
    final double pupilOffsetY = -eyeH * 0.15;
    for (final eyeCenter in [leftEyeCenter, rightEyeCenter]) {
      canvas.drawCircle(
        Offset(eyeCenter.dx, eyeCenter.dy + pupilOffsetY),
        pupilR,
        darkPaint,
      );
      // White highlight dot
      canvas.drawCircle(
        Offset(eyeCenter.dx + pupilR * 0.30, eyeCenter.dy + pupilOffsetY - pupilR * 0.30),
        pupilR * 0.25,
        highlightPaint,
      );
    }

    // ── Mouth ─────────────────────────────────────────────────────────────
    final double mouthCy = cy + size.height * 0.22;
    final double mouthW = size.width * 0.24;
    final double mouthH = size.height * 0.28;

    final mouthRect = Rect.fromCenter(
      center: Offset(cx, mouthCy),
      width: mouthW * 2,
      height: mouthH * 2,
    );

    // Dark open mouth (bottom semicircle)
    canvas.drawArc(mouthRect, 0, math.pi, true, darkPaint);

    // ── Red tongue ────────────────────────────────────────────────────────
    canvas.save();
    // Clip to the mouth area so tongue doesn't overflow
    final clipPath = Path()..addArc(mouthRect, 0, math.pi);
    canvas.clipPath(clipPath);

    final tongueRect = Rect.fromCenter(
      center: Offset(cx, mouthCy + mouthH * 0.65),
      width: mouthW * 1.0,
      height: mouthH * 0.80,
    );
    canvas.drawOval(tongueRect, Paint()..color = const Color(0xFFC62828));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── CTA Button ──────────────────────────────────────────────────────────────

class _LetStartButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _LetStartButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // "Sudah punya akun?" link
        TextButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (route) => false,
            );
          },
          child: RichText(
            text: TextSpan(
              text: 'Sudah punya akun? ',
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: AppColors.textWhite.withValues(alpha: 0.8),
              ),
              children: [
                TextSpan(
                  text: 'Login',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textWhite,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        // "Let's Start!" button
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.darkGreen,
            foregroundColor: AppColors.textWhite,
            minimumSize: const Size.fromHeight(56),
            shape: const StadiumBorder(),
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Let's Start!",
                style: GoogleFonts.nunito(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textWhite,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: AppColors.textWhite,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
