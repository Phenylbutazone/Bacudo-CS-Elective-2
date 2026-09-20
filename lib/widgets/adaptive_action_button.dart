import 'package:cs_elective_2/utils/platform_adaptive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Platform-native primary action button (Material vs Cupertino).
class AdaptiveActionButton extends StatelessWidget {
  const AdaptiveActionButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    if (PlatformAdaptive.useCupertino) {
      if (onPressed == null) {
        return CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          borderRadius: BorderRadius.circular(22),
          color: CupertinoColors.systemGrey5,
          onPressed: null,
          child: Text(
            label,
            style: const TextStyle(color: CupertinoColors.systemGrey),
          ),
        );
      }
      return CupertinoButton.filled(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        borderRadius: BorderRadius.circular(22),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18),
              const SizedBox(width: 6),
            ],
            Text(label),
          ],
        ),
      );
    }

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18),
            const SizedBox(width: 6),
          ],
          Text(label),
        ],
      ),
    );
  }
}
