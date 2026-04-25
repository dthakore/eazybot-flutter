import 'package:flutter/material.dart';
import '../styles/bot_ui_styles.dart';

class BotBadge extends StatelessWidget {
  final String text;
  final String icon;
  final Color bgColor;
  final Color textColor;
  final Color borderColor;

  const BotBadge({
    super.key,
    required this.text,
    required this.icon,
    required this.bgColor,
    required this.textColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(BotUiRadius.lg),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(icon, width: 14, height: 14),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: BotUiFontSize.sm,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
