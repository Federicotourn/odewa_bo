import 'dart:convert';
import 'package:odewa_bo/constants/constants.dart';
import 'package:odewa_bo/constants/urls.dart';
import 'package:odewa_bo/pages/companies/models/company_model.dart';
import 'package:odewa_bo/services/token_validation_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CompanyService extends GetxService {
  final TokenValidationService _tokenValidationService =
      Get.find<TokenValidationService>();
  final box = GetStorage('User');

  Map<String, String> get _headers => {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${box.read('token')}',
  };

  Future<(bool, CompanyResponse?, String)> getAllCompanies({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final uri = Uri.parse('${Urls.companies}?page=$page&limit=$limit');

      final response = await _tokenValidationService.client.get(
        uri,
        headers: _headers,
      );

      if (response.statusCode == Constants.HTTP_200_OK) {
        final companyResponse = CompanyResponse.fromJson(
          json.decode(response.body),
        );
        return (true, companyResponse, 'Success');
      } else {
        final error = Constants.handleError(response.body, response.statusCode);
        return (false, null, error.$2);
      }
    } catch (e) {
      return (false, null, 'Error al obtener empresas: $e');
    }
  }

  Future<(bool, Company?, String)> getCompanyById(String id) async {
    try {
      final uri = Uri.parse('${Urls.companies}/$id');

      final response = await _tokenValidationService.client.get(
        uri,
        headers: _headers,
      );

      if (response.statusCode == Constants.HTTP_200_OK) {
        final company = Company.fromJson(json.decode(response.body));
        return (true, company, 'Success');
      } else {
        final error = Constants.handleError(response.body, response.statusCode);
        return (false, null, error.$2);
      }
    } catch (e) {
      return (false, null, 'Error al obtener empresa: $e');
    }
  }

  Future<(bool, Company?, String)> createCompany(
    CreateCompanyRequest request,
  ) async {
    try {
      final uri = Uri.parse(Urls.companies);

      final response = await _tokenValidationService.client.post(
        uri,
        headers: _headers,
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == Constants.HTTP_201_CREATED) {
        final company = Company.fromJson(json.decode(response.body));
        return (true, company, 'Empresa creada exitosamente');
      } else {
        final error = Constants.handleError(response.body, response.statusCode);
        return (false, null, error.$2);
      }
    } catch (e) {
      return (false, null, 'Error al crear empresa: $e');
    }
  }

  Future<(bool, Company?, String)> updateCompany(
    String id,
    UpdateCompanyRequest request,
  ) async {
    try {
      final uri = Uri.parse('${Urls.companies}/$id');

      final response = await _tokenValidationService.client.patch(
        uri,
        headers: _headers,
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == Constants.HTTP_200_OK) {
        final company = Company.fromJson(json.decode(response.body));
        return (true, company, 'Empresa actualizada exitosamente');
      } else {
        final error = Constants.handleError(response.body, response.statusCode);
        return (false, null, error.$2);
      }
    } catch (e) {
      return (false, null, 'Error al actualizar empresa: $e');
    }
  }

  Future<(bool, String)> activateCompany(String id) async {
    try {
      final uri = Uri.parse('${Urls.companies}/$id/activate');

      final response = await _tokenValidationService.client.post(
        uri,
        headers: _headers,
      );

      if (response.statusCode == Constants.HTTP_200_OK) {
        return (true, 'Empresa activada exitosamente');
      } else {
        final error = Constants.handleError(response.body, response.statusCode);
        return (false, error.$2);
      }
    } catch (e) {
      return (false, 'Error al activar empresa: $e');
    }
  }

  Future<(bool, String)> deactivateCompany(String id) async {
    try {
      final uri = Uri.parse('${Urls.companies}/$id/deactivate');

      final response = await _tokenValidationService.client.post(
        uri,
        headers: _headers,
      );

      if (response.statusCode == Constants.HTTP_200_OK) {
        return (true, 'Empresa desactivada exitosamente');
      } else {
        final error = Constants.handleError(response.body, response.statusCode);
        return (false, error.$2);
      }
    } catch (e) {
      return (false, 'Error al desactivar empresa: $e');
    }
  }
}
