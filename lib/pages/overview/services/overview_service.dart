import 'package:flutter/material.dart';
import 'package:odewa_bo/constants/constants.dart';
import 'package:odewa_bo/constants/urls.dart';
import 'package:odewa_bo/pages/overview/models/dashboard_model.dart';
import 'package:odewa_bo/pages/overview/models/kpis_model.dart';
import 'package:odewa_bo/pages/overview/models/request_summary_model.dart';
import 'package:odewa_bo/services/token_validation_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';

class OverviewService extends GetxService {
  final TokenValidationService _tokenValidationService =
      Get.find<TokenValidationService>();

  final box = GetStorage('User');

  Future<OverviewService> init() async {
    return this;
  }

  Future<KpisData> getKpisData({
    DateTime? startDate,
    DateTime? endDate,
    List<String>? companyIds,
  }) async {
    try {
      // Construir la URL con parámetros de filtro
      final Uri url = Uri.parse(
        '${Urls.baseUrl}/requests/kpis/monthly',
      ).replace(
        queryParameters: _buildQueryParameters(
          startDate: startDate,
          endDate: endDate,
          companyIds: companyIds,
        ),
      );

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

  Map<String, String> _buildQueryParameters({
    DateTime? startDate,
    DateTime? endDate,
    List<String>? companyIds,
  }) {
    final Map<String, String> params = {};

    if (startDate != null) {
      params['start_date'] = startDate.toIso8601String().split('T')[0];
    }

    if (endDate != null) {
      params['end_date'] = endDate.toIso8601String().split('T')[0];
    }

    if (companyIds != null && companyIds.isNotEmpty) {
      params['company_ids'] = companyIds.join(',');
    }

    return params;
  }

  Future<RequestSummary?> getRequestSummary(String clientDocument) async {
    try {
      final Uri url = Uri.parse(
        Urls.backofficeClientRequestSummary(clientDocument),
      );

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
        final jsonData = json.decode(response.body);
        return RequestSummary.fromJson(jsonData);
      } else {
        debugPrint('Error response: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Exception occurred: $e');
      return null;
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
    clientKPIs: ClientKPIs(
      employeesCount: EmployeesCount(active: 0, total: 0, percentage: 0),
      averageMonthlyBalance: 0,
      activeUsersThisMonth: 0,
      averageRequestAmount: 0,
      requestedVsPossibleActive: RequestedVsPossible(
        requested: 0,
        possible: 0,
        percentage: 0,
      ),
      requestedVsPossibleAll: RequestedVsPossible(
        requested: 0,
        possible: 0,
        percentage: 0,
      ),
    ),
  );
}
