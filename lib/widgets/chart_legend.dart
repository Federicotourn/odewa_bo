import 'package:flutter/material.dart';

class ChartLegend extends StatelessWidget {
  final List<LegendItem> items;
  final MainAxisAlignment alignment;
  final double spacing;
  final EdgeInsets? padding;
  final bool isClickable;
  final Function(LegendItem)? onItemTap;

  const ChartLegend({
    super.key,
    required this.items,
    this.alignment = MainAxisAlignment.center,
    this.spacing = 20.0,
    this.padding,
    this.isClickable = false,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Si el ancho es limitado, usar layout vertical
          if (constraints.maxWidth < 200) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < items.length; i++) ...[
                  _buildLegendItem(items[i]),
                  if (i < items.length - 1) SizedBox(height: spacing),
                ],
              ],
            );
          } else {
            // Si hay más espacio, usar layout horizontal con wrap
            return Wrap(
              spacing: spacing,
              runSpacing: spacing / 2,
              children: [
                for (int i = 0; i < items.length; i++)
                  _buildLegendItem(items[i]),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildLegendItem(LegendItem item) {
    final widget = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: item.color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            item.label,
            style: (item.textStyle ?? const TextStyle()).copyWith(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    if (isClickable && onItemTap != null) {
      return InkWell(
        onTap: () => onItemTap!(item),
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          child: widget,
        ),
      );
    }

    return widget;
  }
}

class LegendItem {
  final String label;
  final Color color;
  final TextStyle? textStyle;

  const LegendItem({required this.label, required this.color, this.textStyle});
}

// Widget de conveniencia para crear leyendas comunes
class OrderStatusLegend extends StatelessWidget {
  final MainAxisAlignment alignment;
  final double spacing;
  final EdgeInsets? padding;
  final bool isClickable;
  final Function(String, int)? onStatusTap;

  const OrderStatusLegend({
    super.key,
    this.alignment = MainAxisAlignment.center,
    this.spacing = 20.0,
    this.padding,
    this.isClickable = false,
    this.onStatusTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChartLegend(
      items: const [
        LegendItem(label: 'Completadas', color: Colors.green),
        LegendItem(label: 'Pendientes', color: Colors.grey),
        LegendItem(label: 'Canceladas', color: Colors.red),
        LegendItem(label: 'Confirmadas', color: Colors.blue),
        LegendItem(label: 'Inicializadas', color: Colors.grey),
        LegendItem(label: 'Requiere contacto', color: Colors.orange),
      ],
      alignment: alignment,
      spacing: 12.0, // Espaciado más compacto
      padding: padding ?? const EdgeInsets.all(8),
      isClickable: isClickable,
      onItemTap:
          isClickable && onStatusTap != null
              ? (item) {
                // Mapear el label a la función correspondiente
                switch (item.label) {
                  case 'Completadas':
                    onStatusTap!('COMPLETED', 0);
                    break;
                  case 'Pendientes':
                    onStatusTap!('PENDING_REVISION', 0);
                    break;
                  case 'Canceladas':
                    onStatusTap!('REJECTED', 0);
                    break;
                  case 'Confirmadas':
                    onStatusTap!('CONFIRMED', 0);
                    break;
                  case 'Inicializadas':
                    onStatusTap!('INITIALIZED', 0);
                    break;
                  case 'Requiere contacto':
                    onStatusTap!('REQUIRES_CONTACT', 0);
                    break;
                }
              }
              : null,
    );
  }
}
