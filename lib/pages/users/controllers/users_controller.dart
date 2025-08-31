import 'package:odewa_bo/constants/app_theme.dart';
import 'package:odewa_bo/pages/users/models/user_model.dart';
import 'package:odewa_bo/pages/users/services/users_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsersController extends GetxController {
  final UsersService _usersService = Get.find<UsersService>();
  final RxList<User> allUsers = <User>[].obs;

  final RxInt currentPage = 1.obs;
  final RxInt itemsPerPage = 25.obs;

  final RxBool isLoading = false.obs;

  @override
  void onInit() async {
    await getUsers();
    super.onInit();
  }

  List<User> get paginatedUsers {
    final startIndex = (currentPage.value - 1) * itemsPerPage.value;
    // final endIndex = startIndex + itemsPerPage.value;
    return allUsers.skip(startIndex).take(itemsPerPage.value).toList();
  }

  int get totalPages => (allUsers.length / itemsPerPage.value).ceil();

  void nextPage() {
    if (currentPage.value < totalPages) {
      currentPage.value++;
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
    }
  }

  void setItemsPerPage(int value) {
    itemsPerPage.value = value;
    currentPage.value = 1; // Reset to first page when changing items per page
  }

  var columns = const [
    DataColumn(label: Text('Nombre', style: AppTheme.titleTable)),
    DataColumn(label: Text('Email', style: AppTheme.titleTable)),
    DataColumn(label: Text('Rol', style: AppTheme.titleTable)),
    DataColumn(label: Text('Acciones', style: AppTheme.titleTable)),
  ];

  Future<(bool, String)> addUser(Map<String, dynamic> newUser) async {
    final (success, message) = await _usersService.createUser(newUser);
    if (success) {
      await getUsers();
    }
    return (success, message);
  }

  Future<void> getUsers() async {
    isLoading.value = true;
    final (success, users) = await _usersService.getUsers();
    if (success) {
      allUsers.value = users;
    }
    isLoading.value = false;
  }

  Future<(bool, String)> updateUser(User updatedUser) async {
    final (success, message) = await _usersService.updateUser(updatedUser);
    if (success) {
      await getUsers();
    }
    return (success, message);
  }

  Future<(bool, String)> deleteUser(String userEmail) async {
    final (success, message) = await _usersService.deleteUser(userEmail);
    if (success) {
      await getUsers();
    }
    return (success, message);
  }

  Future<(bool, String)> changePassword(
    String userEmail,
    String password,
  ) async {
    return await _usersService.changePassword(userEmail, password);
  }
}
