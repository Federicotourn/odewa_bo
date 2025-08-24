// To parse this JSON data, do
//
//     final userResponse = userResponseFromJson(jsonString);

import 'dart:convert';

UserResponse userResponseFromJson(String str) =>
    UserResponse.fromJson(json.decode(str));

String userResponseToJson(UserResponse data) => json.encode(data.toJson());

class UserResponse {
  List<User> data;
  int total;
  int limit;
  int page;

  UserResponse({
    required this.data,
    required this.total,
    required this.limit,
    required this.page,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
    data: List<User>.from(json["data"].map((x) => User.fromJson(x))),
    total: json["total"],
    limit: json["limit"],
    page: json["page"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "total": total,
    "limit": limit,
    "page": page,
  };
}

class User {
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
  // String role;
  dynamic document;

  User({
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
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
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
  };

  // Método copyWith para facilitar la actualización
  User copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic deletedAt,
    dynamic createdById,
    dynamic updatedById,
    dynamic deletedById,
    bool? isActive,
    String? firstName,
    String? lastName,
    String? email,
    dynamic document,
  }) {
    return User(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      createdById: createdById ?? this.createdById,
      updatedById: updatedById ?? this.updatedById,
      deletedById: deletedById ?? this.deletedById,
      isActive: isActive ?? this.isActive,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      document: document ?? this.document,
    );
  }

  // Getter para nombre completo (ahora es solo el nombre)
  String get fullName => '$firstName $lastName';
}
