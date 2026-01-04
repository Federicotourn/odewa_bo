import 'dart:async';
import 'package:odewa_bo/pages/requests/models/request_model.dart';
import 'package:odewa_bo/pages/requests/services/request_service.dart';
import 'package:odewa_bo/controllers/logged_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestController extends GetxController {
  final RequestService _requestService = Get.find<RequestService>();
  Timer? _searchDebounce;

  // Observables
  var requests = <OdewaRequest>[].obs;
  var currentRequest = Rxn<OdewaRequest>();
  var selectedRequest =
      Rxn<OdewaRequest>(); // Nueva variable para la solicitud seleccionada
  var isLoading = false.obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var total = 0.obs;
  var limit = 10.obs;

  // Filters
  var searchQuery = ''.obs;
  var statusFilter =
      'all'.obs; // all, pending, approved, rejected, processing, completed

  // Date filters
  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();

  // Company filters
  var selectedCompanyIds = <String>[].obs;

  // Form controllers
  final amountController = TextEditingController();
  final dateController = TextEditingController();
  final clientIdController = TextEditingController();
  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _initializeCompanyFilterForClient();
    loadRequests();
  }

  void _initializeCompanyFilterForClient() {
    try {
      final loggedUserController = Get.find<LoggedUserController>();
      if (loggedUserController.isClient) {
        final user = loggedUserController.user.value;
        if (user?.companies != null && user!.companies!.isNotEmpty) {
          // Para clientes, automáticamente filtrar por su empresa
          selectedCompanyIds.value = [user.companies!.first.id];
        }
      }
    } catch (e) {
      // Si no se encuentra el LoggedUserController, no hacer nada
    }
  }

  @override
  @override
  void onClose() {
    _searchDebounce?.cancel();
    amountController.dispose();
    dateController.dispose();
    clientIdController.dispose();
    searchController.dispose();
    super.onClose();
  }

  void clearForm() {
    amountController.clear();
    dateController.clear();
    clientIdController.clear();
  }

  Future<void> loadRequests({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;

    final result = await _requestService.getAllRequests(
      page: currentPage.value,
      limit: limit.value,
      startDate: startDate.value,
      endDate: endDate.value,
      search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
      status: statusFilter.value != 'all' ? statusFilter.value : null,
      companyIds:
          selectedCompanyIds.isNotEmpty ? selectedCompanyIds.toList() : null,
    );

    if (result.$1) {
      final response = result.$2!;
      requests.value = response.data;
      total.value = response.meta.total;
      totalPages.value = response.meta.totalPages;
    } else {
      Get.snackbar(
        'Error',
        result.$3,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    isLoading.value = false;
  }

  Future<void> loadRequestById(String id) async {
    isLoading.value = true;

    final result = await _requestService.getRequestById(id);

    if (result.$1) {
      currentRequest.value = result.$2;
    } else {
      Get.snackbar(
        'Error',
        result.$3,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    isLoading.value = false;
  }

  // Los filtros ahora se aplican en el servidor, así que retornamos directamente las requests
  List<OdewaRequest> get filteredRequests {
    return requests;
  }

  Future<void> createRequest() async {
    if (!_validateForm()) return;

    isLoading.value = true;

    final request = CreateRequestRequest(
      amount: amountController.text.trim(),
      date: dateController.text.trim(),
      clientId: clientIdController.text.trim(),
    );

    final result = await _requestService.createRequest(request);

    if (result.$1) {
      Get.snackbar(
        'Éxito',
        result.$3,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      clearForm();
      Get.back(); // Close modal
      await loadRequests(showLoading: false);
    } else {
      Get.snackbar(
        'Error',
        result.$3,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    isLoading.value = false;
  }

  Future<void> updateRequest(String id) async {
    if (!_validateForm()) return;

    isLoading.value = true;

    final request = UpdateRequestRequest(
      amount:
          amountController.text.trim().isEmpty
              ? null
              : amountController.text.trim(),
      date:
          dateController.text.trim().isEmpty
              ? null
              : dateController.text.trim(),
    );

    final result = await _requestService.updateRequest(id, request);

    if (result.$1) {
      Get.snackbar(
        'Éxito',
        result.$3,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      clearForm();
      Get.back(); // Close modal
      await loadRequests(showLoading: false);
    } else {
      Get.snackbar(
        'Error',
        result.$3,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    isLoading.value = false;
  }

  Future<void> updateRequestStatus(String id, String newStatus) async {
    // Si el nuevo estado es "completed", primero debemos subir el receipt
    if (newStatus == 'completed') {
      // Mostrar el diálogo de subida de receipt
      // El diálogo manejará la subida y luego completará la orden
      return;
    }

    await _updateRequestStatusDirectly(id, newStatus);
  }

  Future<void> _updateRequestStatusDirectly(String id, String newStatus) async {
    final result = await _requestService.updateRequestStatus(id, newStatus);

    if (result.$1) {
      Get.snackbar(
        'Éxito',
        result.$2,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      await loadRequests(showLoading: false);
      if (requests.any((r) => r.id == id)) {
        selectedRequest.value = requests.firstWhere((r) => r.id == id);
      }
    } else {
      Get.snackbar(
        'Error',
        result.$2,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<bool> uploadReceiptAndComplete(
    String id,
    List<int> fileBytes,
    String fileName,
  ) async {
    // Primero subir el receipt
    final uploadResult = await _requestService.uploadReceipt(
      id,
      fileBytes,
      fileName,
    );

    if (!uploadResult.$1) {
      Get.snackbar(
        'Error',
        uploadResult.$3,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    // Si la subida fue exitosa, ahora completar la orden
    // Usamos el método directo para evitar el check de "completed"
    await _updateRequestStatusDirectly(id, 'completed');

    Get.snackbar(
      'Éxito',
      'Comprobante subido y orden completada exitosamente',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    await loadRequests(showLoading: false);
    if (requests.any((r) => r.id == id)) {
      selectedRequest.value = requests.firstWhere((r) => r.id == id);
    }
    return true;
  }

  Future<void> toggleRequestStatus(OdewaRequest request) async {
    final result =
        request.isActive
            ? await _requestService.deactivateRequest(request.id)
            : await _requestService.activateRequest(request.id);

    if (result.$1) {
      Get.snackbar(
        'Éxito',
        result.$2,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      await loadRequests(showLoading: false);
    } else {
      Get.snackbar(
        'Error',
        result.$2,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void fillFormForEdit(OdewaRequest request) {
    amountController.text = request.amount;
    dateController.text = request.date;
    clientIdController.text = request.clientId;
  }

  bool _validateForm() {
    if (amountController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'El monto es requerido',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (dateController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'La fecha es requerida',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (clientIdController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'El ID del cliente es requerido',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    // Validar que el monto sea un número válido
    final amount = double.tryParse(amountController.text.trim());
    if (amount == null || amount <= 0) {
      Get.snackbar(
        'Error',
        'El monto debe ser un número válido mayor a 0',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  void goToPage(int page) {
    if (page >= 1 && page <= totalPages.value) {
      currentPage.value = page;
      loadRequests();
    }
  }

  void nextPage() {
    if (currentPage.value < totalPages.value) {
      currentPage.value++;
      loadRequests();
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      loadRequests();
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    // Cancelar el timer anterior si existe
    _searchDebounce?.cancel();
    // Resetear a la primera página cuando se busca
    currentPage.value = 1;
    // Crear un nuevo timer con debounce de 500ms
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      loadRequests();
    });
  }

  void updateStatusFilter(String filter) {
    statusFilter.value = filter;
    // Resetear a la primera página cuando se cambia el filtro
    currentPage.value = 1;
    loadRequests();
  }

  void updateDateFilters(DateTime? start, DateTime? end) {
    startDate.value = start;
    endDate.value = end;
    loadRequests();
  }

  void clearDateFilters() {
    startDate.value = null;
    endDate.value = null;
    loadRequests();
  }

  void clearAllFilters() {
    searchQuery.value = '';
    searchController.clear();
    statusFilter.value = 'all';
    startDate.value = null;
    endDate.value = null;
    selectedCompanyIds.clear();
    loadRequests();
  }

  bool get hasActiveFilters {
    return searchQuery.value.isNotEmpty ||
        statusFilter.value != 'all' ||
        startDate.value != null ||
        endDate.value != null ||
        selectedCompanyIds.isNotEmpty;
  }

  String get activeFiltersDescription {
    List<String> descriptions = [];

    if (searchQuery.value.isNotEmpty) {
      descriptions.add('Búsqueda: "${searchQuery.value}"');
    }

    if (statusFilter.value != 'all') {
      descriptions.add('Estado: ${RequestStatus.getLabel(statusFilter.value)}');
    }

    if (startDate.value != null && endDate.value != null) {
      descriptions.add(
        '${startDate.value!.day}/${startDate.value!.month}/${startDate.value!.year} - ${endDate.value!.day}/${endDate.value!.month}/${endDate.value!.year}',
      );
    }

    if (selectedCompanyIds.isNotEmpty) {
      descriptions.add('${selectedCompanyIds.length} empresa(s)');
    }

    return descriptions.isEmpty ? 'Sin filtros' : descriptions.join(' • ');
  }

  // Método para seleccionar una solicitud para ver detalles
  void selectRequestForDetail(OdewaRequest request) {
    selectedRequest.value = request;
  }

  // Getter para obtener el total de páginas
  int get totalPagesValue => totalPages.value;

  // Company filter methods
  void updateCompanyFilters(List<String> companyIds) {
    selectedCompanyIds.value = companyIds;
    // Resetear a la primera página cuando se cambia el filtro
    currentPage.value = 1;
    loadRequests();
  }

  void toggleCompany(String companyId) {
    if (selectedCompanyIds.contains(companyId)) {
      selectedCompanyIds.remove(companyId);
    } else {
      selectedCompanyIds.add(companyId);
    }
    // Resetear a la primera página cuando se cambia el filtro
    currentPage.value = 1;
    loadRequests();
  }

  void clearCompanyFilters() {
    selectedCompanyIds.clear();
  }

  Future<void> exportRequests() async {
    try {
      isLoading.value = true;

      final result = await _requestService.exportRequestsToExcel(
        startDate: startDate.value,
        endDate: endDate.value,
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
        status: statusFilter.value != 'all' ? statusFilter.value : null,
        companyIds:
            selectedCompanyIds.isNotEmpty ? selectedCompanyIds.toList() : null,
      );

      if (result.$1) {
        Get.snackbar(
          'Éxito',
          'Archivo Excel exportado exitosamente',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          result.$2,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al exportar solicitudes: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
