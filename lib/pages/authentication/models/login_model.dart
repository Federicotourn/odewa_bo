import 'dart:convert';

// Odewa API authentication response
LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));
String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  String token;
  OdewaUser user;

  LoginResponse({required this.token, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    token: json['token'],
    user: OdewaUser.fromJson(json['user']),
  );

  Map<String, dynamic> toJson() => {'token': token, 'user': user.toJson()};
}

// Simplified Company model for login response
class LoginCompany {
  String id;
  String name;
  int employeeCount;
  double maxSalaryPercentage;
  bool isActive;

  LoginCompany({
    required this.id,
    required this.name,
    required this.employeeCount,
    required this.maxSalaryPercentage,
    required this.isActive,
  });

  factory LoginCompany.fromJson(Map<String, dynamic> json) => LoginCompany(
    id: json['id'],
    name: json['name'],
    employeeCount: json['employeeCount'] ?? 0,
    maxSalaryPercentage: (json['maxSalaryPercentage'] ?? 100.0).toDouble(),
    isActive: json['isActive'] ?? true,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'employeeCount': employeeCount,
    'maxSalaryPercentage': maxSalaryPercentage,
    'isActive': isActive,
  };
}

class OdewaUser {
  String id;
  String email;
  String firstName;
  String lastName;
  String? document;
  String role;
  List<LoginCompany>? companies;

  OdewaUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.document,
    required this.role,
    this.companies,
  });

  factory OdewaUser.fromJson(Map<String, dynamic> json) => OdewaUser(
    id: json['id'],
    email: json['email'],
    firstName: json['firstName'],
    lastName: json['lastName'],
    document: json['document'],
    role: json['role'] ?? 'client', // Default to 'client' if not provided
    companies:
        json['companies'] != null
            ? List<LoginCompany>.from(
              json['companies'].map((x) => LoginCompany.fromJson(x)),
            )
            : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'firstName': firstName,
    'lastName': lastName,
    'document': document,
    'role': role,
    if (companies != null)
      'companies': companies!.map((x) => x.toJson()).toList(),
  };
}
