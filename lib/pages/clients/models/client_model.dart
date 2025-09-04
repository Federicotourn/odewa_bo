// To parse this JSON data, do
//
//     final clientsResponse = clientsResponseFromJson(jsonString);

import 'dart:convert';

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
  DateTime updatedAt;
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
  int? monthlyBalance;
  String? password;

  Client({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
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
    this.monthlyBalance,
    this.password,
  });

  factory Client.fromJson(Map<String, dynamic> json) => Client(
    id: json["id"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
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
    monthlyBalance: json["monthlyBalance"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
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
    "monthlyBalance": monthlyBalance,
    "password": password,
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
    "beneficiary": beneficiary,
    "monthlyBalance": monthlyBalance,
    "password": password,
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
