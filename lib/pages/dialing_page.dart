import 'package:flutter/material.dart';

class DialingPage extends StatelessWidget {
  const DialingPage({super.key});

  static const Color _accent = Color(0xFF00D2FF);
  static const Color _labelGray = Color(0xFF8E8E93);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            _StatusBarRow(),
            const SizedBox(height: 12),
            const Text(
              'Dialing',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const Spacer(flex: 2),
            _ProfileWithRings(),
            const SizedBox(height: 48),
            const Text(
              'Pearl Luna',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '+ 476-229-9449',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            const Spacer(flex: 3),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE5E5EA)),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _LabeledIcon(
                    icon: Icons.mic_none,
                    label: 'Mute',
                  ),
                  _LabeledIcon(
                    icon: Icons.bluetooth,
                    label: 'Bluetooth',
                  ),
                  _LabeledIcon(
                    icon: Icons.pause_circle_outline,
                    label: 'Hold',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.dialpad, size: 28, color: Colors.black87),
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: _accent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.call_end,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  Icon(Icons.volume_up_outlined, size: 28, color: Colors.black87),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _StatusBarRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '9:41',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Row(
            children: [
              Icon(Icons.signal_cellular_alt, size: 16, color: Colors.black87),
              const SizedBox(width: 4),
              Icon(Icons.wifi, size: 16, color: Colors.black87),
              const SizedBox(width: 4),
              Icon(Icons.battery_full, size: 18, color: Colors.black87),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileWithRings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const double avatarSize = 120;
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _Ring(diameter: 280, opacity: 0.12),
          _Ring(diameter: 220, opacity: 0.18),
          _Ring(diameter: 160, opacity: 0.28),
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: const DecorationImage(
                image: AssetImage('assets/dialing_profile.png'),
                fit: BoxFit.cover,
              ),
              border: Border.all(color: Colors.white, width: 3),
            ),
          ),
        ],
      ),
    );
  }
}

class _Ring extends StatelessWidget {
  const _Ring({required this.diameter, required this.opacity});

  final double diameter;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: DialingPage._accent.withValues(alpha: opacity * 2.5),
          width: 2,
        ),
        color: DialingPage._accent.withValues(alpha: opacity * 0.35),
      ),
    );
  }
}

class _LabeledIcon extends StatelessWidget {
  const _LabeledIcon({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.black87),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: DialingPage._labelGray,
          ),
        ),
      ],
    );
  }
}
