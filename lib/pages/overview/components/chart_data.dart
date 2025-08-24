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
    Key? key,
    required this.productsCount,
    required this.customersCount,
    required this.registeredCarsCount,
    required this.bookedTicketsCount,
    required this.appointmentsCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('Products', productsCount, Colors.blue),
      ChartData('Customers', customersCount, Colors.green),
      ChartData('Cars Registered', registeredCarsCount, Colors.orange),
      ChartData('Tickets', bookedTicketsCount, Colors.red),
      ChartData('Appointments', appointmentsCount, Colors.purple),
    ];

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(child: Column(children: [Text('Products')])),
          ),
        ),
        //
      ],
    );
  }
}
