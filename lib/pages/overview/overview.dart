import 'package:odewa_bo/pages/overview/controllers/overview_controller.dart';
import 'package:odewa_bo/pages/overview/models/kpis_model.dart';
import 'package:odewa_bo/pages/overview/services/overview_service.dart';
import 'package:odewa_bo/widgets/dashboard_filters.dart';
import 'package:odewa_bo/controllers/logged_user_controller.dart';
import 'package:odewa_bo/helpers/responsiveness.dart';
import 'package:odewa_bo/helpers/scaffold_helper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OverviewPageNew extends StatelessWidget {
  final OverviewController controller = Get.put(OverviewController());

  OverviewPageNew({super.key});

  @override
  Widget build(BuildContext context) {
    late final LoggedUserController loggedUserController;
    try {
      loggedUserController = Get.find<LoggedUserController>();
    } catch (e) {
      loggedUserController = Get.put(LoggedUserController());
    }
    final isClient = loggedUserController.isClient;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.teal.shade50,
              Colors.blue.shade50,
              Colors.indigo.shade50,
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // AppBar moderno
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              leading:
                  ResponsiveWidget.isSmallScreen(context)
                      ? IconButton(
                        icon: const Icon(Icons.menu),
                        color: Colors.teal.shade800,
                        onPressed: () {
                          ScaffoldHelper.openParentDrawer(context);
                        },
                      )
                      : null,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Dashboard - Resumen Mensual',
                  style: TextStyle(
                    color: Colors.teal.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveWidget.isSmallScreen(context) ? 18 : 24,
                  ),
                  textAlign: TextAlign.center,
                ),
                centerTitle: true,
              ),
              actions: [
                ResponsiveWidget.isSmallScreen(context)
                    ? IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () => controller.getKpisData(),
                      tooltip: 'Actualizar',
                    )
                    : _ModernActionButton(
                      icon: Icons.refresh,
                      label: 'Actualizar',
                      color: Colors.teal.shade400,
                      onPressed: () {
                        controller.getKpisData();
                      },
                    ),
                if (!ResponsiveWidget.isSmallScreen(context))
                  const SizedBox(width: 16),
              ],
            ),

            // Contenido del dashboard
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(
                  ResponsiveWidget.isSmallScreen(context) ? 12 : 24,
                ),
                child: Obx(() {
                  return Column(
                    children: [
                      // Widget de filtros
                      DashboardFilters(
                        startDate: controller.startDate.value,
                        endDate: controller.endDate.value,
                        selectedCompanyIds: controller.selectedCompanyIds,
                        onFiltersChanged: (startDate, endDate, companyIds) {
                          controller.updateFilters(
                            newStartDate: startDate,
                            newEndDate: endDate,
                            newCompanyIds: companyIds,
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // Indicador de filtros activos
                      if (controller.hasActiveFilters)
                        _buildActiveFiltersIndicator(),

                      const SizedBox(height: 24),

                      // Contenido principal del dashboard
                      if (controller.isLoading.value)
                        _buildLoadingState()
                      else if (controller.kpisData.value == null)
                        _buildErrorState()
                      else
                        _buildDashboardContent(
                          controller.kpisData.value!,
                          isClient,
                        ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFiltersIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.filter_alt, color: Colors.teal.shade600, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Filtros activos: ${controller.activeFiltersDescription}',
              style: TextStyle(
                color: Colors.teal.shade800,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          TextButton(
            onPressed: () => controller.clearFilters(),
            child: Text(
              'Limpiar',
              style: TextStyle(
                color: Colors.teal.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(KpisData data, bool isClient) {
    return Column(
      children: [
        // KPI Cards
        _buildKpiCards(data, isClient),

        // Statistics Module (solo para admins)
        if (!isClient) ...[
          const SizedBox(height: 32),
          _buildStatisticsModule(data),
        ],

        // Charts Section
        if (!isClient) ...[
          SizedBox(
            height: ResponsiveWidget.isSmallScreen(Get.context!) ? 24 : 32,
          ),
          ResponsiveWidget.isSmallScreen(Get.context!)
              ? Column(
                children: [
                  _buildStatusChart(data),
                  const SizedBox(height: 24),
                  _buildLatestRequests(data),
                ],
              )
              : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pie Chart
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        _buildStatusChart(data),
                        const SizedBox(height: 24),
                        Container(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Latest Requests
                  Expanded(flex: 2, child: _buildLatestRequests(data)),
                ],
              ),
        ] else ...[
          // Para clientes, solo mostrar últimas solicitudes
          SizedBox(
            height: ResponsiveWidget.isSmallScreen(Get.context!) ? 24 : 32,
          ),
          _buildLatestRequests(data),
        ],
      ],
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Cargando datos del dashboard...'),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Error al cargar los datos',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => controller.getKpisData(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCards(KpisData data, bool isClient) {
    final isSmallScreen = ResponsiveWidget.isSmallScreen(Get.context!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Métricas Principales',
          style: TextStyle(
            fontSize: isSmallScreen ? 18 : 20,
            fontWeight: FontWeight.bold,
            color: Colors.teal.shade800,
          ),
        ),
        SizedBox(height: isSmallScreen ? 8 : 16),
        isSmallScreen
            ? Column(
              children: [
                // Primera fila: Total Solicitudes y Volumen Total
                Row(
                  children: [
                    Expanded(
                      child: _KpiCard(
                        title: 'Total Solicitudes',
                        value: controller.formatNumber(data.totalRequests),
                        icon: Icons.receipt_long,
                        color: Colors.blue.shade400,
                        subtitle: 'Este mes',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _KpiCard(
                        title: 'Volumen Total',
                        value: controller.formatCurrencyWithoutDecimals(
                          data.totalVolume,
                        ),
                        icon: Icons.attach_money,
                        color: Colors.green.shade400,
                        subtitle: 'Monto procesado',
                      ),
                    ),
                  ],
                ),
                if (!isClient) ...[
                  const SizedBox(height: 8),
                  // Segunda fila: Pendientes y Completadas
                  Row(
                    children: [
                      Expanded(
                        child: _KpiCard(
                          title: 'Pendientes',
                          value: controller.formatNumber(data.pendingRequests),
                          icon: Icons.pending_actions,
                          color: Colors.orange.shade400,
                          subtitle: 'Por revisar',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _KpiCard(
                          title: 'Completadas',
                          value: controller.formatNumber(
                            data.completedRequests,
                          ),
                          icon: Icons.check_circle,
                          color: Colors.teal.shade400,
                          subtitle: 'Finalizadas',
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            )
            : Row(
              children: [
                Expanded(
                  child: _KpiCard(
                    title: 'Total Solicitudes',
                    value: controller.formatNumber(data.totalRequests),
                    icon: Icons.receipt_long,
                    color: Colors.blue.shade400,
                    subtitle: 'Este mes',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _KpiCard(
                    title: 'Volumen Total',
                    value: controller.formatCurrencyWithoutDecimals(
                      data.totalVolume,
                    ),
                    icon: Icons.attach_money,
                    color: Colors.green.shade400,
                    subtitle: 'Monto procesado',
                  ),
                ),
                if (!isClient) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: _KpiCard(
                      title: 'Pendientes',
                      value: controller.formatNumber(data.pendingRequests),
                      icon: Icons.pending_actions,
                      color: Colors.orange.shade400,
                      subtitle: 'Por revisar',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _KpiCard(
                      title: 'Completadas',
                      value: controller.formatNumber(data.completedRequests),
                      icon: Icons.check_circle,
                      color: Colors.teal.shade400,
                      subtitle: 'Finalizadas',
                    ),
                  ),
                ],
              ],
            ),
      ],
    );
  }

  Widget _buildStatisticsModule(KpisData data) {
    final isSmallScreen = ResponsiveWidget.isSmallScreen(Get.context!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estadísticas de Usuarios',
          style: TextStyle(
            fontSize: isSmallScreen ? 18 : 20,
            fontWeight: FontWeight.bold,
            color: Colors.purple.shade800,
          ),
        ),
        SizedBox(height: isSmallScreen ? 8 : 16),
        isSmallScreen
            ? Column(
              children: [
                // Primera fila: Cantidad de empleados y Sueldo Promedio
                Row(
                  children: [
                    Expanded(
                      child: _StatisticsCard(
                        title: 'Cantidad de empleados',
                        value: controller.formatNumber(
                          data.clientKPIs.totalClients,
                        ),
                        icon: Icons.people,
                        color: Colors.purple.shade400,
                        subtitle: 'Total registrados',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatisticsCard(
                        title: 'Sueldo Promedio',
                        value: controller.formatCurrency(
                          data.clientKPIs.averageMonthlyBalance,
                        ),
                        icon: Icons.account_balance_wallet,
                        color: Colors.indigo.shade400,
                        subtitle: 'Balance mensual',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Segunda fila: Descargas estimadas y Usuarios activos por mes
                Row(
                  children: [
                    Expanded(
                      child: _StatisticsCard(
                        title: 'Descargas estimadas',
                        value: controller.formatNumber(
                          data.clientKPIs.estimatedDownloads,
                        ),
                        icon: Icons.download,
                        color: Colors.cyan.shade400,
                        subtitle: 'Aplicaciones',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatisticsCard(
                        title: 'Usuarios activos por mes',
                        value: controller.formatNumber(
                          data.clientKPIs.estimatedActiveClients,
                        ),
                        icon: Icons.trending_up,
                        color: Colors.green.shade400,
                        subtitle: 'Activos mensualmente',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Tercera fila: Monto solicitado por persona y Liquidez necesaria
                Row(
                  children: [
                    Expanded(
                      child: _StatisticsCard(
                        title: 'Monto solicitado por persona',
                        value: controller.formatCurrency(
                          data.clientKPIs.averageRequestAmount,
                        ),
                        icon: Icons.person_pin,
                        color: Colors.orange.shade400,
                        subtitle: 'Promedio por usuario',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatisticsCard(
                        title: 'Liquidez necesaria',
                        value: controller.formatCurrency(
                          data.clientKPIs.amountToCover,
                        ),
                        icon: Icons.account_balance,
                        color: Colors.red.shade400,
                        subtitle: 'Fondos requeridos',
                      ),
                    ),
                  ],
                ),
              ],
            )
            : Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _StatisticsCard(
                        title: 'Cantidad de empleados',
                        value: controller.formatNumber(
                          data.clientKPIs.totalClients,
                        ),
                        icon: Icons.people,
                        color: Colors.purple.shade400,
                        subtitle: 'Total registrados',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _StatisticsCard(
                        title: 'Sueldo Promedio',
                        value: controller.formatCurrency(
                          data.clientKPIs.averageMonthlyBalance,
                        ),
                        icon: Icons.account_balance_wallet,
                        color: Colors.indigo.shade400,
                        subtitle: 'Balance mensual',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _StatisticsCard(
                        title: 'Descargas estimadas',
                        value: controller.formatNumber(
                          data.clientKPIs.estimatedDownloads,
                        ),
                        icon: Icons.download,
                        color: Colors.cyan.shade400,
                        subtitle: 'Aplicaciones',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _StatisticsCard(
                        title: 'Usuarios activos por mes',
                        value: controller.formatNumber(
                          data.clientKPIs.estimatedActiveClients,
                        ),
                        icon: Icons.trending_up,
                        color: Colors.green.shade400,
                        subtitle: 'Activos mensualmente',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _StatisticsCard(
                        title: 'Monto solicitado por persona',
                        value: controller.formatCurrency(
                          data.clientKPIs.averageRequestAmount,
                        ),
                        icon: Icons.person_pin,
                        color: Colors.orange.shade400,
                        subtitle: 'Promedio por usuario',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _StatisticsCard(
                        title: 'Liquidez necesaria',
                        value: controller.formatCurrency(
                          data.clientKPIs.amountToCover,
                        ),
                        icon: Icons.account_balance,
                        color: Colors.red.shade400,
                        subtitle: 'Fondos requeridos',
                      ),
                    ),
                  ],
                ),
              ],
            ),
      ],
    );
  }

  Widget _buildStatusChart(KpisData data) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.pie_chart, color: Colors.teal.shade600, size: 24),
              const SizedBox(width: 12),
              Text(
                'Estado de Solicitudes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 40,
                sections: _buildPieChartSections(data.requestsByStatus),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildChartLegend(data.requestsByStatus),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(RequestsByStatus status) {
    final statusList = status.statusList;
    final total = status.total;

    return statusList.where((item) => item.count > 0).map((item) {
      final percentage = item.getPercentage(total);
      return PieChartSectionData(
        color: item.color,
        value: item.count.toDouble(),
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildChartLegend(RequestsByStatus status) {
    final statusList =
        status.statusList.where((item) => item.count > 0).toList();

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children:
          statusList.map((item) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: item.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${item.label}: ${item.count}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
              ],
            );
          }).toList(),
    );
  }

  Widget _buildLatestRequests(KpisData data) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history, color: Colors.blue.shade600, size: 24),
              const SizedBox(width: 12),
              Text(
                'Últimas Solicitudes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (data.latestRequests.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'No hay solicitudes recientes',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
              ),
            )
          else
            ...data.latestRequests.map((request) => _buildRequestItem(request)),
        ],
      ),
    );
  }

  Widget _buildRequestItem(LatestRequest request) {
    final statusColor = _getStatusColor(request.status);
    final statusLabel = _getStatusLabel(request.status);

    return InkWell(
      onTap: () => _showRequestSummaryDialog(request),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getStatusIcon(request.status),
                color: statusColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        request.clientName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        controller.formatCurrency(double.parse(request.amount)),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          statusLabel,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatDate(request.date),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showRequestSummaryDialog(LatestRequest request) async {
    final overviewService = Get.find<OverviewService>();
    final isSmallScreen = ResponsiveWidget.isSmallScreen(Get.context!);

    // Mostrar loading
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final summary = await overviewService.getRequestSummary(
        request.clientDocument,
      );

      // Cerrar loading
      Get.back();

      if (summary == null) {
        Get.snackbar(
          'Error',
          'No se pudo obtener la información del resumen',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
        );
        return;
      }

      // Mostrar diálogo con la información
      showDialog(
        context: Get.context!,
        builder:
            (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Container(
                width: isSmallScreen ? Get.width * 0.9 : 500,
                padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.teal.shade50, Colors.blue.shade50],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.teal.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.teal.shade700,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Resumen de Solicitud',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 18 : 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal.shade800,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(Icons.close, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Información
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildSummaryRow(
                            'Cliente',
                            request.clientName,
                            Icons.person,
                            Colors.blue.shade600,
                          ),
                          const SizedBox(height: 16),
                          _buildSummaryRow(
                            'Monto Solicitado',
                            controller.formatCurrencyWithoutDecimals(
                              summary.amountRequested,
                            ),
                            Icons.attach_money,
                            Colors.green.shade600,
                          ),
                          const SizedBox(height: 16),
                          _buildSummaryRow(
                            'Máximo Posible',
                            controller.formatCurrencyWithoutDecimals(
                              summary.maxPossible,
                            ),
                            Icons.trending_up,
                            Colors.orange.shade600,
                          ),
                          const SizedBox(height: 16),
                          _buildSummaryRow(
                            'Porcentaje Utilizado',
                            '${summary.percentage.toStringAsFixed(1)}%',
                            Icons.percent,
                            summary.percentage > 80
                                ? Colors.red.shade600
                                : summary.percentage > 50
                                ? Colors.orange.shade600
                                : Colors.green.shade600,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Botón cerrar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cerrar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      );
    } catch (e) {
      // Cerrar loading si hay error
      Get.back();
      Get.snackbar(
        'Error',
        'Error al obtener el resumen: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    }
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final isSmallScreen = ResponsiveWidget.isSmallScreen(Get.context!);

    return isSmallScreen
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 28),
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        )
        : Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange.shade600;
      case 'approved':
        return Colors.green.shade600;
      case 'rejected':
        return Colors.red.shade600;
      case 'cancelled':
        return Colors.red.shade300;
      case 'completed':
        return Colors.blue.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Pendiente';
      case 'approved':
        return 'Aprobada';
      case 'rejected':
        return 'Rechazada';
      case 'cancelled':
        return 'Cancelada';
      case 'completed':
        return 'Completada';
      default:
        return status;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.pending;
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'cancelled':
        return Icons.cancel;
      case 'completed':
        return Icons.done_all;
      default:
        return Icons.help;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String subtitle;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = ResponsiveWidget.isSmallScreen(context);

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
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
                padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: isSmallScreen ? 20 : 24),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 10 : 16),
          Text(
            value,
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          SizedBox(height: isSmallScreen ? 2 : 4),
          Text(
            title,
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: isSmallScreen ? 1 : 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: isSmallScreen ? 10 : 12,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatisticsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String subtitle;

  const _StatisticsCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = ResponsiveWidget.isSmallScreen(context);

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
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
                padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: isSmallScreen ? 20 : 24),
              ),
              const Spacer(),
              Icon(
                Icons.analytics,
                color: color,
                size: isSmallScreen ? 14 : 16,
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 10 : 16),
          Text(
            value,
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          SizedBox(height: isSmallScreen ? 2 : 4),
          Text(
            title,
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: isSmallScreen ? 1 : 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: isSmallScreen ? 10 : 12,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModernActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ModernActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 20),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
