import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/client_model.dart';
import '../services/client_service.dart';
import '../../companies/models/company_model.dart';
import '../../companies/services/company_service.dart';

class ClientController extends GetxController {
  final ClientService _clientService = ClientService();
  final CompanyService _companyService = Get.find<CompanyService>();

  final RxList<Client> clients = <Client>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxInt totalItems = 0.obs;
  final RxString searchQuery = ''.obs;
  final RxInt limit = 25.obs; // Tamaño de página por defecto: 25
  final Rx<Client?> selectedClient = Rx<Client?>(null);

  // Companies for dropdown
  final RxList<Company> companies = <Company>[].obs;
  final RxBool isLoadingCompanies = false.obs;
  final RxString selectedCompanyId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchClients();
    fetchCompanies();
  }

  Future<void> fetchClients() async {
    try {
      isLoading.value = true;
      final result = await _clientService.getClients(
        page: currentPage.value,
        limit: limit.value,
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
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

  Future<bool> createClient(Client client) async {
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

  Future<bool> updateClient(Client client) async {
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

  Future<void> toggleClientStatus(Client client) async {
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

  void selectClientForDetail(Client client) {
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
