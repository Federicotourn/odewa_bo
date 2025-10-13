import 'package:odewa_bo/pages/companies/models/company_model.dart';
import 'package:odewa_bo/pages/companies/services/company_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompanyController extends GetxController {
  final CompanyService _companyService = Get.find<CompanyService>();

  var companies = <Company>[].obs;
  var isLoading = false.obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var total = 0.obs;
  var limit = 10.obs;

  // Filters
  var searchQuery = ''.obs;
  var statusFilter = 'all'.obs; // all, active, inactive

  // Form controllers
  final nameController = TextEditingController();
  final employeeCountController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadCompanies();
  }

  @override
  void onClose() {
    nameController.dispose();
    employeeCountController.dispose();
    super.onClose();
  }

  void clearForm() {
    nameController.clear();
    employeeCountController.clear();
  }

  Future<void> loadCompanies({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;

    final result = await _companyService.getAllCompanies(
      page: currentPage.value,
      limit: limit.value,
    );

    if (result.$1) {
      final response = result.$2!;
      companies.value = response.data;
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

  List<Company> get filteredCompanies {
    var filtered =
        companies.where((company) {
          // Search filter
          final searchMatch =
              searchQuery.value.isEmpty ||
              company.name.toLowerCase().contains(
                searchQuery.value.toLowerCase(),
              );

          // Status filter
          final statusMatch =
              statusFilter.value == 'all' ||
              (statusFilter.value == 'active' && company.isActive) ||
              (statusFilter.value == 'inactive' && !company.isActive);

          return searchMatch && statusMatch;
        }).toList();

    return filtered;
  }

  Future<void> createCompany() async {
    if (!_validateForm()) return;

    isLoading.value = true;

    final request = CreateCompanyRequest(name: nameController.text.trim());

    final result = await _companyService.createCompany(request);

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
      await loadCompanies(showLoading: false);
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

  Future<void> updateCompany(String id) async {
    if (!_validateForm()) return;

    isLoading.value = true;

    final request = UpdateCompanyRequest(
      name:
          nameController.text.trim().isEmpty
              ? null
              : nameController.text.trim(),
      employeeCount:
          employeeCountController.text.trim().isEmpty
              ? null
              : int.tryParse(employeeCountController.text.trim()),
    );

    final result = await _companyService.updateCompany(id, request);

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
      await loadCompanies(showLoading: false);
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

  Future<void> toggleCompanyStatus(Company company) async {
    final result =
        company.isActive
            ? await _companyService.deactivateCompany(company.id)
            : await _companyService.activateCompany(company.id);

    if (result.$1) {
      Get.snackbar(
        'Éxito',
        result.$2,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      await loadCompanies(showLoading: false);
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

  void fillFormForEdit(Company company) {
    nameController.text = company.name;
    employeeCountController.text = company.employeeCount.toString();
  }

  bool _validateForm() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'El nombre de la empresa es requerido',
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
      loadCompanies();
    }
  }

  void nextPage() {
    if (currentPage.value < totalPages.value) {
      currentPage.value++;
      loadCompanies();
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      loadCompanies();
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void updateStatusFilter(String filter) {
    statusFilter.value = filter;
  }
}
