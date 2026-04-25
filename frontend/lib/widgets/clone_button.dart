// widgets/clone_button.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CloneButton extends StatefulWidget {
  final bool enabled;
  final VoidCallback onTap;

  const CloneButton({super.key, required this.enabled, required this.onTap});

  @override
  State<CloneButton> createState() => _CloneButtonState();
}

class _CloneButtonState extends State<CloneButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        final color = widget.enabled
            ? Color.lerp(const Color(0xFF00B4D8), const Color(0xFF0096BA), _anim.value)!
            : const Color(0xFF1A2E42);

        return GestureDetector(
          onTap: widget.enabled ? widget.onTap : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
              border: widget.enabled
                  ? Border.all(color: const Color(0xFF00B4D8).withOpacity(0.3))
                  : Border.all(color: const Color(0xFF1A2E42)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  color: widget.enabled ? Colors.white : const Color(0xFF2A4A65),
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text('Voice Cloning',
                  style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w600,
                    color: widget.enabled ? Colors.white : const Color(0xFF2A4A65),
                  )),
              ],
            ),
          ),
        );
      },
    );
  }
}
