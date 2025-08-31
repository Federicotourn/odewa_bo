import 'package:flutter/material.dart';
import 'package:odewa_bo/constants/constants.dart';
import 'package:odewa_bo/constants/urls.dart';
import 'package:odewa_bo/pages/overview/models/dashboard_model.dart';
import 'package:odewa_bo/pages/overview/models/kpis_model.dart';
import 'package:odewa_bo/services/token_validation_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OverviewService extends GetxService {
  final TokenValidationService _tokenValidationService =
      Get.find<TokenValidationService>();

  final box = GetStorage('User');

  Future<OverviewService> init() async {
    return this;
  }

  Future<KpisData> getKpisData() async {
    try {
      final Uri url = Uri.parse('${Urls.baseUrl}/requests/kpis/monthly');
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      };
      var response = await _tokenValidationService.client.get(
        url,
        headers: headers,
      );

      if (response.statusCode == Constants.HTTP_200_OK) {
        KpisData kpisData = kpisDataFromJson(response.body);
        return kpisData;
      } else {
        debugPrint('Error response: ${response.statusCode} - ${response.body}');
        return kpisDataExample;
      }
    } catch (e) {
      debugPrint('Exception occurred: $e');
      return kpisDataExample;
    }
  }

  DashboardData dashboardDataExample = DashboardData(
    totalOrders: 0,
    totalVolume: 0,
    pendingOrders: 0,
    completedOrders: 0,
    recentOrders: [],
    ordersByStatus: [],
  );

  KpisData kpisDataExample = KpisData(
    totalRequests: 0,
    pendingRequests: 0,
    completedRequests: 0,
    totalVolume: 0,
    latestRequests: [],
    requestsByStatus: RequestsByStatus(
      pending: 0,
      approved: 0,
      rejected: 0,
      completed: 0,
      cancelled: 0,
    ),
  );
}
