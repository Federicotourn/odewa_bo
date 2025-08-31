import 'package:flutter/material.dart';

class ChartData {
  final String category;
  final int count;
  final Color color;

  ChartData(this.category, this.count, this.color);
}

class PieChartWidget extends StatelessWidget {
  final int productsCount;
  final int customersCount;
  final int registeredCarsCount;
  final int bookedTicketsCount;
  final int appointmentsCount;

  const PieChartWidget({
    super.key,
    required this.productsCount,
    required this.customersCount,
    required this.registeredCarsCount,
    required this.bookedTicketsCount,
    required this.appointmentsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [Text('Products')]),
          ),
        ),
      ],
    );
  }
}
