import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomNumpad extends StatelessWidget {
  final Function(String) onKeyPressed;
  final VoidCallback onDelete;
  final VoidCallback onClear;

  const CustomNumpad({
    super.key,
    required this.onKeyPressed,
    required this.onDelete,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final btnBg = isDark ? const Color(0xFF2C2C2E) : Colors.white;
    final btnTextColor = isDark ? Colors.white : const Color(0xFF1C1C1E);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _buildButton('1', btnBg, btnTextColor),
              _buildButton('2', btnBg, btnTextColor),
              _buildButton('3', btnBg, btnTextColor),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildButton('4', btnBg, btnTextColor),
              _buildButton('5', btnBg, btnTextColor),
              _buildButton('6', btnBg, btnTextColor),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildButton('7', btnBg, btnTextColor),
              _buildButton('8', btnBg, btnTextColor),
              _buildButton('9', btnBg, btnTextColor),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildActionButton(
                icon: CupertinoIcons.clear,
                color: btnBg,
                iconColor: Colors.orange,
                onTap: () {
                  HapticFeedback.lightImpact();
                  onClear();
                },
              ),
              _buildButton('0', btnBg, btnTextColor),
              _buildActionButton(
                icon: CupertinoIcons.delete_left,
                color: btnBg,
                iconColor: Colors.red,
                onTap: () {
                  HapticFeedback.lightImpact();
                  onDelete();
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildButton('000', btnBg, btnTextColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, Color bg, Color textColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: 52,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: bg,
            foregroundColor: textColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            HapticFeedback.lightImpact();
            onKeyPressed(text);
          },
          child: Text(
            text,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: 52,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: onTap,
          child: Icon(icon, color: iconColor, size: 22),
        ),
      ),
    );
  }
}
