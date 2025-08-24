import 'dart:ui';

import 'package:odewa_bo/pages/overview/models/dashboard_model.dart';
import 'package:odewa_bo/pages/overview/overview_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OverviewController extends GetxController {
  final overviewService = Get.find<OverviewService>();

  Rx<DashboardData?> dashboardData = Rx<DashboardData?>(null);
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    getDashboardData();
    super.onInit();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'INITIALIZED':
        return Colors.grey;
      case 'PENDING_REVISION':
        return Colors.red;
      case 'CONFIRMED':
        return Colors.lightBlue;
      case 'REJECTED':
        return Colors.red;
      case 'REQUIRES_CONTACT':
        return Colors.orange;
      case 'COMPLETED':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Future<void> getDashboardData() async {
    try {
      isLoading.value = true;
      dashboardData.value = await overviewService.getDashboardData();
    } catch (e) {
      print('Error loading dashboard data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String formatedNumberWithCommas({required String number}) {
    return NumberFormat('###,##0.##', 'es_ES').format(double.parse(number));
  }
}
