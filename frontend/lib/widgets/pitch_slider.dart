// widgets/pitch_slider.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PitchSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;

  const PitchSlider({super.key, required this.value, this.onChanged});

  String get _pitchLabel {
    if (value == 0) return '0  (no change)';
    return value > 0 ? '+${value.round()}  (higher)' : '${value.round()}  (lower)';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF16263A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E3A52)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Step 3 — Pitch adjustment',
                style: GoogleFonts.poppins(
                  fontSize: 10, color: const Color(0xFF88A0B8), letterSpacing: 0.4)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A1E30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_pitchLabel,
                  style: GoogleFonts.poppins(
                    fontSize: 11, fontWeight: FontWeight.w600,
                    color: const Color(0xFF00B4D8))),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text('-4', style: GoogleFonts.poppins(fontSize: 10, color: const Color(0xFF556675))),
              Expanded(
                child: Slider(
                  value: value,
                  min: -4, max: 4, divisions: 8,
                  onChanged: onChanged,
                ),
              ),
              Text('+4', style: GoogleFonts.poppins(fontSize: 10, color: const Color(0xFF556675))),
            ],
          ),
          Text(
            'Adjust if output pitch sounds too high or too low compared to your natural voice',
            style: GoogleFonts.poppins(fontSize: 10, color: const Color(0xFF3A5A75)),
          ),
        ],
      ),
    );
  }
}
