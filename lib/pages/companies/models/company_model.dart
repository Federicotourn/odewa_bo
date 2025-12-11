import 'dart:convert';

List<Company> companiesFromJson(String str) => List<Company>.from(
  json.decode(str)["data"].map((x) => Company.fromJson(x)),
);

String companiesToJson(List<Company> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Company companyFromJson(String str) => Company.fromJson(json.decode(str));
String companyToJson(Company data) => json.encode(data.toJson());

class CompanyResponse {
  List<Company> data;
  Meta meta;

  CompanyResponse({required this.data, required this.meta});

  factory CompanyResponse.fromJson(Map<String, dynamic> json) =>
      CompanyResponse(
        data: List<Company>.from(json["data"].map((x) => Company.fromJson(x))),
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

class Company {
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  dynamic createdById;
  dynamic updatedById;
  dynamic deletedById;
  bool isActive;
  String name;
  int employeeCount = 0;
  double? averageMonthlyBalance;
  double maxSalaryPercentage = 100.0;

  Company({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.createdById,
    required this.updatedById,
    required this.deletedById,
    required this.isActive,
    required this.name,
    this.employeeCount = 0,
    this.averageMonthlyBalance,
    this.maxSalaryPercentage = 100.0,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    id: json["id"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    deletedAt: json["deletedAt"],
    createdById: json["createdById"],
    updatedById: json["updatedById"],
    deletedById: json["deletedById"],
    isActive: json["isActive"],
    name: json["name"],
    employeeCount: json["employeeCount"] ?? 0,
    averageMonthlyBalance: json["averageMonthlyBalance"],
    maxSalaryPercentage: (json["maxSalaryPercentage"] ?? 100.0).toDouble(),
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
    "name": name,
    "employeeCount": employeeCount,
    "averageMonthlyBalance": averageMonthlyBalance,
    "maxSalaryPercentage": maxSalaryPercentage,
  };

  // Método copyWith para facilitar la actualización
  Company copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic deletedAt,
    dynamic createdById,
    dynamic updatedById,
    dynamic deletedById,
    bool? isActive,
    String? name,
    int? employeeCount,
    double? averageMonthlyBalance,
    double? maxSalaryPercentage,
  }) {
    return Company(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      createdById: createdById ?? this.createdById,
      updatedById: updatedById ?? this.updatedById,
      deletedById: deletedById ?? this.deletedById,
      isActive: isActive ?? this.isActive,
      name: name ?? this.name,
      employeeCount: employeeCount ?? this.employeeCount,
      averageMonthlyBalance:
          averageMonthlyBalance ?? this.averageMonthlyBalance,
      maxSalaryPercentage: maxSalaryPercentage ?? this.maxSalaryPercentage,
    );
  }
}

class CreateCompanyRequest {
  String name;
  double maxSalaryPercentage;

  CreateCompanyRequest({required this.name, this.maxSalaryPercentage = 100.0});

  Map<String, dynamic> toJson() => {
    "name": name,
    "maxSalaryPercentage": maxSalaryPercentage,
  };
}

class UpdateCompanyRequest {
  String? name;
  int? employeeCount;
  double? maxSalaryPercentage;

  UpdateCompanyRequest({
    this.name,
    this.employeeCount,
    this.maxSalaryPercentage,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (name != null) data["name"] = name;
    if (employeeCount != null) data["employeeCount"] = employeeCount;
    if (maxSalaryPercentage != null) {
      data["maxSalaryPercentage"] = maxSalaryPercentage;
    }
    return data;
  }
}
