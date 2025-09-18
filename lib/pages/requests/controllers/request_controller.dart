import 'package:odewa_bo/pages/requests/models/request_model.dart';
import 'package:odewa_bo/pages/requests/services/request_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestController extends GetxController {
  final RequestService _requestService = Get.find<RequestService>();

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

  // Form controllers
  final amountController = TextEditingController();
  final dateController = TextEditingController();
  final clientIdController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadRequests();
  }

  @override
  void onClose() {
    amountController.dispose();
    dateController.dispose();
    clientIdController.dispose();
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

  List<OdewaRequest> get filteredRequests {
    var filtered =
        requests.where((request) {
          // Search filter
          final searchMatch =
              searchQuery.value.isEmpty ||
              (request.client?.fullName.toLowerCase().contains(
                    searchQuery.value.toLowerCase(),
                  ) ??
                  false) ||
              request.amount.contains(searchQuery.value) ||
              request.date.contains(searchQuery.value);

          // Status filter
          final statusMatch =
              statusFilter.value == 'all' ||
              request.status == statusFilter.value;

          return searchMatch && statusMatch;
        }).toList();

    return filtered;
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
      selectedRequest.value = requests.firstWhere((r) => r.id == id);
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
  }

  void updateStatusFilter(String filter) {
    statusFilter.value = filter;
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
    statusFilter.value = 'all';
    startDate.value = null;
    endDate.value = null;
    loadRequests();
  }

  bool get hasActiveFilters {
    return searchQuery.value.isNotEmpty ||
        statusFilter.value != 'all' ||
        startDate.value != null ||
        endDate.value != null;
  }

  String get activeFiltersDescription {
    List<String> descriptions = [];

    if (searchQuery.value.isNotEmpty) {
      descriptions.add('Búsqueda: "${searchQuery.value}"');
    }

    if (statusFilter.value != 'all') {
      descriptions.add('Estado: ${statusFilter.value}');
    }

    if (startDate.value != null && endDate.value != null) {
      descriptions.add(
        '${startDate.value!.day}/${startDate.value!.month}/${startDate.value!.year} - ${endDate.value!.day}/${endDate.value!.month}/${endDate.value!.year}',
      );
    }

    return descriptions.isEmpty ? 'Sin filtros' : descriptions.join(' • ');
  }

  // Método para seleccionar una solicitud para ver detalles
  void selectRequestForDetail(OdewaRequest request) {
    selectedRequest.value = request;
  }

  // Getter para obtener el total de páginas
  int get totalPagesValue => totalPages.value;
}
