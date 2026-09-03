import 'package:cs_elective_2/theme/wired_colors.dart';
import 'package:flutter/material.dart';

/// CRT scanline overlay reminiscent of fauux's dithered neocities pages.
class ScanlineOverlay extends StatelessWidget {
  const ScanlineOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _ScanlinePainter(
          Theme.of(context).brightness == Brightness.dark
              ? WiredColors.wiredScanline
              : const Color(0x08000000),
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _ScanlinePainter extends CustomPainter {
  _ScanlinePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    for (var y = 0.0; y < size.height; y += 3) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 1), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ScanlinePainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Wraps a screen with subtle scanlines over the scaffold body.
class WiredScaffold extends StatelessWidget {
  const WiredScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: Stack(
        fit: StackFit.expand,
        children: [
          body,
          const ScanlineOverlay(),
        ],
      ),
    );
  }
}

class WiredAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WiredAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
  });

  final String title;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    final border = Theme.of(context).dividerColor;

    return AppBar(
      leading: leading,
      actions: actions,
      title: Text('⌈ $title ⌋'),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: border),
      ),
    );
  }
}

class WiredDivider extends StatelessWidget {
  const WiredDivider({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall;

    if (label != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(label!, style: muted, textAlign: TextAlign.center),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text('---', style: muted, textAlign: TextAlign.center),
    );
  }
}

class WiredOrnament extends StatelessWidget {
  const WiredOrnament({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '║▒░ ║▒░  ░▒║ ░▒║',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            letterSpacing: 2,
          ),
    );
  }
}

class WiredHeroHeader extends StatelessWidget {
  const WiredHeroHeader({
    super.key,
    required this.onToggleVisibility,
    required this.isVisible,
  });

  final VoidCallback onToggleVisibility;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Column(
        children: [
          Text('⌈', style: theme.textTheme.bodySmall),
          const SizedBox(height: 4),
          Text('⌉', style: theme.textTheme.bodySmall),
          const SizedBox(height: 16),
          Text(
            '⌈ Insane Keyboards\nFor Insane People ⌋',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(height: 1.4),
          ),
          const SizedBox(height: 12),
          const WiredOrnament(),
          const SizedBox(height: 8),
          Text(
            '[Welcome]',
            style: theme.textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
          const WiredDivider(),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                isVisible ? 'You are visible.' : 'You are invisible.',
                style: theme.textTheme.bodySmall,
              ),
              TextButton(
                onPressed: onToggleVisibility,
                child: Text(isVisible ? '[Go invisible]' : '[Go visible]'),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Copyright © 2026-2036 · Keyboard Store',
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const SizedBox(height: 16),
          const WiredDivider(label: '# Catalog'),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class WiredPanel extends StatelessWidget {
  const WiredPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      padding: padding,
      child: child,
    );
  }
}
