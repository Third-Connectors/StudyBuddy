import 'package:flutter/material.dart';

enum VakStyle { visual, auditory, kinesthetic }

class VakOption {
  final String text;
  final VakStyle style;
  final IconData icon;

  const VakOption({
    required this.text,
    required this.style,
    required this.icon,
  });
}

class VakQuestion {
  final int id; // 1-20
  final String question;
  final List<VakOption> options; // always 3: visual, auditory, kinesthetic

  const VakQuestion({
    required this.id,
    required this.question,
    required this.options,
  });
}
