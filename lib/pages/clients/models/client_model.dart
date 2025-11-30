// To parse this JSON data, do
//
//     final clientsResponse = clientsResponseFromJson(jsonString);

import 'dart:convert';
import '../../companies/models/company_model.dart';

ClientsResponse clientsResponseFromJson(String str) =>
    ClientsResponse.fromJson(json.decode(str));

String clientsResponseToJson(ClientsResponse data) =>
    json.encode(data.toJson());

class ClientsResponse {
  List<Client> data;
  Meta meta;

  ClientsResponse({required this.data, required this.meta});

  factory ClientsResponse.fromJson(Map<String, dynamic> json) =>
      ClientsResponse(
        data: List<Client>.from(json["data"].map((x) => Client.fromJson(x))),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "meta": meta.toJson(),
  };
}

class Client {
  String id;
  DateTime createdAt;
  DateTime? updatedAt;
  bool isActive;
  String firstName;
  String lastName;
  String? email;
  String document;
  String? phone;
  String? address;
  String? city;
  String? bank;
  String? currency;
  String? accountNumber;
  String? branch;
  String? branchNumber;
  String? beneficiary;
  double? monthlyBalance;
  String? password;
  String? employeeNumber;
  Company? company;
  double? monthlyAdvancedAmount;
  double? availableBalance;

  Client({
    required this.id,
    required this.createdAt,
    this.updatedAt,
    required this.isActive,
    required this.firstName,
    required this.lastName,
    this.email,
    required this.document,
    this.phone,
    this.address,
    this.city,
    this.bank,
    this.currency,
    this.accountNumber,
    this.branch,
    this.branchNumber,
    this.beneficiary,
    this.monthlyBalance,
    this.password,
    this.employeeNumber,
    this.company,
    this.monthlyAdvancedAmount,
    this.availableBalance,
  });

  factory Client.fromJson(Map<String, dynamic> json) => Client(
    id: json["id"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt:
        json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]) : null,
    isActive: json["isActive"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"] ?? '',
    document: json["document"],
    phone: json["phone"],
    address: json["address"],
    city: json["city"],
    bank: json["bank"],
    currency: json["currency"],
    accountNumber: json["accountNumber"],
    branch: json["branch"],
    branchNumber: json["branchNumber"],
    beneficiary: json["beneficiary"],
    monthlyBalance:
        json["monthlyBalance"] != null
            ? (json["monthlyBalance"] is int
                ? json["monthlyBalance"].toDouble()
                : json["monthlyBalance"] as double)
            : null,
    password: json["password"],
    employeeNumber: json["employeeNumber"],
    company: json["company"] != null ? Company.fromJson(json["company"]) : null,
    monthlyAdvancedAmount: json["monthlyAdvancedAmount"],
    availableBalance: json["availableBalance"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
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
    "branchNumber": branchNumber,
    "beneficiary": beneficiary,
    "monthlyBalance": monthlyBalance,
    "password": password,
    "employeeNumber": employeeNumber,
    "company": company?.toJson(),
    "monthlyAdvancedAmount": monthlyAdvancedAmount,
    "availableBalance": availableBalance,
  };

  // Método específico para crear clientes (sin id, createdAt, updatedAt)
  Map<String, dynamic> toJsonForCreate() => {
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
    "branchNumber": branchNumber,
    "beneficiary": beneficiary,
    "monthlyBalance": monthlyBalance,
    "password": password,
    "employeeNumber": employeeNumber,
    "companyId": company?.id,
    "monthlyAdvancedAmount": monthlyAdvancedAmount,
    "availableBalance": availableBalance,
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
    page: json["page"]?.toString() ?? '1',
    limit: json["limit"]?.toString() ?? '10',
    total:
        json["total"] is int
            ? json["total"] as int
            : int.tryParse(json["total"]?.toString() ?? '0') ?? 0,
    totalPages:
        json["totalPages"] is int
            ? json["totalPages"] as int
            : int.tryParse(json["totalPages"]?.toString() ?? '1') ?? 1,
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "limit": limit,
    "total": total,
    "totalPages": totalPages,
  };
}
