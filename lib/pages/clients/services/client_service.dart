import 'dart:convert';
import '../../../constants/urls.dart';
import '../models/client_model.dart';
import 'package:odewa_bo/constants/constants.dart';
import 'package:odewa_bo/services/token_validation_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientService extends GetxService {
  final TokenValidationService _tokenValidationService =
      Get.find<TokenValidationService>();
  final box = GetStorage('User');

  Map<String, String> get _headers => {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${box.read('token')}',
  };

  Future<ClientsResponse> getClients({
    int page = 1,
    int limit = 25,
    String? search,
    String? employeeNumber,
    String? email,
    bool? isActive,
    String? companyId,
    List<String>? clientIds,
  }) async {
    try {
      final uriString = StringBuffer(
        '${Urls.backofficeClients}?page=$page&limit=$limit',
      );
      if (search != null && search.isNotEmpty) {
        uriString.write('&search=${Uri.encodeComponent(search)}');
      }
      if (employeeNumber != null && employeeNumber.isNotEmpty) {
        uriString.write(
          '&employeeNumber=${Uri.encodeComponent(employeeNumber)}',
        );
      }
      if (email != null && email.isNotEmpty) {
        uriString.write('&email=${Uri.encodeComponent(email)}');
      }
      if (isActive != null) {
        uriString.write('&isActive=$isActive');
      }
      if (companyId != null && companyId.isNotEmpty) {
        uriString.write('&companyId=$companyId');
      }
      if (clientIds != null && clientIds.isNotEmpty) {
        // Enviar los IDs a la API para filtrar por esos clientes
        final idsQuery = clientIds.join(',');
        uriString.write('&clientIds=${Uri.encodeComponent(idsQuery)}');
      }
      final uri = Uri.parse(uriString.toString());

      final response = await _tokenValidationService.client.get(
        uri,
        headers: _headers,
      );

      if (response.statusCode == Constants.HTTP_200_OK) {
        final clientResponse = ClientsResponse.fromJson(
          json.decode(response.body),
        );
        return clientResponse;
      } else {
        throw Exception('Failed to load clients');
      }
    } catch (e) {
      print(e);
      throw Exception('Error fetching clients: $e');
    }
  }

  Future<Client> createClient(Client client) async {
    try {
      final uri = Uri.parse(Urls.backofficeClients);

      final response = await _tokenValidationService.client.post(
        uri,
        headers: _headers,
        body: json.encode(client.toJsonForCreate()),
      );

      if (response.statusCode == Constants.HTTP_201_CREATED) {
        return Client.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create client');
      }
    } catch (e) {
      throw Exception('Error creating client: $e');
    }
  }

  Future<bool> updateClient(Client client) async {
    try {
      final uri = Uri.parse('${Urls.backofficeClients}/${client.id}');

      final response = await _tokenValidationService.client.patch(
        uri,
        headers: _headers,
        body: json.encode(client.toJson()),
      );

      if (response.statusCode == Constants.HTTP_200_OK) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> deleteClient(String clientId) async {
    try {
      final uri = Uri.parse('${Urls.backofficeClients}/$clientId');

      final response = await _tokenValidationService.client.delete(
        uri,
        headers: _headers,
      );

      if (response.statusCode != Constants.HTTP_200_OK &&
          response.statusCode != Constants.HTTP_204_NO_CONTENT) {
        throw Exception('Failed to delete client');
      }
    } catch (e) {
      throw Exception('Error deleting client: $e');
    }
  }

  Future<Client> toggleClientStatus(String clientId, bool isActive) async {
    try {
      final uri = Uri.parse('${Urls.backofficeClients}/$clientId/status');

      final response = await _tokenValidationService.client.patch(
        uri,
        headers: _headers,
        body: json.encode({'isActive': !isActive}),
      );

      if (response.statusCode == Constants.HTTP_200_OK) {
        return Client.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to toggle client status');
      }
    } catch (e) {
      throw Exception('Error toggling client status: $e');
    }
  }
}
