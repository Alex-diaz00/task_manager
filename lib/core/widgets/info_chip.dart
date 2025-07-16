import 'package:flutter/material.dart';

/// A reusable, modern-looking chip to display lightweight information such as
/// tags, status, priorities, etc.
///
/// The chip uses [backgroundColor] as a subtle container color (10% opacity)
/// and draws a stronger outline with the same color for better visibility.
class InfoChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  final EdgeInsetsGeometry padding;

  const InfoChip({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  });

  @override
  Widget build(BuildContext context) {
    final background = color.withValues(alpha: 0.1);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1.4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
