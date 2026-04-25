// widgets/result_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';

class ResultCard extends StatefulWidget {
  final String outputUrl;
  final Future<void> Function() onDownload;
  final VoidCallback onNewSong;

  const ResultCard({
    super.key,
    required this.outputUrl,
    required this.onDownload,
    required this.onNewSong,
  });

  @override
  State<ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<ResultCard> {
  final _player = AudioPlayer();
  bool _isPlaying = false;
  bool _isDownloading = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _setupPlayer();
  }

  void _setupPlayer() {
    _player.onPlayerStateChanged.listen((s) {
      if (mounted) setState(() => _isPlaying = s == PlayerState.playing);
    });
    _player.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });
    _player.onDurationChanged.listen((d) {
      if (mounted) setState(() => _duration = d);
    });
    _player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    });
  }

  Future<void> _togglePlay() async {
    try {
      if (_isPlaying) {
        await _player.pause();
      } else {
        // 1. Set the source with the bypass query parameter
        await _player.setSource(UrlSource(widget.outputUrl));

        // 2. On Web, we must ensure the volume is up and resume
        await _player.setVolume(1.0);
        await _player.resume();
      }
    } catch (e) {
      debugPrint("Audio Error: $e");
      // This snackbar will tell you if the browser is still blocking it
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "Browser blocked audio. Click 'Download' and 'Visit Site' first.")),
      );
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16263A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF00B4D8).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text('Conversion Complete!',
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 20),

          // Audio Player UI
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1B2A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Slider(
                  value: _position.inMilliseconds.toDouble(),
                  max: _duration.inMilliseconds.toDouble() > 0
                      ? _duration.inMilliseconds.toDouble()
                      : 1.0,
                  onChanged: (v) =>
                      _player.seek(Duration(milliseconds: v.toInt())),
                  activeColor: const Color(0xFF00B4D8),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDuration(_position),
                        style:
                            const TextStyle(fontSize: 10, color: Colors.grey)),
                    IconButton(
                      icon: Icon(
                          _isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          size: 40,
                          color: const Color(0xFF00B4D8)),
                      onPressed: _togglePlay,
                    ),
                    Text(_formatDuration(_duration),
                        style:
                            const TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Download Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () async {
                setState(() => _isDownloading = true);
                await widget.onDownload();
                setState(() => _isDownloading = false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFC300),
                foregroundColor: const Color(0xFF0D1B2A),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              icon: _isDownloading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.download_rounded),
              label: Text(
                  _isDownloading ? 'Downloading...' : 'Download Final Song',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            ),
          ),

          TextButton(
            onPressed: widget.onNewSong,
            child: Text('Convert Another Song',
                style: GoogleFonts.poppins(
                    color: const Color(0xFF88A0B8), fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
