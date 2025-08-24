import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaginationControls extends StatelessWidget {
  final int totalElements;
  final int totalPages;
  final int currentPage;
  final int numberOfElements;
  final int pageSize;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;

  const PaginationControls({
    Key? key,
    required this.totalElements,
    required this.totalPages,
    required this.currentPage,
    required this.numberOfElements,
    required this.pageSize,
    this.onPreviousPage,
    this.onNextPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final start = totalElements == 0 ? 0 : ((currentPage - 1) * pageSize) + 1;
    final end = totalElements == 0 ? 0 : start + numberOfElements - 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text('Mostrando'),
                const SizedBox(width: 8),
                Text('$pageSize registros por página'),
                const SizedBox(width: 16),
                Text('Total: $totalElements'),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: onPreviousPage,
                ),
                Text(
                  'Página $currentPage de $totalPages',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: onNextPage,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text('Mostrando $start-$end de $totalElements registros'),
      ],
    );
  }
}
