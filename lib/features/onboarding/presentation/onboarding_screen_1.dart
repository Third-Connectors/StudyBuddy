import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';

/// The first onboarding screen — the app's "welcome splash".
///
/// Layout (top → bottom):
/// 1. Light periwinkle-blue upper band (~40 % of screen height)
/// 2. Vibrant orange lower band (remaining ~60 %)
/// 3. A large white circle that straddles the colour boundary, containing
///    a hand-drawn cartoon mascot face painted with [Canvas] primitives.
/// 4. Bold all-caps hero text: "UPGRADE YOUR SKILLS STARTING NOW"
/// 5. A dark-green pill "Let's Start!" CTA button
class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    // ── Layout constants ──────────────────────────────────────────────────
    // The horizontal split between blue and orange sits at ~40 % from the top.
    final double splitY = size.height * 0.40;

    // The mascot circle diameter is ~70 % of screen width.
    final double circleSize = size.width * 0.70;

    // Position the circle so roughly 38 % of it is in the blue area and
    // 62 % falls into the orange area — matching the design reference.
    final double circleTop = splitY - (circleSize * 0.38);
    final double circleLeft = (size.width - circleSize) / 2;

    // The hero text block starts just below the bottom edge of the circle.
    final double textTop = circleTop + circleSize + 12;

    return Scaffold(
      backgroundColor: AppColors.primaryOrange,
      body: Stack(
        children: [
          // ── 1. Blue upper background ───────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: splitY,
            child: const ColoredBox(color: AppColors.onboardingTopBlue),
          ),

          // ── 2. Orange lower background (already set as scaffold bg) ───
          // No extra widget needed — the scaffold's own background colour
          // covers the lower portion.

          // ── 3. Mascot white circle ─────────────────────────────────────
          Positioned(
            top: circleTop,
            left: circleLeft,
            width: circleSize,
            height: circleSize,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10),
                    blurRadius: 32,
                    spreadRadius: 4,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const _MascotFace(),
            ),
          ),

          // ── 4. Hero text ───────────────────────────────────────────────
          Positioned(
            top: textTop,
            left: 28,
            right: 28,
            child: Text(
              'UPGRADE\nYOUR SKILLS\nSTARTING NOW',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: _heroFontSize(size),
                fontWeight: FontWeight.w900,
                color: AppColors.textWhite,
                height: 1.10,
                letterSpacing: 2.5,
              ),
            ),
          ),

          // ── 5. CTA button ──────────────────────────────────────────────
          Positioned(
            bottom: 44,
            left: 40,
            right: 40,
            child: _LetStartButton(
              onPressed: () => Navigator.of(context).pushNamed('/onboarding2'),
            ),
          ),
        ],
      ),
    );
  }

  /// Scales the hero font down slightly on very small screens.
  double _heroFontSize(Size size) {
    if (size.width < 360) return 28.0;
    if (size.width < 400) return 32.0;
    return 36.0;
  }
}

// ── Mascot Face ────────────────────────────────────────────────────────────────

/// Renders the cartoon mascot inside the white circle using [CustomPaint].
class _MascotFace extends StatelessWidget {
  const _MascotFace();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => CustomPaint(
        size: Size(constraints.maxWidth, constraints.maxHeight),
        painter: _MascotPainter(),
      ),
    );
  }
}

/// Draws the mascot entirely with [Canvas] primitives — no image assets required.
///
/// Face anatomy (all coordinates relative to the bounding [Size]):
/// - Orange circle (face)
/// - Two white eye sockets with dark pupils
/// - Wide open-mouth smile (white arc) with a red tongue
/// - Subtle white cheek blush spots
class _MascotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // The face is a circle that occupies ~62 % of the container width.
    final double r = size.width * 0.31;

    // Centre the face slightly above the geometric centre for visual balance.
    final faceCenter = Offset(cx, cy - r * 0.04);

    // ── Orange face circle ──────────────────────────────────────────────
    canvas.drawCircle(faceCenter, r, Paint()..color = AppColors.primaryOrange);

    // ── Eye geometry ────────────────────────────────────────────────────
    final double eyeOffsetX = r * 0.34; // horizontal distance from centre
    final double eyeOffsetY = r * 0.18; // how far above centre
    final double socketR = r * 0.27; // white eye socket radius
    final double pupilR = socketR * 0.46; // black pupil radius
    final double shineR = pupilR * 0.32; // white highlight dot

    final leftEye = Offset(
      faceCenter.dx - eyeOffsetX,
      faceCenter.dy - eyeOffsetY,
    );
    final rightEye = Offset(
      faceCenter.dx + eyeOffsetX,
      faceCenter.dy - eyeOffsetY,
    );

    // White sockets
    final whitePaint = Paint()..color = Colors.white;
    canvas.drawCircle(leftEye, socketR, whitePaint);
    canvas.drawCircle(rightEye, socketR, whitePaint);

    // Dark pupils (shifted slightly inward and downward for a "looking at you" feel)
    final darkPaint = Paint()..color = const Color(0xFF1A1A2E);
    canvas.drawCircle(
      Offset(leftEye.dx + socketR * 0.10, leftEye.dy + socketR * 0.12),
      pupilR,
      darkPaint,
    );
    canvas.drawCircle(
      Offset(rightEye.dx - socketR * 0.10, rightEye.dy + socketR * 0.12),
      pupilR,
      darkPaint,
    );

    // Specular shine highlights
    final shinePaint = Paint()..color = Colors.white;
    canvas.drawCircle(
      Offset(leftEye.dx - socketR * 0.04, leftEye.dy - socketR * 0.04),
      shineR,
      shinePaint,
    );
    canvas.drawCircle(
      Offset(rightEye.dx - socketR * 0.04, rightEye.dy - socketR * 0.04),
      shineR,
      shinePaint,
    );

    // ── Open-mouth smile ────────────────────────────────────────────────
    // The mouth is the BOTTOM half of an ellipse filled with white,
    // creating the "wide open smile" look.
    final double mouthCy = faceCenter.dy + r * 0.30;
    final double mouthW = r * 1.30; // half-width of the ellipse
    final double mouthH = r * 0.72; // half-height of the ellipse

    final mouthRect = Rect.fromCenter(
      center: Offset(faceCenter.dx, mouthCy),
      width: mouthW * 2,
      height: mouthH * 2,
    );

    // Draw the filled bottom-half arc (startAngle=0, sweep=π → right→bottom→left)
    canvas.drawArc(mouthRect, 0, math.pi, true, whitePaint);

    // ── Red tongue ──────────────────────────────────────────────────────
    // Clip drawing to the white mouth region so the tongue stays inside.
    canvas.save();
    // Clip rect: the lower half of the mouthRect bounding box
    canvas.clipRect(
      Rect.fromLTWH(faceCenter.dx - mouthW, mouthCy, mouthW * 2, mouthH * 1.2),
    );

    final tongueRect = Rect.fromCenter(
      center: Offset(faceCenter.dx, mouthCy + mouthH * 0.28),
      width: mouthW * 0.78,
      height: mouthH * 0.64,
    );
    canvas.drawOval(tongueRect, Paint()..color = const Color(0xFFE53935));
    canvas.restore();

    // ── Cheek blush ─────────────────────────────────────────────────────
    final blushPaint = Paint()..color = Colors.white.withValues(alpha: 0.20);
    final double blushR = socketR * 0.55;
    final double blushY = faceCenter.dy + r * 0.14;

    canvas.drawCircle(
      Offset(faceCenter.dx - eyeOffsetX - socketR * 0.45, blushY),
      blushR,
      blushPaint,
    );
    canvas.drawCircle(
      Offset(faceCenter.dx + eyeOffsetX + socketR * 0.45, blushY),
      blushR,
      blushPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── CTA Button ─────────────────────────────────────────────────────────────────

class _LetStartButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _LetStartButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkGreen,
        foregroundColor: AppColors.textWhite,
        minimumSize: const Size.fromHeight(54),
        shape: const StadiumBorder(),
        elevation: 6,
        shadowColor: AppColors.darkGreen.withValues(alpha: 0.45),
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Let's Start!",
            style: GoogleFonts.nunito(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textWhite,
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.arrow_forward_rounded, size: 20),
        ],
      ),
    );
  }
}
