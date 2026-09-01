import 'package:flutter/material.dart';

/// Plus/minus controls — user interaction changes quantity, so [StatefulWidget].
class QuantityControl extends StatefulWidget {
  const QuantityControl({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  State<QuantityControl> createState() => _QuantityControlState();
}

class _QuantityControlState extends State<QuantityControl> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final border = theme.dividerColor;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _WiredStepButton(
            label: '−',
            onPressed: widget.onDecrement,
          ),
          Container(
            width: 1,
            height: 32,
            color: border,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '${widget.quantity}',
              style: theme.textTheme.titleMedium,
            ),
          ),
          Container(
            width: 1,
            height: 32,
            color: border,
          ),
          _WiredStepButton(
            label: '+',
            onPressed: widget.onIncrement,
          ),
        ],
      ),
    );
  }
}

class _WiredStepButton extends StatelessWidget {
  const _WiredStepButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        width: 32,
        height: 32,
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }
}
