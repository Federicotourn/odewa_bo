import 'package:flutter/material.dart';

// COMPONENTES AUXILIARES PARA SELECCIÓN DE EMPRESAS

class ActionButton extends StatelessWidget {
  final String button;
  final String label;
  final VoidCallback onPressed;
  final Color color;
  final bool isSmall;

  const ActionButton({
    super.key,
    required this.button,
    required this.label,
    required this.onPressed,
    required this.color,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isSmall ? 6 : 8),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: isSmall ? 8 : 12,
            vertical: isSmall ? 4 : 8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isSmall ? 6 : 8),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(button),
            if (!isSmall) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: isSmall ? 11 : 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
