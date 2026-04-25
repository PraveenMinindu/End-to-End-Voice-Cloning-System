// widgets/progress_card.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/clone_job.dart';

class ProgressCard extends StatefulWidget {
  final CloneJob job;
  const ProgressCard({super.key, required this.job});

  @override
  State<ProgressCard> createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _wave;

  @override
  void initState() {
    super.initState();
    _wave = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat();
  }

  @override
  void dispose() {
    _wave.dispose();
    super.dispose();
  }

  int get _currentStep {
    final label = widget.job.statusLabel.toLowerCase();
    if (label.contains('upload')) return 0;
    if (label.contains('queue') || label.contains('pending')) return 1;
    if (label.contains('demucs')) return 2;
    if (label.contains('hubert')) return 3;
    if (label.contains('training')) return 4;
    if (label.contains('fcpe')) return 5;
    if (label.contains('done')) return 6;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16263A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF1E3A52)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildAnimatedIcon(),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.job.statusLabel,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: widget.job.progress,
                      backgroundColor: const Color(0xFF0D1B2A),
                      color: const Color(0xFF00B4D8),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${(widget.job.progress * 100).toInt()}%',
                style: GoogleFonts.poppins(
                  // Changed from jetbrainsMono to poppins
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF00B4D8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _StageIndicator(currentStep: _currentStep),
        ],
      ),
    );
  }

  Widget _buildAnimatedIcon() {
    return AnimatedBuilder(
      animation: _wave,
      builder: (context, child) {
        return Icon(
          Icons.graphic_eq_rounded, // Fixed: lower-case 'g'
          color: const Color(0xFF00B4D8),
          size: 28 + (sin(_wave.value * 2 * pi) * 4),
        );
      },
    );
  }
}

class _StageIndicator extends StatelessWidget {
  final int currentStep;
  const _StageIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    const stages = [
      'Upload',
      'Queue',
      'Demucs',
      'HuBERT',
      'Train',
      'FCPE',
      'Mix'
    ];
    return Row(
      children: List.generate(stages.length, (i) {
        final done = i < currentStep;
        final active = i == currentStep;
        return Expanded(
          child: Column(
            children: [
              Container(
                height: 4,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: done
                      ? Colors.green
                      : active
                          ? Colors.blue
                          : Colors.grey[800],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 4),
              Text(stages[i],
                  style: const TextStyle(fontSize: 8, color: Colors.white70)),
            ],
          ),
        );
      }),
    );
  }
}
