import 'dart:convert';
import 'package:odewa_bo/constants/constants.dart';
import 'package:odewa_bo/constants/urls.dart';
import 'package:odewa_bo/pages/requests/models/request_model.dart';
import 'package:odewa_bo/services/token_validation_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class RequestService extends GetxService {
  final TokenValidationService _tokenValidationService =
      Get.find<TokenValidationService>();
  final box = GetStorage('User');

  Map<String, String> get _headers => {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${box.read('token')}',
  };

  Future<(bool, RequestResponse?, String)> getAllRequests({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final uri = Uri.parse(
        '${Urls.backofficeRequests}?page=$page&limit=$limit',
      );

      final response = await _tokenValidationService.client.get(
        uri,
        headers: _headers,
      );

      if (response.statusCode == Constants.HTTP_200_OK) {
        final requestResponse = RequestResponse.fromJson(
          json.decode(response.body),
        );
        return (true, requestResponse, 'Success');
      } else {
        final error = Constants.handleError(response.body, response.statusCode);
        return (false, null, error.$2);
      }
    } catch (e) {
      return (false, null, 'Error al obtener solicitudes: $e');
    }
  }

  Future<(bool, List<OdewaRequest>?, String)>
  getAllRequestsNoPagination() async {
    try {
      final uri = Uri.parse('${Urls.backofficeRequests}/all');

      final response = await _tokenValidationService.client.get(
        uri,
        headers: _headers,
      );

      if (response.statusCode == Constants.HTTP_200_OK) {
        final requests = requestsFromJson(response.body);
        return (true, requests, 'Success');
      } else {
        final error = Constants.handleError(response.body, response.statusCode);
        return (false, null, error.$2);
      }
    } catch (e) {
      return (false, null, 'Error al obtener solicitudes: $e');
    }
  }

  Future<(bool, OdewaRequest?, String)> getRequestById(String id) async {
    try {
      final uri = Uri.parse('${Urls.backofficeRequests}/$id');

      final response = await _tokenValidationService.client.get(
        uri,
        headers: _headers,
      );

      if (response.statusCode == Constants.HTTP_200_OK) {
        final request = OdewaRequest.fromJson(json.decode(response.body));
        return (true, request, 'Success');
      } else {
        final error = Constants.handleError(response.body, response.statusCode);
        return (false, null, error.$2);
      }
    } catch (e) {
      return (false, null, 'Error al obtener solicitud: $e');
    }
  }

  Future<(bool, List<OdewaRequest>?, String)> getRequestsByClient(
    String clientId,
  ) async {
    try {
      final uri = Uri.parse('${Urls.backofficeRequests}/client/$clientId');

      final response = await _tokenValidationService.client.get(
        uri,
        headers: _headers,
      );

      if (response.statusCode == Constants.HTTP_200_OK) {
        final requests = requestsFromJson(response.body);
        return (true, requests, 'Success');
      } else {
        final error = Constants.handleError(response.body, response.statusCode);
        return (false, null, error.$2);
      }
    } catch (e) {
      return (false, null, 'Error al obtener solicitudes del cliente: $e');
    }
  }

  Future<(bool, OdewaRequest?, String)> getActiveRequestByClient(
    String clientId,
  ) async {
    try {
      final uri = Uri.parse(
        '${Urls.backofficeRequests}/client/$clientId/active',
      );

      final response = await _tokenValidationService.client.get(
        uri,
        headers: _headers,
      );

      if (response.statusCode == Constants.HTTP_200_OK) {
        final request = OdewaRequest.fromJson(json.decode(response.body));
        return (true, request, 'Success');
      } else {
        final error = Constants.handleError(response.body, response.statusCode);
        return (false, null, error.$2);
      }
    } catch (e) {
      return (false, null, 'Error al obtener solicitud activa: $e');
    }
  }

  Future<(bool, OdewaRequest?, String)> createRequest(
    CreateRequestRequest request,
  ) async {
    try {
      final uri = Uri.parse(Urls.backofficeRequests);

      final response = await _tokenValidationService.client.post(
        uri,
        headers: _headers,
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == Constants.HTTP_201_CREATED) {
        final newRequest = OdewaRequest.fromJson(json.decode(response.body));
        return (true, newRequest, 'Solicitud creada exitosamente');
      } else {
        final error = Constants.handleError(response.body, response.statusCode);
        return (false, null, error.$2);
      }
    } catch (e) {
      return (false, null, 'Error al crear solicitud: $e');
    }
  }

  Future<(bool, OdewaRequest?, String)> updateRequest(
    String id,
    UpdateRequestRequest request,
  ) async {
    try {
      final uri = Uri.parse('${Urls.backofficeRequests}/$id');

      final response = await _tokenValidationService.client.patch(
        uri,
        headers: _headers,
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == Constants.HTTP_200_OK) {
        final updatedRequest = OdewaRequest.fromJson(
          json.decode(response.body),
        );
        return (true, updatedRequest, 'Solicitud actualizada exitosamente');
      } else {
        final error = Constants.handleError(response.body, response.statusCode);
        return (false, null, error.$2);
      }
    } catch (e) {
      return (false, null, 'Error al actualizar solicitud: $e');
    }
  }

  Future<(bool, OdewaRequest?, String)> updateRequestStatus(
    String id,
    String status,
  ) async {
    try {
      final uri = Uri.parse('${Urls.backofficeRequests}/$id/status');

      final request = UpdateRequestStatusRequest(status: status);

      final response = await _tokenValidationService.client.patch(
        uri,
        headers: _headers,
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == Constants.HTTP_200_OK) {
        final updatedRequest = OdewaRequest.fromJson(
          json.decode(response.body),
        );
        return (true, updatedRequest, 'Estado actualizado exitosamente');
      } else {
        final error = Constants.handleError(response.body, response.statusCode);
        return (false, null, error.$2);
      }
    } catch (e) {
      return (false, null, 'Error al actualizar estado: $e');
    }
  }

  Future<(bool, String)> activateRequest(String id) async {
    try {
      final uri = Uri.parse('${Urls.backofficeRequests}/$id/activate');

      final response = await _tokenValidationService.client.post(
        uri,
        headers: _headers,
      );

      if (response.statusCode == Constants.HTTP_200_OK) {
        return (true, 'Solicitud activada exitosamente');
      } else {
        final error = Constants.handleError(response.body, response.statusCode);
        return (false, error.$2);
      }
    } catch (e) {
      return (false, 'Error al activar solicitud: $e');
    }
  }

  Future<(bool, String)> deactivateRequest(String id) async {
    try {
      final uri = Uri.parse('${Urls.backofficeRequests}/$id/deactivate');

      final response = await _tokenValidationService.client.post(
        uri,
        headers: _headers,
      );

      if (response.statusCode == Constants.HTTP_200_OK) {
        return (true, 'Solicitud desactivada exitosamente');
      } else {
        final error = Constants.handleError(response.body, response.statusCode);
        return (false, error.$2);
      }
    } catch (e) {
      return (false, 'Error al desactivar solicitud: $e');
    }
  }
}
