import 'package:odewa_bo/constants/constants.dart';
import 'package:odewa_bo/constants/urls.dart';
import 'package:odewa_bo/pages/overview/models/dashboard_model.dart';
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

  Future<DashboardData> getDashboardData() async {
    try {
      final Uri url = Uri.parse('${Urls.baseUrl}/dashboard/orders');
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
        'Authorization': 'Bearer ${box.read('token')}',
      };
      var response = await _tokenValidationService.client.get(
        url,
        headers: headers,
      );

      if (response.statusCode == Constants.HTTP_200_OK) {
        DashboardData dashboardData = dashboardDataFromJson(response.body);
        return dashboardData;
      } else {
        print('Error response: ${response.statusCode} - ${response.body}');
        return dashboardDataExample;
      }
    } catch (e) {
      print('Exception occurred: $e');
      return dashboardDataExample;
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
}
