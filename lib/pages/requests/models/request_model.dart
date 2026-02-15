import 'dart:convert';
import 'package:flutter/material.dart';
import '../../companies/models/company_model.dart';

List<OdewaRequest> requestsFromJson(String str) => List<OdewaRequest>.from(
  json.decode(str)["data"].map((x) => OdewaRequest.fromJson(x)),
);

String requestsToJson(List<OdewaRequest> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

OdewaRequest requestFromJson(String str) =>
    OdewaRequest.fromJson(json.decode(str));
String requestToJson(OdewaRequest data) => json.encode(data.toJson());

class RequestResponse {
  List<OdewaRequest> data;
  Meta meta;

  RequestResponse({required this.data, required this.meta});

  factory RequestResponse.fromJson(Map<String, dynamic> json) =>
      RequestResponse(
        data: List<OdewaRequest>.from(
          json["data"].map((x) => OdewaRequest.fromJson(x)),
        ),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "meta": meta.toJson(),
  };
}

class Meta {
  String page;
  String limit;
  int total;
  int totalPages;

  Meta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    page: json["page"],
    limit: json["limit"],
    total: json["total"],
    totalPages: json["totalPages"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "limit": limit,
    "total": total,
    "totalPages": totalPages,
  };
}

class OdewaRequest {
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  dynamic createdById;
  dynamic updatedById;
  dynamic deletedById;
  bool isActive;
  String amount;
  String date;
  String status;
  String clientId;
  RequestClient? client;
  String? receiptUrl;
  String? invoiceUrl;

  OdewaRequest({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.createdById,
    required this.updatedById,
    required this.deletedById,
    required this.isActive,
    required this.amount,
    required this.date,
    required this.status,
    required this.clientId,
    this.client,
    this.receiptUrl,
    this.invoiceUrl,
  });

  factory OdewaRequest.fromJson(Map<String, dynamic> json) => OdewaRequest(
    id: json["id"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    deletedAt: json["deletedAt"],
    createdById: json["createdById"],
    updatedById: json["updatedById"],
    deletedById: json["deletedById"],
    isActive: json["isActive"],
    amount: json["amount"],
    date: json["date"],
    status: json["status"],
    clientId: json["clientId"],
    client:
        json["client"] != null &&
                json["client"] is Map &&
                (json["client"] as Map).isNotEmpty &&
                json["client"]["id"] != null
            ? RequestClient.fromJson(json["client"])
            : null,
    receiptUrl: json["receiptUrl"],
    invoiceUrl: json["invoiceUrl"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "deletedAt": deletedAt,
    "createdById": createdById,
    "updatedById": updatedById,
    "deletedById": deletedById,
    "isActive": isActive,
    "amount": amount,
    "date": date,
    "status": status,
    "clientId": clientId,
    if (client != null) "client": client!.toJson(),
    if (receiptUrl != null) "receiptUrl": receiptUrl,
    if (invoiceUrl != null) "invoiceUrl": invoiceUrl,
  };

  // Método copyWith para facilitar la actualización
  OdewaRequest copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic deletedAt,
    dynamic createdById,
    dynamic updatedById,
    dynamic deletedById,
    bool? isActive,
    String? amount,
    String? date,
    String? status,
    String? clientId,
    RequestClient? client,
    String? receiptUrl,
    String? invoiceUrl,
  }) {
    return OdewaRequest(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      createdById: createdById ?? this.createdById,
      updatedById: updatedById ?? this.updatedById,
      deletedById: deletedById ?? this.deletedById,
      isActive: isActive ?? this.isActive,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      status: status ?? this.status,
      clientId: clientId ?? this.clientId,
      client: client ?? this.client,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      invoiceUrl: invoiceUrl ?? this.invoiceUrl,
    );
  }

  // Getter para el monto como double
  double get amountAsDouble => double.tryParse(amount) ?? 0.0;
}

class RequestClient {
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  dynamic createdById;
  dynamic updatedById;
  dynamic deletedById;
  bool isActive;
  String firstName;
  String lastName;
  String email;
  String document;
  String? phone;
  String? address;
  String? city;
  String? bank;
  String? currency;
  String? accountNumber;
  String? branch;
  String? beneficiary;
  String? password;
  String? salt;
  String? employeeNumber;
  int? monthlyBalance;
  String? companyId;
  Company? company;

  RequestClient({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.createdById,
    required this.updatedById,
    required this.deletedById,
    required this.isActive,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.document,
    this.phone,
    this.address,
    this.city,
    this.bank,
    this.currency,
    this.accountNumber,
    this.branch,
    this.beneficiary,
    this.password,
    this.salt,
    this.employeeNumber,
    this.monthlyBalance,
    this.companyId,
    this.company,
  });

  String get fullName => '$firstName $lastName';

  factory RequestClient.fromJson(Map<String, dynamic> json) => RequestClient(
    id: json["id"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    deletedAt: json["deletedAt"],
    createdById: json["createdById"],
    updatedById: json["updatedById"],
    deletedById: json["deletedById"],
    isActive: json["isActive"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
    document: json["document"],
    phone: json["phone"],
    address: json["address"],
    city: json["city"],
    bank: json["bank"],
    currency: json["currency"],
    accountNumber: json["accountNumber"],
    branch: json["branch"],
    beneficiary: json["beneficiary"],
    password: json["password"],
    salt: json["salt"],
    employeeNumber: json["employeeNumber"],
    monthlyBalance: json["monthlyBalance"],
    companyId: json["companyId"],
    company: json["company"] != null ? Company.fromJson(json["company"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "deletedAt": deletedAt,
    "createdById": createdById,
    "updatedById": updatedById,
    "deletedById": deletedById,
    "isActive": isActive,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "document": document,
    "phone": phone,
    "address": address,
    "city": city,
    "bank": bank,
    "currency": currency,
    "accountNumber": accountNumber,
    "branch": branch,
    "beneficiary": beneficiary,
    "password": password,
    "salt": salt,
    "employeeNumber": employeeNumber,
    "monthlyBalance": monthlyBalance,
    "companyId": companyId,
    "company": company?.toJson(),
  };
}

class CreateRequestRequest {
  String amount;
  String date;
  String clientId;

  CreateRequestRequest({
    required this.amount,
    required this.date,
    required this.clientId,
  });

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "date": date,
    "clientId": clientId,
  };
}

class UpdateRequestRequest {
  String? amount;
  String? date;

  UpdateRequestRequest({this.amount, this.date});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (amount != null) data["amount"] = amount;
    if (date != null) data["date"] = date;
    return data;
  }
}

class UpdateRequestStatusRequest {
  String status;

  UpdateRequestStatusRequest({required this.status});

  Map<String, dynamic> toJson() => {"status": status};
}

// Request status constants
class RequestStatus {
  static const String pending = 'pending';
  static const String approved = 'approved';
  static const String completed = 'completed';
  static const String rejected = 'rejected';
  static const String cancelled = 'cancelled';

  static const List<String> allStatuses = [
    pending,
    approved,
    completed,
    rejected,
    cancelled,
  ];

  static const Map<String, String> statusLabels = {
    pending: 'Pendiente',
    approved: 'Aprobado',
    completed: 'Completado',
    rejected: 'Rechazado',
    cancelled: 'Cancelado',
  };

  static String getLabel(String status) {
    return statusLabels[status] ?? status;
  }

  static Color getColor(String status) {
    switch (status) {
      case pending:
        return Colors.orange;
      case approved:
        return Colors.green;
      case completed:
        return Colors.teal;
      case rejected:
        return Colors.red;
      case cancelled:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Obtener estados disponibles según el estado actual
  static List<String> getAvailableStatuses(String currentStatus) {
    switch (currentStatus) {
      case pending:
        return [approved, rejected];
      case approved:
        return [completed];
      case completed:
      case rejected:
        return []; // Estados finales
      default:
        return [];
    }
  }

  // Verificar si se puede cambiar a un estado específico
  static bool canChangeTo(String currentStatus, String newStatus) {
    return getAvailableStatuses(currentStatus).contains(newStatus);
  }
}
