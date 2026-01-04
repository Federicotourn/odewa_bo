import 'dart:convert';
import 'dart:html' as html;
import 'package:odewa_bo/constants/constants.dart';
import 'package:odewa_bo/constants/urls.dart';
import 'package:odewa_bo/pages/requests/models/request_model.dart';
import 'package:odewa_bo/services/token_validation_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

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
    String? search,
    String? status,
    List<String>? companyIds,
  }) async {
    try {
      // Construir los parámetros de consulta
      final queryParams = _buildQueryParameters(
        page: page,
        limit: limit,
        startDate: startDate,
        endDate: endDate,
        search: search,
        status: status,
        companyIds: companyIds,
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
    String? search,
    String? status,
    List<String>? companyIds,
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

    if (search != null && search.isNotEmpty) {
      params['search'] = search;
    }

    if (status != null && status.isNotEmpty && status != 'all') {
      params['status'] = status;
    }

    if (companyIds != null && companyIds.isNotEmpty) {
      params['company_ids'] = companyIds.join(',');
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
    List<String>? companyIds,
  }) async {
    try {
      // Construir los parámetros de consulta
      final queryParams = _buildExportQueryParameters(
        startDate: startDate,
        endDate: endDate,
        search: search,
        status: status,
        companyIds: companyIds,
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
    List<String>? companyIds,
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

    if (companyIds != null && companyIds.isNotEmpty) {
      params['company_ids'] = companyIds.join(',');
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

  Future<(bool, OdewaRequest?, String)> uploadReceipt(
    String id,
    List<int> fileBytes,
    String fileName,
  ) async {
    try {
      // Validar que el token existe
      final token = box.read('token');
      if (token == null || token.toString().isEmpty) {
        return (false, null, 'No se encontró el token de autenticación');
      }

      final uri = Uri.parse('${Urls.requests}/$id/receipt');

      // Crear multipart request
      final request = http.MultipartRequest('POST', uri);

      // Agregar headers
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      // Agregar el archivo
      request.files.add(
        http.MultipartFile.fromBytes('file', fileBytes, filename: fileName),
      );

      // Enviar la petición
      final streamedResponse = await _tokenValidationService.client.send(
        request,
      );
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == Constants.HTTP_200_OK ||
          response.statusCode == Constants.HTTP_201_CREATED) {
        try {
          final responseBody = response.body;
          if (responseBody.isEmpty) {
            return (false, null, 'La respuesta del servidor está vacía');
          }

          final decodedBody = json.decode(responseBody);

          // Verificar que decodedBody no sea null
          if (decodedBody == null) {
            return (false, null, 'La respuesta del servidor es null');
          }

          // Intentar parsear el request
          final updatedRequest = OdewaRequest.fromJson(decodedBody);
          return (true, updatedRequest, 'Comprobante subido exitosamente');
        } catch (e, stackTrace) {
          // Log más detallado del error
          print('Error al procesar respuesta de uploadReceipt: $e');
          print('Stack trace: $stackTrace');
          print('Response body: ${response.body}');
          return (
            false,
            null,
            'Error al procesar la respuesta del servidor: $e',
          );
        }
      } else {
        final error = Constants.handleError(response.body, response.statusCode);
        final errorMessage =
            error.$2.isNotEmpty ? error.$2 : 'Error desconocido del servidor';
        return (false, null, errorMessage);
      }
    } catch (e) {
      return (false, null, 'Error al subir comprobante: $e');
    }
  }
}
