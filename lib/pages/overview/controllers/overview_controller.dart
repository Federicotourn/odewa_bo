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

  @override
  void onInit() {
    getKpisData();
    super.onInit();
  }

  Future<void> getKpisData() async {
    try {
      isLoading.value = true;
      kpisData.value = await overviewService.getKpisData();
    } catch (e) {
      debugPrint('Error loading KPIs data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String formatedNumberWithCommas({required String number}) {
    return NumberFormat('###,##0.##', 'es_ES').format(double.parse(number));
  }

  String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'es_ES', symbol: '\$').format(amount);
  }

  String formatNumber(int number) {
    return NumberFormat('###,##0', 'es_ES').format(number);
  }
}
