import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';

/// The first onboarding screen — the app's "welcome splash".
///
/// Layout (top → bottom):
/// 1. Light periwinkle-blue background
/// 2. A massive orange dome rising from the bottom containing the mascot face.
/// 3. Bold all-caps hero text: "UPGRADE YOUR SKILLS STARTING NOW" in a bubbly font.
/// 4. A dark-green pill "Let's Start!" CTA button.
class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    // Mascot occupies the bottom 75% of the screen.
    final double mascotHeight = size.height * 0.75;
    final double textTop = size.height * 0.55;

    return Scaffold(
      backgroundColor: AppColors.onboardingTopBlue,
      body: Stack(
        children: [
          // ── 1. Mascot Dome ─────────────────────────────────────────────
          Positioned(
            left: -20,
            right: -20,
            bottom: 0,
            height: mascotHeight,
            child: const _MascotFace(),
          ),

          // ── 2. Hero text ───────────────────────────────────────────────
          Positioned(
            top: textTop,
            left: 20,
            right: 20,
            child: Text(
              'UPGRADE\nYOUR SKILLS\nSTARTING NOW',
              textAlign: TextAlign.center,
              style: GoogleFonts.titanOne(
                fontSize: _heroFontSize(size),
                color: AppColors.textWhite,
                height: 1.15,
                letterSpacing: 1.5,
              ),
            ),
          ),

          // ── 3. CTA button ──────────────────────────────────────────────
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
    if (size.width < 360) return 32.0;
    if (size.width < 400) return 36.0;
    return 40.0;
  }
}

// ── Mascot Face ────────────────────────────────────────────────────────────────

/// Renders the cartoon mascot as a large dome.
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

/// Draws the mascot entirely with [Canvas] primitives.
class _MascotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    // The top of the dome is at y = 0
    // We draw an ellipse/dome that flares out.
    // To make a dome, we can draw a circle with a very large radius whose top hits y=0.
    final double domeW = size.width * 1.1; // Slightly wider than screen
    final double domeH = size.height * 1.3;
    
    final Rect domeRect = Rect.fromCenter(
      center: Offset(cx, size.height * 0.65), // Center shifted down
      width: domeW,
      height: domeH,
    );

    // ── Orange face dome ──────────────────────────────────────────────
    final path = Path()..addOval(domeRect);
    canvas.drawPath(path, Paint()..color = AppColors.primaryOrange);

    // Face elements are positioned relative to the top part of the dome.
    final double faceCenterY = size.height * 0.22;
    final Offset faceCenter = Offset(cx, faceCenterY);

    // ── Eye geometry ────────────────────────────────────────────────────
    final double eyeOffsetX = size.width * 0.12; 
    final double eyeOffsetY = size.height * 0.02; 
    final double socketW = size.width * 0.16;
    final double socketH = size.height * 0.06;
    final double pupilR = socketW * 0.45;
    
    // The design has semi-circle eyes (flat at the bottom) or wide ovals.
    // Looking at the image, they are semi-circles flat at the bottom.
    final leftEyeRect = Rect.fromCenter(
      center: Offset(faceCenter.dx - eyeOffsetX, faceCenter.dy - eyeOffsetY),
      width: socketW * 2,
      height: socketH * 2,
    );
    final rightEyeRect = Rect.fromCenter(
      center: Offset(faceCenter.dx + eyeOffsetX, faceCenter.dy - eyeOffsetY),
      width: socketW * 2,
      height: socketH * 2,
    );

    final whitePaint = Paint()..color = Colors.white;
    // Draw top half of ellipse for eyes
    canvas.drawArc(leftEyeRect, math.pi, math.pi, true, whitePaint);
    canvas.drawArc(rightEyeRect, math.pi, math.pi, true, whitePaint);

    // Dark pupils
    final darkPaint = Paint()..color = const Color(0xFF1A1A2E);
    canvas.drawCircle(
      Offset(faceCenter.dx - eyeOffsetX, faceCenter.dy - eyeOffsetY),
      pupilR,
      darkPaint,
    );
    canvas.drawCircle(
      Offset(faceCenter.dx + eyeOffsetX, faceCenter.dy - eyeOffsetY),
      pupilR,
      darkPaint,
    );

    // ── Open-mouth smile ────────────────────────────────────────────────
    final double mouthCy = faceCenter.dy + size.height * 0.04;
    final double mouthW = size.width * 0.35; 
    final double mouthH = size.height * 0.12; 

    final mouthRect = Rect.fromCenter(
      center: Offset(faceCenter.dx, mouthCy),
      width: mouthW * 2,
      height: mouthH * 2,
    );

    canvas.drawArc(mouthRect, 0, math.pi, true, darkPaint);

    // ── Red tongue ──────────────────────────────────────────────────────
    canvas.save();
    canvas.clipRect(
      Rect.fromLTWH(faceCenter.dx - mouthW, mouthCy, mouthW * 2, mouthH * 1.2),
    );

    final tongueRect = Rect.fromCenter(
      center: Offset(faceCenter.dx, mouthCy + mouthH * 0.8),
      width: mouthW * 1.2,
      height: mouthH * 0.9,
    );
    canvas.drawOval(tongueRect, Paint()..color = const Color(0xFFC62828));
    canvas.restore();
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // "Sudah punya akun?" button
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
                color: AppColors.textWhite.withOpacity(0.8),
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
        const SizedBox(height: 12),
        // "Let's Start!" button
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.darkGreen,
            foregroundColor: AppColors.textWhite,
            minimumSize: const Size.fromHeight(60),
            shape: const StadiumBorder(),
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Let's Start!",
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textWhite,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.arrow_forward_rounded, size: 22),
            ],
          ),
        ),
      ],
    );
  }
}
