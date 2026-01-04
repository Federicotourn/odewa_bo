// To parse this JSON data, do
//
//     final kpisData = kpisDataFromJson(jsonString);

import 'dart:convert';
import 'package:flutter/material.dart';

KpisData kpisDataFromJson(String str) => KpisData.fromJson(json.decode(str));

String kpisDataToJson(KpisData data) => json.encode(data.toJson());

class KpisData {
  int totalRequests;
  int pendingRequests;
  int completedRequests;
  double totalVolume;
  List<LatestRequest> latestRequests;
  RequestsByStatus requestsByStatus;
  ClientKPIs clientKPIs;

  KpisData({
    required this.totalRequests,
    required this.pendingRequests,
    required this.completedRequests,
    required this.totalVolume,
    required this.latestRequests,
    required this.requestsByStatus,
    required this.clientKPIs,
  });

  factory KpisData.fromJson(Map<String, dynamic> json) => KpisData(
    totalRequests: json["totalRequests"],
    pendingRequests: json["pendingRequests"],
    completedRequests: json["completedRequests"],
    totalVolume: json["totalVolume"].toDouble(),
    latestRequests: List<LatestRequest>.from(
      json["latestRequests"].map((x) => LatestRequest.fromJson(x)),
    ),
    requestsByStatus: RequestsByStatus.fromJson(json["requestsByStatus"]),
    clientKPIs: ClientKPIs.fromJson(json["clientKPIs"]),
  );

  Map<String, dynamic> toJson() => {
    "totalRequests": totalRequests,
    "pendingRequests": pendingRequests,
    "completedRequests": completedRequests,
    "totalVolume": totalVolume,
    "latestRequests": List<dynamic>.from(latestRequests.map((x) => x.toJson())),
    "requestsByStatus": requestsByStatus.toJson(),
    "clientKPIs": clientKPIs.toJson(),
  };
}

class EmployeesCount {
  int active;
  int total;
  double percentage;

  EmployeesCount({
    required this.active,
    required this.total,
    required this.percentage,
  });

  factory EmployeesCount.fromJson(Map<String, dynamic> json) => EmployeesCount(
    active: json["active"],
    total: json["total"],
    percentage: (json["percentage"] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "active": active,
    "total": total,
    "percentage": percentage,
  };
}

class RequestedVsPossible {
  double requested;
  double possible;
  double percentage;

  RequestedVsPossible({
    required this.requested,
    required this.possible,
    required this.percentage,
  });

  factory RequestedVsPossible.fromJson(Map<String, dynamic> json) =>
      RequestedVsPossible(
        requested: (json["requested"] as num).toDouble(),
        possible: (json["possible"] as num).toDouble(),
        percentage: (json["percentage"] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
    "requested": requested,
    "possible": possible,
    "percentage": percentage,
  };
}

class ClientKPIs {
  EmployeesCount employeesCount;
  double averageMonthlyBalance;
  int activeUsersThisMonth;
  double averageRequestAmount;
  RequestedVsPossible requestedVsPossibleActive;
  RequestedVsPossible requestedVsPossibleAll;

  ClientKPIs({
    required this.employeesCount,
    required this.averageMonthlyBalance,
    required this.activeUsersThisMonth,
    required this.averageRequestAmount,
    required this.requestedVsPossibleActive,
    required this.requestedVsPossibleAll,
  });

  factory ClientKPIs.fromJson(Map<String, dynamic> json) => ClientKPIs(
    employeesCount: EmployeesCount.fromJson(json["employeesCount"]),
    averageMonthlyBalance: (json["averageMonthlyBalance"] as num).toDouble(),
    activeUsersThisMonth: json["activeUsersThisMonth"],
    averageRequestAmount: (json["averageRequestAmount"] as num).toDouble(),
    requestedVsPossibleActive: RequestedVsPossible.fromJson(
      json["requestedVsPossibleActive"],
    ),
    requestedVsPossibleAll: RequestedVsPossible.fromJson(
      json["requestedVsPossibleAll"],
    ),
  );

  Map<String, dynamic> toJson() => {
    "employeesCount": employeesCount.toJson(),
    "averageMonthlyBalance": averageMonthlyBalance,
    "activeUsersThisMonth": activeUsersThisMonth,
    "averageRequestAmount": averageRequestAmount,
    "requestedVsPossibleActive": requestedVsPossibleActive.toJson(),
    "requestedVsPossibleAll": requestedVsPossibleAll.toJson(),
  };
}

class LatestRequest {
  String id;
  String amount;
  String status;
  String date;
  String clientName;
  String clientDocument;

  LatestRequest({
    required this.id,
    required this.amount,
    required this.status,
    required this.date,
    required this.clientName,
    required this.clientDocument,
  });

  factory LatestRequest.fromJson(Map<String, dynamic> json) => LatestRequest(
    id: json["id"],
    amount: json["amount"],
    status: json["status"],
    date: json["date"],
    clientName: json["clientName"],
    clientDocument: json["clientDocument"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "amount": amount,
    "status": status,
    "date": date,
    "clientName": clientName,
    "clientDocument": clientDocument,
  };
}

class RequestsByStatus {
  int pending;
  int approved;
  int rejected;
  int completed;
  int cancelled;

  RequestsByStatus({
    required this.pending,
    required this.approved,
    required this.rejected,
    required this.completed,
    required this.cancelled,
  });

  factory RequestsByStatus.fromJson(Map<String, dynamic> json) =>
      RequestsByStatus(
        pending: json["pending"],
        approved: json["approved"],
        rejected: json["rejected"],
        completed: json["completed"],
        cancelled: json["cancelled"],
      );

  Map<String, dynamic> toJson() => {
    "pending": pending,
    "approved": approved,
    "rejected": rejected,
    "completed": completed,
    "cancelled": cancelled,
  };

  // Helper methods for easier access
  List<StatusData> get statusList => [
    StatusData(
      status: 'pending',
      label: 'Pendientes',
      count: pending,
      color: const Color(0xFFFF9800), // Orange
    ),
    StatusData(
      status: 'approved',
      label: 'Aprobadas',
      count: approved,
      color: const Color(0xFF4CAF50), // Green
    ),
    StatusData(
      status: 'rejected',
      label: 'Rechazadas',
      count: rejected,
      color: const Color(0xFFF44336), // Red
    ),
    StatusData(
      status: 'completed',
      label: 'Completadas',
      count: completed,
      color: const Color(0xFF2196F3), // Blue
    ),
    StatusData(
      status: 'cancelled',
      label: 'Canceladas',
      count: cancelled,
      color: const Color.fromARGB(255, 242, 97, 86), // Red
    ),
  ];

  int get total => pending + approved + rejected + completed + cancelled;
}

class StatusData {
  final String status;
  final String label;
  final int count;
  final Color color;

  StatusData({
    required this.status,
    required this.label,
    required this.count,
    required this.color,
  });

  double getPercentage(int total) => total > 0 ? (count / total) * 100 : 0;
}
