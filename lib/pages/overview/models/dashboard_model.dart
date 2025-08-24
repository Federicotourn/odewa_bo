// To parse this JSON data, do
//
//     final dashboardData = dashboardDataFromJson(jsonString);

import 'dart:convert';

DashboardData dashboardDataFromJson(String str) =>
    DashboardData.fromJson(json.decode(str));

String dashboardDataToJson(DashboardData data) => json.encode(data.toJson());

class DashboardData {
  int totalOrders;
  double totalVolume;
  int pendingOrders;
  int completedOrders;
  List<RecentOrder> recentOrders;
  List<OrdersByStatus> ordersByStatus;

  DashboardData({
    required this.totalOrders,
    required this.totalVolume,
    required this.pendingOrders,
    required this.completedOrders,
    required this.recentOrders,
    required this.ordersByStatus,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) => DashboardData(
    totalOrders: json["totalOrders"],
    totalVolume: json["totalVolume"].toDouble(),
    pendingOrders: json["pendingOrders"],
    completedOrders: json["completedOrders"],
    recentOrders: List<RecentOrder>.from(
      json["recentOrders"].map((x) => RecentOrder.fromJson(x)),
    ),
    ordersByStatus: List<OrdersByStatus>.from(
      json["ordersByStatus"].map((x) => OrdersByStatus.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "totalOrders": totalOrders,
    "totalVolume": totalVolume,
    "pendingOrders": pendingOrders,
    "completedOrders": completedOrders,
    "recentOrders": List<dynamic>.from(recentOrders.map((x) => x.toJson())),
    "ordersByStatus": List<dynamic>.from(ordersByStatus.map((x) => x.toJson())),
  };
}

class OrdersByStatus {
  String status;
  String statusLabel;
  double percentage;
  int quantity;

  OrdersByStatus({
    required this.status,
    required this.statusLabel,
    required this.percentage,
    required this.quantity,
  });

  factory OrdersByStatus.fromJson(Map<String, dynamic> json) => OrdersByStatus(
    status: json["status"],
    statusLabel: json["statusLabel"],
    percentage: json["percentage"].toDouble(),
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusLabel": statusLabel,
    "percentage": percentage,
    "quantity": quantity,
  };
}

class RecentOrder {
  int id;
  String fromCurrency;
  String toCurrency;
  String fromAmount;
  String toAmount;
  String date;
  String description;
  String status;
  String statusLabel;
  bool appliedSpread;

  RecentOrder({
    required this.id,
    required this.fromCurrency,
    required this.toCurrency,
    required this.fromAmount,
    required this.toAmount,
    required this.date,
    required this.description,
    required this.status,
    required this.statusLabel,
    required this.appliedSpread,
  });

  factory RecentOrder.fromJson(Map<String, dynamic> json) => RecentOrder(
    id: json["id"],
    fromCurrency: json["fromCurrency"],
    toCurrency: json["toCurrency"],
    fromAmount: json["fromAmount"],
    toAmount: json["toAmount"],
    date: json["date"],
    description: json["description"],
    status: json["status"],
    statusLabel: json["statusLabel"],
    appliedSpread: json["appliedSpread"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fromCurrency": fromCurrency,
    "toCurrency": toCurrency,
    "fromAmount": fromAmount,
    "toAmount": toAmount,
    "date": date,
    "description": description,
    "status": status,
    "statusLabel": statusLabel,
    "appliedSpread": appliedSpread,
  };
}
