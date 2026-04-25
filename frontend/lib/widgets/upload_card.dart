// widgets/upload_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadCard extends StatelessWidget {
  final String step;
  final String title;
  final String subtitle;
  final IconData icon;
  final String? fileName;
  final bool isLocked;
  final VoidCallback? onTap;

  const UploadCard({
    super.key,
    required this.step,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.fileName,
    this.isLocked = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final uploaded = fileName != null;
    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF16263A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: uploaded
                ? const Color(0xFF00E696)
                : isLocked
                    ? const Color(0xFF1A2E42)
                    : const Color(0xFF1E3A52),
            width: uploaded ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            // Step number badge
            Container(
              width: 30, height: 30,
              decoration: BoxDecoration(
                color: uploaded ? const Color(0xFF0A2E1E) : const Color(0xFF0A1E30),
                borderRadius: BorderRadius.circular(9),
              ),
              alignment: Alignment.center,
              child: Text(step,
                style: GoogleFonts.poppins(
                  fontSize: 10, fontWeight: FontWeight.w700,
                  color: uploaded ? const Color(0xFF00E696) : const Color(0xFF556675),
                )),
            ),
            const SizedBox(width: 12),

            // Icon
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: uploaded ? const Color(0xFF0A2E1E) : const Color(0xFF0D1E2E),
                borderRadius: BorderRadius.circular(11),
                border: Border.all(
                  color: uploaded ? const Color(0xFF00E696).withOpacity(0.4) : const Color(0xFF1E3A52),
                ),
              ),
              child: Icon(
                uploaded ? Icons.check_circle_outline_rounded : icon,
                color: uploaded ? const Color(0xFF00E696) : const Color(0xFF88A0B8),
                size: 19,
              ),
            ),
            const SizedBox(width: 12),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    uploaded ? fileName! : title,
                    style: GoogleFonts.poppins(
                      fontSize: 13, fontWeight: FontWeight.w500,
                      color: uploaded ? const Color(0xFF00E696) : const Color(0xFFCCDDEE),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(subtitle,
                    style: GoogleFonts.poppins(fontSize: 10, color: const Color(0xFF556675))),
                ],
              ),
            ),

            Icon(
              uploaded ? Icons.edit_rounded : Icons.upload_file_rounded,
              color: const Color(0xFF2A4A65), size: 17,
            ),
          ],
        ),
      ),
    );
  }
}
