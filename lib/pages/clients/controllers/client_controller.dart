import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/client_model.dart' as client_model;
import '../services/client_service.dart';
import '../../companies/models/company_model.dart';
import '../../companies/services/company_service.dart';

class ClientController extends GetxController {
  final ClientService _clientService = ClientService();
  final CompanyService _companyService = Get.find<CompanyService>();

  final RxList<client_model.Client> clients = <client_model.Client>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxInt totalItems = 0.obs;
  final RxString searchQuery = ''.obs;
  final RxInt limit = 25.obs; // Tamaño de página por defecto: 25
  final Rx<client_model.Client?> selectedClient = Rx<client_model.Client?>(
    null,
  );

  // Clientes seleccionados para filtro múltiple
  final RxList<client_model.Client> selectedClients =
      <client_model.Client>[].obs;
  final RxString clientSearchText = ''.obs;
  final RxList<client_model.Client> allClientsForFilter =
      <client_model.Client>[].obs;
  final RxBool isLoadingAllClients = false.obs;

  // Filtros adicionales
  final RxString employeeNumberFilter = ''.obs;
  final RxString emailFilter = ''.obs;
  final Rx<bool?> isActiveFilter = Rx<bool?>(null);
  final RxString companyIdFilter = ''.obs;

  // Companies for dropdown
  final RxList<Company> companies = <Company>[].obs;
  final RxBool isLoadingCompanies = false.obs;
  final RxString selectedCompanyId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchClients();
    fetchCompanies();
    fetchAllClientsForFilter();
  }

  Future<void> fetchAllClientsForFilter() async {
    try {
      isLoadingAllClients.value = true;
      // Obtener todos los clientes para el filtro (hacer múltiples requests si es necesario)
      List<client_model.Client> allClients = [];
      int currentPage = 1;
      int totalPages = 1;

      do {
        final result = await _clientService.getClients(
          page: currentPage,
          limit: 100, // Obtener 100 por página
        );
        allClients.addAll(result.data);
        totalPages = result.meta.totalPages;
        currentPage++;
      } while (currentPage <= totalPages);

      allClientsForFilter.value = allClients;
    } catch (e) {
      // Silenciar errores, no es crítico para el filtro
      debugPrint('Error fetching all clients for filter: $e');
    } finally {
      isLoadingAllClients.value = false;
    }
  }

  void toggleClientSelection(client_model.Client client) {
    if (selectedClients.any((c) => c.id == client.id)) {
      selectedClients.removeWhere((c) => c.id == client.id);
    } else {
      selectedClients.add(client);
    }
    // Actualizar el filtro de búsqueda basado en los clientes seleccionados
    updateSearchFromSelectedClients();
  }

  void removeSelectedClient(client_model.Client client) {
    selectedClients.removeWhere((c) => c.id == client.id);
    updateSearchFromSelectedClients();
  }

  void clearSelectedClients() {
    selectedClients.clear();
    clientSearchText.value = '';
    searchQuery.value = '';
  }

  void updateSearchFromSelectedClients() {
    // Al cambiar la selección, ir a página 1 y recargar con los clientIds
    currentPage.value = 1;
    fetchClients();
  }

  List<client_model.Client> getFilteredClientsForAutocomplete(String query) {
    final List<client_model.Client> matching;
    if (query.isEmpty) {
      matching = allClientsForFilter.toList();
    } else {
      final lowerQuery = query.toLowerCase();
      matching =
          allClientsForFilter.where((client) {
            final fullName =
                '${client.firstName} ${client.lastName}'.toLowerCase();
            final document = client.document.toLowerCase();
            final email = (client.email ?? '').toLowerCase();
            return fullName.contains(lowerQuery) ||
                document.contains(lowerQuery) ||
                email.contains(lowerQuery);
          }).toList();
    }
    // Ordenar: seleccionados primero, luego el resto (para que se vean
    // chequeados en el listado y se pueda desmarcar desde ahí)
    matching.sort((a, b) {
      final aSel = selectedClients.any((c) => c.id == a.id);
      final bSel = selectedClients.any((c) => c.id == b.id);
      if (aSel && !bSel) return -1;
      if (!aSel && bSel) return 1;
      return 0;
    });
    return matching;
  }

  Future<void> fetchClients() async {
    try {
      isLoading.value = true;

      // Si hay clientes seleccionados, enviar sus IDs a la API
      List<String>? clientIds;
      if (selectedClients.isNotEmpty) {
        clientIds = selectedClients.map((c) => c.id).toList();
      }

      final result = await _clientService.getClients(
        page: currentPage.value,
        limit: limit.value,
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
        employeeNumber:
            employeeNumberFilter.value.isEmpty
                ? null
                : employeeNumberFilter.value,
        email: emailFilter.value.isEmpty ? null : emailFilter.value,
        isActive: isActiveFilter.value,
        companyId: companyIdFilter.value.isEmpty ? null : companyIdFilter.value,
        clientIds: clientIds,
      );

      clients.value = result.data;
      totalPages.value = result.meta.totalPages;
      totalItems.value = result.meta.total;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load clients',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCompanies() async {
    try {
      isLoadingCompanies.value = true;
      final result = await _companyService.getAllCompanies(
        page: 1,
        limit: 100, // Get all companies for dropdown
      );

      if (result.$1) {
        companies.value = result.$2!.data;
      } else {
        Get.snackbar(
          'Error',
          'Failed to load companies',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load companies',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingCompanies.value = false;
    }
  }

  Future<bool> createClient(client_model.Client client) async {
    try {
      isLoading.value = true;
      await _clientService.createClient(client);
      Get.snackbar(
        'Success',
        'Client created successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      fetchClients(); // Refresh the list
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create client',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void setPage(int page) {
    if (page != currentPage.value && page > 0 && page <= totalPages.value) {
      currentPage.value = page;
      fetchClients();
    }
  }

  void setLimit(int newLimit) {
    if (newLimit != limit.value && newLimit > 0) {
      limit.value = newLimit;
      currentPage.value = 1; // Reset to first page when changing limit
      fetchClients();
    }
  }

  void setSearch(String query) {
    searchQuery.value = query;
    currentPage.value = 1; // Reset to first page when searching
    fetchClients();
  }

  void updateEmployeeNumberFilter(String employeeNumber) {
    employeeNumberFilter.value = employeeNumber;
  }

  void updateEmailFilter(String email) {
    emailFilter.value = email;
  }

  void updateIsActiveFilter(bool? isActive) {
    isActiveFilter.value = isActive;
  }

  void updateCompanyIdFilter(String companyId) {
    companyIdFilter.value = companyId;
  }

  void applyFilters() {
    currentPage.value = 1;
    fetchClients();
  }

  void clearAllFilters() {
    searchQuery.value = '';
    employeeNumberFilter.value = '';
    emailFilter.value = '';
    isActiveFilter.value = null;
    companyIdFilter.value = '';
    selectedClients.clear();
    clientSearchText.value = '';
    currentPage.value = 1;
    fetchClients();
  }

  bool get hasActiveFilters {
    return searchQuery.value.isNotEmpty ||
        employeeNumberFilter.value.isNotEmpty ||
        emailFilter.value.isNotEmpty ||
        isActiveFilter.value != null ||
        companyIdFilter.value.isNotEmpty ||
        selectedClients.isNotEmpty;
  }

  String get activeFiltersDescription {
    List<String> filters = [];
    if (searchQuery.value.isNotEmpty) {
      filters.add('Búsqueda: "${searchQuery.value}"');
    }
    if (employeeNumberFilter.value.isNotEmpty) {
      filters.add('Nº empleado: "${employeeNumberFilter.value}"');
    }
    if (emailFilter.value.isNotEmpty) {
      filters.add('Email: "${emailFilter.value}"');
    }
    if (isActiveFilter.value != null) {
      filters.add('Estado: ${isActiveFilter.value! ? "Activo" : "Inactivo"}');
    }
    if (companyIdFilter.value.isNotEmpty) {
      final company = getSelectedCompany();
      if (company != null) {
        filters.add('Empresa: "${company.name}"');
      }
    }
    if (selectedClients.isNotEmpty) {
      filters.add(
        'Clientes: ${selectedClients.length} seleccionado${selectedClients.length == 1 ? '' : 's'}',
      );
    }
    return filters.join(' | ');
  }

  Future<bool> updateClient(client_model.Client client) async {
    try {
      isLoading.value = true;
      final result = await _clientService.updateClient(client);
      if (result) {
        await fetchClients();
        selectedClient.value = client;
        isLoading.value = false;
        return true;
      } else {
        isLoading.value = false;
        return true;
      }
    } catch (e) {
      isLoading.value = false;
      return false;
    }
  }

  Future<void> deleteClient(String clientId) async {
    try {
      isLoading.value = true;
      await _clientService.deleteClient(clientId);
      Get.snackbar(
        'Success',
        'Client deleted successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      fetchClients(); // Refresh the list
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete client',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleClientStatus(client_model.Client client) async {
    try {
      await _clientService.toggleClientStatus(client.id, client.isActive);
      Get.snackbar(
        'Success',
        'Client status updated successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      fetchClients(); // Refresh the list
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update client status',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void selectClientForDetail(client_model.Client client) {
    selectedClient.value = client;
  }

  void setSelectedCompanyId(String companyId) {
    selectedCompanyId.value = companyId;
  }

  void clearSelectedCompany() {
    selectedCompanyId.value = '';
  }

  Company? getSelectedCompany() {
    if (selectedCompanyId.value.isEmpty) return null;
    try {
      return companies.firstWhere(
        (company) => company.id == selectedCompanyId.value,
      );
    } catch (e) {
      return null;
    }
  }
}
