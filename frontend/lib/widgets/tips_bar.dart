// widgets/tips_bar.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TipsBar extends StatefulWidget {
  const TipsBar({super.key});

  @override
  State<TipsBar> createState() => _TipsBarState();
}

class _TipsBarState extends State<TipsBar> with SingleTickerProviderStateMixin {
  static const _tips = [
    'Record 20 min of clear voice in a quiet room — turn off fans and AC.',
    'Mixed speech and singing training data gives the most natural results.',
    'FCPE pitch extraction at inference sounds more natural for Sinhala vowels.',
    'Adjust pitch slider if output sounds too high or too low for your voice.',
    'Save your trained model to Google Drive — no need to retrain next time.',
    'Use WAV format for best quality — avoid compressed MP3 for training.',
    'Disable autotune during inference to preserve melodic expression.',
  ];

  int _index = 0;
  late Timer _timer;
  late AnimationController _fade;

  @override
  void initState() {
    super.initState();
    _fade = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      value: 1.0,
    );
    _timer = Timer.periodic(const Duration(seconds: 5), (_) async {
      await _fade.reverse();
      if (mounted) setState(() => _index = (_index + 1) % _tips.length);
      _fade.forward();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _fade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFC62828),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26, height: 26,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.tips_and_updates_rounded,
              color: Colors.white, size: 14),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tips for best results',
                  style: GoogleFonts.poppins(
                    fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                const SizedBox(height: 3),
                FadeTransition(
                  opacity: _fade,
                  child: Text(_tips[_index],
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.88),
                      height: 1.5,
                    )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
