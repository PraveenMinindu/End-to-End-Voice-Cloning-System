// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/clone_job.dart';
import '../services/clone_job_provider.dart';
import '../widgets/upload_card.dart';
import '../widgets/pitch_slider.dart';
import '../widgets/clone_button.dart';
import '../widgets/progress_card.dart';
import '../widgets/result_card.dart';
import '../widgets/tips_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

// ── Pick voice file — WEB VERSION ─────────────────────────────
  Future<void> _pickVoice(BuildContext ctx) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      withData: true,
    );
    if (result != null && ctx.mounted) {
      ctx.read<CloneJobProvider>().setVoiceFile(
            result.files.single.bytes!,
            result.files.single.name,
          );
    }
  }

  // ── Pick song file — WEB VERSION ──────────────────────────────

  Future<void> _pickSong(BuildContext ctx) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      withData: true,
    );
    if (result != null && ctx.mounted) {
      ctx.read<CloneJobProvider>().setSongFile(
            result.files.single.bytes!,
            result.files.single.name,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _Header(),
            Expanded(
              child: Consumer<CloneJobProvider>(
                builder: (ctx, provider, _) {
                  final job = provider.job;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
                    child: Column(
                      children: [
                        // ── Upload cards ────────────────────────────────
                        UploadCard(
                          step: '01',
                          title: 'Your voice recording',
                          subtitle: '20 min · WAV or MP3 · quiet room',
                          icon: Icons.mic_none_rounded,
                          fileName: provider.voiceFileName,
                          isLocked: job.isActive,
                          onTap: job.isActive ? null : () => _pickVoice(ctx),
                        ),
                        const SizedBox(height: 10),

                        UploadCard(
                          step: '02',
                          title: 'Sinhala song',
                          subtitle:
                              'Full song · vocals auto-separated by Demucs',
                          icon: Icons.music_note_rounded,
                          fileName: provider.songFileName,
                          isLocked: job.isActive,
                          onTap: job.isActive ? null : () => _pickSong(ctx),
                        ),
                        const SizedBox(height: 10),

                        // ── Pitch slider ─────────────────────────────────
                        if (!job.isActive && !job.isSuccess)
                          PitchSlider(
                            value: provider.pitch.toDouble(),
                            onChanged: job.isActive
                                ? null
                                : (v) => provider.setPitch(v.round()),
                          ),

                        if (!job.isActive && !job.isSuccess)
                          const SizedBox(height: 14),

                        // ── Clone button (idle state) ────────────────────
                        if (job.isIdle)
                          CloneButton(
                            enabled: provider.canStart,
                            onTap: provider.startCloning,
                          ),

                        // ── Progress card (active state) ─────────────────
                        if (job.isActive) ProgressCard(job: job),

                        // ── Error card ────────────────────────────────────
                        if (job.isError)
                          _ErrorCard(
                            message: job.errorMessage ?? 'Unknown error',
                            onRetry: provider.reset,
                          ),

                        // ── Result card (done state) ──────────────────────
                        if (job.isSuccess)
                          ResultCard(
                            outputUrl: job.outputUrl!,
                            onDownload: provider.downloadResult,
                            onNewSong: provider.reset,
                          ),

                        const SizedBox(height: 10),
                      ],
                    ),
                  );
                },
              ),
            ),

            // ── Tips bar — red, bottom ───────────────────────────────────
            const TipsBar(),
          ],
        ),
      ),
    );
  }
}

// ── Header widget ─────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0A1622),
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF00B4D8),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(Icons.graphic_eq_rounded,
                color: Colors.white, size: 20),
          ),
          const SizedBox(width: 11),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('VoiceClone',
                  style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
              Text('Sinhala Voice Cloner',
                  style: GoogleFonts.poppins(
                      fontSize: 10, color: const Color(0xFF88A0B8))),
            ],
          ),
          const Spacer(),
          // Status dot
          Consumer<CloneJobProvider>(
            builder: (_, p, __) => Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: p.job.isActive
                    ? const Color(0xFFFFC300)
                    : p.job.isSuccess
                        ? const Color(0xFF00E696)
                        : p.job.isError
                            ? const Color(0xFFEF5350)
                            : const Color(0xFF2A4A65),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Error card ────────────────────────────────────────────────────────────────
class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A0E0E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEF5350).withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.error_outline_rounded,
                  color: Color(0xFFEF5350), size: 20),
              const SizedBox(width: 8),
              Text('Processing Failed',
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
            ],
          ),
          const SizedBox(height: 8),
          Text(message,
              style: GoogleFonts.poppins(
                  fontSize: 11, color: const Color(0xFF88A0B8))),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF5350)),
              child: Text('Try Again',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
