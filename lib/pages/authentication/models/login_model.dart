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

class OdewaUser {
  String id;
  String email;
  String firstName;
  String lastName;
  String? document;

  OdewaUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.document,
  });

  factory OdewaUser.fromJson(Map<String, dynamic> json) => OdewaUser(
    id: json['id'],
    email: json['email'],
    firstName: json['firstName'],
    lastName: json['lastName'],
    document: json['document'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'firstName': firstName,
    'lastName': lastName,
    'document': document,
  };
}
