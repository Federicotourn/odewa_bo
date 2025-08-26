import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/client_model.dart';
import '../services/client_service.dart';

class ClientController extends GetxController {
  final ClientService _clientService = ClientService();

  final RxList<Client> clients = <Client>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxInt totalItems = 0.obs;
  final RxString searchQuery = ''.obs;
  final int limit = 10;
  final Rx<Client?> selectedClient = Rx<Client?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchClients();
  }

  Future<void> fetchClients() async {
    try {
      isLoading.value = true;
      final result = await _clientService.getClients(
        page: currentPage.value,
        limit: limit,
        search: searchQuery.value,
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

  Future<void> createClient(Client client) async {
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
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create client',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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

  void setSearch(String query) {
    searchQuery.value = query;
    currentPage.value = 1; // Reset to first page when searching
    fetchClients();
  }

  Future<void> updateClient(Client client) async {
    try {
      isLoading.value = true;
      await _clientService.updateClient(client);
      Get.snackbar(
        'Success',
        'Client updated successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      fetchClients(); // Refresh the list
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update client',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
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
}
