import 'package:flutter/material.dart';
import 'package:odewa_bo/pages/overview/models/dashboard_model.dart';
import 'package:odewa_bo/pages/overview/models/kpis_model.dart';
import 'package:odewa_bo/pages/overview/services/overview_service.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class OverviewController extends GetxController {
  final overviewService = Get.find<OverviewService>();

  Rx<DashboardData?> dashboardData = Rx<DashboardData?>(null);
  Rx<KpisData?> kpisData = Rx<KpisData?>(null);
  RxBool isLoading = false.obs;

  // Filtros
  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);
  RxList<String> selectedCompanyIds = <String>[].obs;

  @override
  void onInit() {
    getKpisData();
    super.onInit();
  }

  Future<void> getKpisData() async {
    try {
      isLoading.value = true;
      kpisData.value = await overviewService.getKpisData(
        startDate: startDate.value,
        endDate: endDate.value,
        companyIds: selectedCompanyIds,
      );
    } catch (e) {
      debugPrint('Error loading KPIs data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateFilters({
    DateTime? newStartDate,
    DateTime? newEndDate,
    List<String>? newCompanyIds,
  }) {
    // Siempre actualizar startDate (puede ser null para limpiar)
    startDate.value = newStartDate;
    // Siempre actualizar endDate (puede ser null para limpiar)
    endDate.value = newEndDate;
    // Actualizar companyIds si se proporciona
    if (newCompanyIds != null) {
      selectedCompanyIds.value = newCompanyIds;
    }

    // Recargar datos con los nuevos filtros
    getKpisData();
  }

  void clearFilters() {
    startDate.value = null;
    endDate.value = null;
    selectedCompanyIds.clear();
    getKpisData();
  }

  bool get hasActiveFilters {
    return (startDate.value != null && endDate.value != null) ||
        selectedCompanyIds.isNotEmpty;
  }

  String get activeFiltersDescription {
    List<String> descriptions = [];

    if (startDate.value != null && endDate.value != null) {
      descriptions.add(
        '${DateFormat('dd/MM/yyyy').format(startDate.value!)} - ${DateFormat('dd/MM/yyyy').format(endDate.value!)}',
      );
    }

    if (selectedCompanyIds.isNotEmpty) {
      descriptions.add('${selectedCompanyIds.length} empresa(s)');
    }

    return descriptions.isEmpty ? 'Sin filtros' : descriptions.join(' • ');
  }

  String formatedNumberWithCommas({required String number}) {
    return NumberFormat('###,##0.##', 'es_ES').format(double.parse(number));
  }

  String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'es_ES', symbol: '\$').format(amount);
  }

  String formatCurrencyWithoutDecimals(double amount) {
    // Formatear con comas pero sin decimales
    return '\$${NumberFormat('#,##0', 'es_ES').format(amount.toInt())}';
  }

  String formatNumber(int number) {
    return NumberFormat('###,##0', 'es_ES').format(number);
  }
}
