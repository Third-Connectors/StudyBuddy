import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

/// A fully styled [TextFormField] that matches the soft peach-bordered
/// aesthetic seen throughout the Onboarding form screens.
///
/// Usage:
/// ```dart
/// CustomTextFormField(
///   label: 'Nama Lengkap',
///   hintText: 'Masukkan nama lengkap',
///   isRequired: true,
///   controller: _namaController,
///   validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
/// )
/// ```
class CustomTextFormField extends StatelessWidget {
  /// The label displayed above the input field.
  final String label;

  /// The placeholder text shown inside the field when empty.
  final String hintText;

  /// When true, an orange asterisk (*) is appended to the label.
  final bool isRequired;

  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  /// Optional widget placed at the trailing edge of the field (e.g. an icon).
  final Widget? suffixIcon;

  /// Optional widget placed at the leading edge of the field.
  final Widget? prefixIcon;

  final bool obscureText;

  /// When true, the field cannot be edited (acts as a display-only tile).
  final bool readOnly;

  /// Called when the user taps the field — useful for pickers / dropdowns.
  final VoidCallback? onTap;

  /// Maximum number of lines. Defaults to 1 (single-line).
  final int maxLines;

  const CustomTextFormField({
    super.key,
    required this.label,
    required this.hintText,
    this.isRequired = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
    this.maxLines = 1,
  });

  // ── Private helpers ────────────────────────────────────────────────────────

  static InputBorder _border(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Label ───────────────────────────────────────────────────────────
        RichText(
          text: TextSpan(
            text: label,
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            children: isRequired
                ? [
                    TextSpan(
                      text: ' *',
                      style: GoogleFonts.nunito(
                        color: AppColors.primaryOrange,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ]
                : [],
          ),
        ),

        const SizedBox(height: 6),

        // ── Input ────────────────────────────────────────────────────────────
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          readOnly: readOnly,
          onTap: onTap,
          maxLines: obscureText ? 1 : maxLines,
          style: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textLight,
            ),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,

            // Fill
            filled: true,
            fillColor: AppColors.primaryOrangeLighter,

            // Spacing
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),

            // Borders
            border: _border(Colors.transparent, 0),
            enabledBorder: _border(Colors.transparent, 0),
            focusedBorder: _border(AppColors.primaryOrangeLight, 1.5),
            errorBorder: _border(Colors.red, 1.5),
            focusedErrorBorder: _border(Colors.red, 2.0),
            disabledBorder: _border(Colors.transparent, 0),

            // Error style
            errorStyle: GoogleFonts.nunito(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}
