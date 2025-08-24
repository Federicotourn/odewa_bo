// ignore_for_file: non_constant_identifier_names
import 'package:odewa_bo/pages/overview/controllers/overview_controller.dart';
import 'package:odewa_bo/pages/overview/models/dashboard_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class OverviewPage extends StatelessWidget {
  final OverviewController controller = Get.put(OverviewController());

  OverviewPage({super.key});

  Widget _buildPieChart() {
    return Obx(() {
      if (controller.isLoading.value ||
          controller.dashboardData.value == null) {
        return const Center(child: CircularProgressIndicator());
      }

      return PieChart(
        PieChartData(
          sections: [
            // Completed
            PieChartSectionData(
              color: Colors.green.shade400,
              value:
                  controller.dashboardData.value?.ordersByStatus
                      .firstWhereOrNull(
                        (element) => element.status == 'COMPLETED',
                      )
                      ?.quantity
                      .toDouble() ??
                  0,
              title:
                  controller.dashboardData.value?.ordersByStatus
                      .firstWhereOrNull(
                        (element) => element.status == 'COMPLETED',
                      )
                      ?.quantity
                      .toDouble()
                      .toString() ??
                  '0',
              radius: 100,
              titleStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            // Pending
            PieChartSectionData(
              color: Colors.grey.shade400,
              value:
                  controller.dashboardData.value?.ordersByStatus
                      .firstWhereOrNull(
                        (element) => element.status == 'PENDING_REVISION',
                      )
                      ?.quantity
                      .toDouble() ??
                  0,
              title:
                  controller.dashboardData.value?.ordersByStatus
                      .firstWhere(
                        (element) => element.status == 'PENDING_REVISION',
                      )
                      .quantity
                      .toDouble()
                      .toString(),
              radius: 100,
              titleStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            // Cancelled
            PieChartSectionData(
              color: Colors.red.shade400,
              value:
                  controller.dashboardData.value?.ordersByStatus
                      .firstWhereOrNull(
                        (element) => element.status == 'REJECTED',
                      )
                      ?.quantity
                      .toDouble() ??
                  0,
              title:
                  controller.dashboardData.value?.ordersByStatus
                      .firstWhereOrNull(
                        (element) => element.status == 'REJECTED',
                      )
                      ?.quantity
                      .toDouble()
                      .toString() ??
                  '0',
              radius: 100,
              titleStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            // Confirmed
            PieChartSectionData(
              color: Colors.blue.shade400,
              value:
                  controller.dashboardData.value?.ordersByStatus
                      .firstWhereOrNull(
                        (element) => element.status == 'CONFIRMED',
                      )
                      ?.quantity
                      .toDouble() ??
                  0,
              title:
                  controller.dashboardData.value?.ordersByStatus
                      .firstWhereOrNull(
                        (element) => element.status == 'CONFIRMED',
                      )
                      ?.quantity
                      .toDouble()
                      .toString() ??
                  '0',
              radius: 100,
              titleStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            // Initialized
            PieChartSectionData(
              color: Colors.grey.shade400,
              value:
                  controller.dashboardData.value?.ordersByStatus
                      .firstWhereOrNull(
                        (element) => element.status == 'INITIALIZED',
                      )
                      ?.quantity
                      .toDouble() ??
                  0,
              title:
                  controller.dashboardData.value?.ordersByStatus
                      .firstWhereOrNull(
                        (element) => element.status == 'INITIALIZED',
                      )
                      ?.quantity
                      .toDouble()
                      .toString() ??
                  '0',
              radius: 100,
              titleStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            // Requires Contact
            PieChartSectionData(
              color: Colors.orange.shade400,
              value:
                  controller.dashboardData.value?.ordersByStatus
                      .firstWhereOrNull(
                        (element) => element.status == 'REQUIRES_CONTACT',
                      )
                      ?.quantity
                      .toDouble() ??
                  0.0,
              title:
                  controller.dashboardData.value?.ordersByStatus
                      .firstWhereOrNull(
                        (element) => element.status == 'REQUIRES_CONTACT',
                      )
                      ?.quantity
                      .toDouble()
                      .toString() ??
                  '0.0',
              radius: 100,
              titleStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
          sectionsSpace: 2,
          centerSpaceRadius: 0,
        ),
      );
    });
  }

  Widget _buildOrderStatusLegend() {
    return Obx(() {
      if (controller.dashboardData.value?.ordersByStatus == null) {
        return const SizedBox.shrink();
      }

      final ordersByStatus = controller.dashboardData.value!.ordersByStatus;

      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                _buildLegendItem(
                  'Completadas',
                  Colors.green.shade400,
                  ordersByStatus
                          .firstWhereOrNull(
                            (element) => element.status == 'COMPLETED',
                          )
                          ?.quantity ??
                      0,
                ),
                _buildLegendItem(
                  'Pendientes de Revisión',
                  Colors.grey.shade400,
                  ordersByStatus
                          .firstWhereOrNull(
                            (element) => element.status == 'PENDING_REVISION',
                          )
                          ?.quantity ??
                      0,
                ),
                _buildLegendItem(
                  'Rechazadas',
                  Colors.red.shade400,
                  ordersByStatus
                          .firstWhereOrNull(
                            (element) => element.status == 'REJECTED',
                          )
                          ?.quantity ??
                      0,
                ),
                _buildLegendItem(
                  'Confirmadas',
                  Colors.blue.shade400,
                  ordersByStatus
                          .firstWhereOrNull(
                            (element) => element.status == 'CONFIRMED',
                          )
                          ?.quantity ??
                      0,
                ),
                _buildLegendItem(
                  'Inicializadas',
                  Colors.grey.shade400,
                  ordersByStatus
                          .firstWhereOrNull(
                            (element) => element.status == 'INITIALIZED',
                          )
                          ?.quantity ??
                      0,
                ),
                _buildLegendItem(
                  'Requieren Contacto',
                  Colors.orange.shade400,
                  ordersByStatus
                          .firstWhereOrNull(
                            (element) => element.status == 'REQUIRES_CONTACT',
                          )
                          ?.quantity ??
                      0,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildLegendItem(String label, Color color, int quantity) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            '$label: $quantity',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.shade50,
                    Colors.indigo.shade50,
                    Colors.purple.shade50,
                  ],
                ),
              ),
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 180,
                    floating: false,
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    flexibleSpace: FlexibleSpaceBar(
                      title: SvgPicture.asset(
                        "assets/logotipo_recortado.png",
                        height: 100,
                      ),
                    ),
                    centerTitle: true,
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Obx(() {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header informativo
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.info_outline,
                                      color: Colors.blue.shade600,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Resumen del Día',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue.shade700,
                                          ),
                                        ),
                                        Text(
                                          'Los datos que se muestran a continuación son del día actual',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Top Stats Row
                            Obx(() {
                              if (controller.isLoading.value) {
                                return const SizedBox(
                                  height: 100,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              return Row(
                                children: [
                                  _buildModernStatCard(
                                    'Total de Órdenes',
                                    controller.dashboardData.value?.totalOrders
                                            .toString() ??
                                        '0',
                                    Icons.receipt_long,
                                    Colors.blue.shade400,
                                  ),

                                  const SizedBox(width: 16),
                                  _buildModernStatCard(
                                    'Pendientes',
                                    controller
                                            .dashboardData
                                            .value
                                            ?.pendingOrders
                                            .toString() ??
                                        '0',
                                    Icons.pending,
                                    Colors.orange.shade400,
                                  ),
                                  const SizedBox(width: 16),
                                  _buildModernStatCard(
                                    'Completadas',
                                    controller
                                            .dashboardData
                                            .value
                                            ?.completedOrders
                                            .toString() ??
                                        '0',
                                    Icons.check_circle,
                                    Colors.green.shade400,
                                  ),
                                  const SizedBox(width: 16),
                                  _buildModernStatCard(
                                    'Volumen Total (USD)',
                                    controller.formatedNumberWithCommas(
                                      number:
                                          controller
                                              .dashboardData
                                              .value
                                              ?.totalVolume
                                              .toString() ??
                                          '0',
                                    ),
                                    Icons.attach_money,
                                    Colors.green.shade400,
                                  ),
                                ],
                              );
                            }),
                            const SizedBox(height: 32),

                            // Recent Orders and Chart
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Recent Orders
                                Expanded(
                                  flex: 3,
                                  child: _ModernOrdersCard(
                                    title: 'Órdenes Recientes',
                                    subtitle: 'Últimas transacciones del día',
                                    child: SizedBox(
                                      height: 400,
                                      child:
                                          controller
                                                      .dashboardData
                                                      .value
                                                      ?.recentOrders
                                                      .isNotEmpty ??
                                                  false
                                              ? ListView.builder(
                                                itemCount:
                                                    controller
                                                        .dashboardData
                                                        .value
                                                        ?.recentOrders
                                                        .length ??
                                                    0,
                                                itemBuilder: (context, index) {
                                                  final RecentOrder? order =
                                                      controller
                                                          .dashboardData
                                                          .value
                                                          ?.recentOrders[index];
                                                  return order != null
                                                      ? _buildModernOrderTile(
                                                        order,
                                                        index,
                                                      )
                                                      : const SizedBox.shrink();
                                                },
                                              )
                                              : const SizedBox(
                                                height: 400,
                                                child: Center(
                                                  child: Text(
                                                    'No hay datos para mostrar en el día de hoy',
                                                  ),
                                                ),
                                              ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 24),

                                // Chart
                                Expanded(
                                  flex: 2,
                                  child: _ModernChartCard(
                                    title: 'Órdenes por Estado',
                                    subtitle: 'Distribución porcentual',
                                    child: SizedBox(
                                      height: 600,
                                      child:
                                          (controller
                                                      .dashboardData
                                                      .value
                                                      ?.ordersByStatus
                                                      .any(
                                                        (status) =>
                                                            status.quantity > 0,
                                                      ) ??
                                                  false)
                                              ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: _buildPieChart(),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  _buildOrderStatusLegend(),
                                                ],
                                              )
                                              : const SizedBox(
                                                height: 400,
                                                child: Center(
                                                  child: Text(
                                                    'No hay datos para mostrar en el día de hoy',
                                                  ),
                                                ),
                                              ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernOrderTile(RecentOrder order, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: controller
                  .getStatusColor(order.status)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: controller
                    .getStatusColor(order.status)
                    .withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: controller.getStatusColor(order.status),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${order.fromCurrency} ${order.fromAmount} → ${order.toCurrency} ${order.toAmount}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  (order.toCurrency == 'USD' ? "Venta" : "Compra") +
                      (order.appliedSpread ? " con afinidad" : ""),
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                order.date,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: controller
                      .getStatusColor(order.status)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: controller
                        .getStatusColor(order.status)
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  order.statusLabel,
                  style: TextStyle(
                    color: controller.getStatusColor(order.status),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// COMPONENTES MODERNOS

class _ModernOrdersCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _ModernOrdersCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.grey.shade50],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.list_alt,
                        color: Colors.indigo.shade600,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo.shade800,
                            ),
                          ),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModernChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _ModernChartCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.grey.shade50],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.pie_chart,
                        color: Colors.purple.shade600,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple.shade800,
                            ),
                          ),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
