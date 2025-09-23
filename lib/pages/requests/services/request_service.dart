import 'dart:convert';
import 'dart:html' as html;
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
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // Construir los parámetros de consulta
      final queryParams = _buildQueryParameters(
        page: page,
        limit: limit,
        startDate: startDate,
        endDate: endDate,
      );

      // Construir la URL solo si hay parámetros
      final uri =
          queryParams.isNotEmpty
              ? Uri.parse(
                Urls.backofficeRequests,
              ).replace(queryParameters: queryParams)
              : Uri.parse(Urls.backofficeRequests);

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

  Map<String, String> _buildQueryParameters({
    required int page,
    required int limit,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final Map<String, String> params = {
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (startDate != null) {
      params['start_date'] = startDate.toIso8601String().split('T')[0];
    }

    if (endDate != null) {
      params['end_date'] = endDate.toIso8601String().split('T')[0];
    }

    return params;
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

  Future<(bool, String)> updateRequestStatus(String id, String status) async {
    try {
      final uri = Uri.parse('${Urls.backofficeRequests}/$id/status');

      final request = UpdateRequestStatusRequest(status: status);

      final response = await _tokenValidationService.client.patch(
        uri,
        headers: _headers,
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == Constants.HTTP_200_OK) {
        return (true, 'Estado actualizado exitosamente');
      } else {
        final error = Constants.handleError(response.body, response.statusCode);
        return (false, error.$2);
      }
    } catch (e) {
      return (false, 'Error al actualizar estado: $e');
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

  Future<(bool, String)> exportRequestsToExcel({
    DateTime? startDate,
    DateTime? endDate,
    String? search,
    String? status,
  }) async {
    try {
      // Construir los parámetros de consulta
      final queryParams = _buildExportQueryParameters(
        startDate: startDate,
        endDate: endDate,
        search: search,
        status: status,
      );

      // Construir la URL solo si hay parámetros
      final uri =
          queryParams.isNotEmpty
              ? Uri.parse(
                '${Urls.requests}/export/excel',
              ).replace(queryParameters: queryParams)
              : Uri.parse('${Urls.requests}/export/excel');

      final response = await _tokenValidationService.client.get(
        uri,
        headers: _headers,
      );

      if (response.statusCode == Constants.HTTP_200_OK) {
        // Obtener el nombre del archivo del header Content-Disposition
        final contentDisposition = response.headers['content-disposition'];
        String filename =
            'solicitudes_${DateTime.now().toIso8601String().split('T')[0]}.xlsx';

        if (contentDisposition != null) {
          final filenameMatch = RegExp(
            r'filename="([^"]+)"',
          ).firstMatch(contentDisposition);
          if (filenameMatch != null) {
            filename = filenameMatch.group(1)!;
          }
        }

        // Guardar el archivo
        await _saveExcelFile(response.bodyBytes, filename);

        return (true, 'Archivo exportado exitosamente: $filename');
      } else {
        final error = Constants.handleError(response.body, response.statusCode);
        return (false, error.$2);
      }
    } catch (e) {
      return (false, 'Error al exportar solicitudes: $e');
    }
  }

  Map<String, String> _buildExportQueryParameters({
    DateTime? startDate,
    DateTime? endDate,
    String? search,
    String? status,
  }) {
    final Map<String, String> params = {};

    if (startDate != null) {
      params['start_date'] = startDate.toIso8601String().split('T')[0];
    }

    if (endDate != null) {
      params['end_date'] = endDate.toIso8601String().split('T')[0];
    }

    if (search != null && search.isNotEmpty) {
      params['search'] = search;
    }

    if (status != null && status.isNotEmpty) {
      params['status'] = status;
    }

    return params;
  }

  Future<void> _saveExcelFile(List<int> bytes, String filename) async {
    try {
      // Para web, usar download
      if (GetPlatform.isWeb) {
        await _downloadFileWeb(bytes, filename);
      } else {
        // Para móvil/desktop, usar file picker
        await _saveFileMobile(bytes, filename);
      }
    } catch (e) {
      throw Exception('Error al guardar archivo: $e');
    }
  }

  Future<void> _downloadFileWeb(List<int> bytes, String filename) async {
    // Crear blob y descargar
    final blob = html.Blob([
      bytes,
    ], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', filename)
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  Future<void> _saveFileMobile(List<int> bytes, String filename) async {
    // Para móvil/desktop, usar file picker
    // Nota: Necesitarías agregar file_picker a las dependencias
    // Por ahora, solo lanzamos una excepción para indicar que no está implementado
    throw UnsupportedError(
      'Exportación de archivos no soportada en esta plataforma',
    );
  }
}
