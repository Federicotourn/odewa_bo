import 'package:odewa_bo/controllers/logged_user_controller.dart';
import 'package:odewa_bo/pages/users/controllers/users_controller.dart';
import 'package:odewa_bo/pages/users/models/user_model.dart';
import 'package:odewa_bo/pages/users/components/company_selection_components.dart';
import 'package:odewa_bo/widgets/confirmation_dialog.dart';
import 'package:odewa_bo/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsersView extends StatelessWidget {
  const UsersView({super.key});

  Widget _buildUserCard(
    User user,
    UsersController controller,
    BuildContext context,
  ) {
    // final LoggedUserController loggedUserController =
    //     Get.find<LoggedUserController>();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.grey.shade50],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con información del usuario
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.blue.shade600,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.fullName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                          ),
                          Text(
                            user.email,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Información adicional del usuario
                Row(
                  children: [
                    Expanded(
                      child: _InfoCard(
                        icon: Icons.email,
                        label: 'Email',
                        value: user.email,
                        color: Colors.blue.shade400,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _InfoCard(
                        icon: Icons.security,
                        label: 'Rol',
                        value:
                            user.role == 'admin' ? 'Administrador' : 'Cliente',
                        color:
                            user.role == 'admin'
                                ? Colors.purple.shade400
                                : Colors.orange.shade400,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _InfoCard(
                        icon: Icons.business,
                        label: 'Empresas',
                        value:
                            user.companies != null && user.companies!.isNotEmpty
                                ? '${user.companies!.length} empresa${user.companies!.length > 1 ? 's' : ''}'
                                : 'Sin empresas',
                        color: Colors.green.shade400,
                      ),
                    ),
                  ],
                ),

                // Lista de empresas si existen
                if (user.companies != null && user.companies!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Empresas asociadas:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children:
                              user.companies!.map((company) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    company.name,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // Acciones
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // if (loggedUserController.hasPermission('USER_UPDATE'))
                    _CompactActionButton(
                      icon: Icons.edit,
                      label: 'Editar',
                      color: Colors.blue.shade400,
                      onPressed: () async {
                        loading(context);
                        Get.back();
                        _showUserModal(context, controller, user: user);
                      },
                    ),
                    // if (loggedUserController.hasPermission('USER_UPDATE') &&
                    // loggedUserController.hasPermission('USER_DELETE'))
                    const SizedBox(width: 12),
                    // if (loggedUserController.hasPermission('USER_DELETE'))
                    _CompactActionButton(
                      icon: Icons.delete,
                      label: 'Eliminar',
                      color: Colors.red.shade400,
                      onPressed:
                          () => _showDeleteConfirmation(
                            context,
                            user,
                            controller,
                          ),
                    ),
                    // if (loggedUserController.hasPermission('USER_UPDATE'))
                    const SizedBox(width: 12),
                    // if (loggedUserController.hasPermission('USER_UPDATE'))
                    _CompactActionButton(
                      icon: Icons.lock,
                      label: 'Cambiar Contraseña',
                      color: Colors.orange.shade400,
                      onPressed:
                          () => _showChangePasswordModal(
                            context,
                            user,
                            controller,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showUserModal(
    BuildContext context,
    UsersController controller, {
    User? user,
  }) {
    late final LoggedUserController loggedUserController;
    try {
      loggedUserController = Get.find<LoggedUserController>();
    } catch (e) {
      loggedUserController = Get.put(LoggedUserController());
    }
    final isLoggedUserAdmin = loggedUserController.isAdmin;
    final isLoggedUserClient = loggedUserController.isClient;

    final nameController = TextEditingController(text: user?.firstName ?? '');
    final lastNameController = TextEditingController(
      text: user?.lastName ?? '',
    );
    final passwordController = TextEditingController(text: '');
    final emailController = TextEditingController(text: user?.email ?? '');

    // Role selector - default based on logged user's role
    String initialRole =
        user?.role ?? (isLoggedUserClient ? 'client' : 'admin');
    String selectedRole = initialRole;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Container(
                width: Get.width * 0.5,
                constraints: BoxConstraints(maxHeight: Get.height * 0.8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, Colors.grey.shade50],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header moderno con gradiente
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.blue.shade400,
                            Colors.indigo.shade400,
                          ],
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              user == null ? Icons.person_add : Icons.edit,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user == null
                                      ? (isLoggedUserAdmin
                                          ? 'Crear Nuevo Usuario'
                                          : 'Crear Nuevo Cliente')
                                      : 'Editar Usuario',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  user == null
                                      ? (isLoggedUserAdmin
                                          ? 'Define un nuevo usuario con sus permisos'
                                          : 'Define un nuevo cliente para tu empresa')
                                      : 'Modifica la información del usuario existente',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Contenido del modal
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Campo de nombre
                            _ModernTextField(
                              label: 'Nombre',
                              hint: 'Ej: Juan Pérez, María García',
                              controller: nameController,
                              icon: Icons.person,
                              isRequired: true,
                            ),

                            const SizedBox(height: 20),

                            // Campo de apellido
                            _ModernTextField(
                              label: 'Apellido',
                              hint: 'Ej: Pérez, García',
                              controller: lastNameController,
                              icon: Icons.person_outline,
                              isRequired: true,
                            ),

                            const SizedBox(height: 20),

                            // Campo de rol (solo si el usuario logueado es admin)
                            if (isLoggedUserAdmin)
                              _buildRoleSelector(selectedRole, (role) {
                                setState(() {
                                  if (role != null) {
                                    selectedRole = role;
                                  }
                                });
                              }),

                            if (isLoggedUserAdmin) const SizedBox(height: 20),

                            // Campo de email
                            _ModernTextField(
                              label: 'Email',
                              hint: 'usuario@ejemplo.com',
                              controller: emailController,
                              icon: Icons.email,
                              isRequired: true,
                              enabled: user == null,
                            ),

                            const SizedBox(height: 20),

                            // Campo de selección de empresas (solo si es admin o si el usuario a crear es admin)
                            if (isLoggedUserAdmin ||
                                (isLoggedUserClient && selectedRole == 'admin'))
                              _buildCompanySelection(controller, user),

                            // Si el usuario logueado es client, usar su empresa automáticamente
                            if (isLoggedUserClient &&
                                selectedRole == 'client') ...[
                              const SizedBox(height: 20),
                              _buildClientCompanyInfo(loggedUserController),
                            ],

                            const SizedBox(height: 20),

                            // Campo de contraseña (solo para usuarios nuevos)
                            if (user == null) ...[
                              _ModernTextField(
                                label: 'Contraseña',
                                hint: 'Ingresa una contraseña segura',
                                controller: passwordController,
                                icon: Icons.lock,
                                isRequired: true,
                                isPassword: true,
                              ),
                              const SizedBox(height: 20),
                            ],
                          ],
                        ),
                      ),
                    ),

                    // Footer con acciones
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _ModernOutlinedButton(
                            label: 'Cancelar',
                            icon: Icons.close,
                            onPressed: () => Navigator.pop(context),
                          ),
                          const SizedBox(width: 16),
                          _ModernElevatedButton(
                            label:
                                user == null
                                    ? (isLoggedUserAdmin
                                        ? 'Crear Usuario'
                                        : 'Crear Cliente')
                                    : 'Actualizar Usuario',
                            icon: user == null ? Icons.add : Icons.save,
                            onPressed: () async {
                              // Validaciones básicas
                              if (nameController.text.trim().isEmpty ||
                                  emailController.text.trim().isEmpty ||
                                  lastNameController.text.trim().isEmpty ||
                                  (user == null &&
                                      passwordController.text.isEmpty)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(
                                          Icons.warning,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Completa todos los campos obligatorios',
                                        ),
                                      ],
                                    ),
                                    backgroundColor: Colors.orange,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                );
                                return;
                              }

                              // Validar selección de empresas (solo para admin o si se crea admin)
                              if ((isLoggedUserAdmin ||
                                      selectedRole == 'admin') &&
                                  !controller.hasSelectedCompanies) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(
                                          Icons.warning,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Debes seleccionar al menos una empresa',
                                        ),
                                      ],
                                    ),
                                    backgroundColor: Colors.orange,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                );
                                return;
                              }

                              if (user == null) {
                                // Add new user
                                loading(context);

                                // Preparar datos del usuario
                                final Map<String, dynamic> userData = {
                                  'email': emailController.text.trim(),
                                  'firstName': nameController.text.trim(),
                                  'lastName': lastNameController.text.trim(),
                                  'password': passwordController.text,
                                  'role': selectedRole,
                                };

                                // Agregar companyIds según el role del usuario logueado
                                if (isLoggedUserAdmin ||
                                    selectedRole == 'admin') {
                                  // Admin puede seleccionar empresas
                                  userData['companyIds'] =
                                      controller.selectedCompanyIds.toList();
                                } else if (isLoggedUserClient &&
                                    selectedRole == 'client') {
                                  // Client solo puede crear en su propia empresa
                                  final loggedUser =
                                      loggedUserController.user.value;
                                  final companies = loggedUser?.companies;

                                  if (companies != null &&
                                      companies.isNotEmpty) {
                                    userData['companyIds'] = [
                                      companies.first.id,
                                    ];
                                  } else {
                                    Get.back();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          children: [
                                            Icon(
                                              Icons.error,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 8),
                                            const Text(
                                              'No se pudo determinar la empresa del usuario',
                                            ),
                                          ],
                                        ),
                                        backgroundColor: Colors.red,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                }

                                final (success, message) = await controller
                                    .addUser(userData);
                                Get.back();
                                if (success) {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(message),
                                        ],
                                      ),
                                      backgroundColor: Colors.green,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        children: [
                                          Icon(
                                            Icons.error,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(message),
                                        ],
                                      ),
                                      backgroundColor: Colors.red,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                // Update existing user
                                loading(context);
                                // Get selected companies
                                final selectedCompanies =
                                    controller.getSelectedCompanies();
                                final updatedUser = user.copyWith(
                                  email: emailController.text.trim(),
                                  firstName: nameController.text.trim(),
                                  lastName: lastNameController.text.trim(),
                                  companies: selectedCompanies,
                                );
                                final (success, message) = await controller
                                    .updateUser(updatedUser);
                                Get.back();
                                if (success) {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(message),
                                        ],
                                      ),
                                      backgroundColor: Colors.green,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        children: [
                                          Icon(
                                            Icons.error,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(message),
                                        ],
                                      ),
                                      backgroundColor: Colors.red,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    User user,
    UsersController controller,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => ConfirmationDialog(
            title: 'Eliminar Administrador',
            message: '¿Estás seguro que deseas eliminar a ${user.fullName}?',
            onConfirm: () async {
              loading(context);
              final (success, message) = await controller.deleteUser(
                user.email,
              );
              Get.back();
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(message),
                      ],
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.error, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(message),
                      ],
                    ),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }
            },
            onCancel: () => Navigator.of(context).pop(),
          ),
    );
  }

  void _showChangePasswordModal(
    BuildContext context,
    User user,
    UsersController controller,
  ) {
    final passwordController = TextEditingController(text: '');
    final confirmPasswordController = TextEditingController(text: '');
    final passwordIsVisible = false.obs;
    final confirmPasswordIsVisible = false.obs;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Cambiar contraseña'),
            content: Obx(
              () => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordIsVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          passwordIsVisible.value = !passwordIsVisible.value;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirmar contraseña',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          confirmPasswordIsVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          confirmPasswordIsVisible.value =
                              !confirmPasswordIsVisible.value;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  if (passwordController.text ==
                      confirmPasswordController.text) {
                    loading(context);
                    final (success, message) = await controller.changePassword(
                      user.email,
                      passwordController.text,
                    );
                    Get.back();
                    if (success) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.white),
                              const SizedBox(width: 8),
                              Text(message),
                            ],
                          ),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.error, color: Colors.white),
                              const SizedBox(width: 8),
                              Text(message),
                            ],
                          ),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Las contraseñas no coinciden'),
                      ),
                    );
                  }
                },
                child: const Text('Cambiar contraseña'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final UsersController usersController = Get.put(UsersController());
    // final LoggedUserController loggedUserController =
    //     Get.find<LoggedUserController>();

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.shade50,
                    Colors.indigo.shade50,
                    Colors.purple.shade50,
                  ],
                ),
              ),
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 120,
                    floating: false,
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        'Administradores del Sistema',
                        style: TextStyle(
                          color: Colors.blue.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      centerTitle: true,
                    ),
                    actions: [
                      _ModernActionButton(
                        icon: Icons.refresh,
                        label: 'Actualizar',
                        color: Colors.blue.shade400,
                        onPressed: () {
                          usersController.getUsers();
                        },
                      ),
                      const SizedBox(width: 12),
                      _ModernActionButton(
                        icon: Icons.add,
                        label: 'Agregar Administrador',
                        color: Colors.green.shade400,
                        onPressed: () {
                          _showUserModal(context, usersController);
                        },
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          // Lista de usuarios
                          Obx(() {
                            if (usersController.isLoading.value) {
                              return Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(height: 16),
                                      Text('Cargando administradores...'),
                                    ],
                                  ),
                                ),
                              );
                            }

                            final users = usersController.paginatedUsers;
                            if (users.isEmpty) {
                              return Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.people_outline,
                                        size: 64,
                                        color: Colors.grey.shade400,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No hay administradores registrados',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Crea el primer administrador para comenzar',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.list,
                                      color: Colors.blue.shade600,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Administradores Registrados',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade800,
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade100,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        '${users.length} administradores',
                                        style: TextStyle(
                                          color: Colors.blue.shade700,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                ...users.map(
                                  (user) => _buildUserCard(
                                    user,
                                    usersController,
                                    context,
                                  ),
                                ),
                              ],
                            );
                          }),

                          const SizedBox(height: 24),

                          // Controles de paginación
                          Obx(() {
                            final totalPages = usersController.totalPages;

                            if (totalPages <= 1) return const SizedBox.shrink();

                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(20),
                              child: _buildPaginationControls(usersController),
                            );
                          }),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationControls(UsersController controller) {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text('Mostrar'),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade50,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: controller.itemsPerPage.value,
                    items:
                        [10, 25, 50, 100].map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text('$value'),
                            ),
                          );
                        }).toList(),
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        controller.setItemsPerPage(newValue);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text('registros por página'),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  color:
                      controller.currentPage.value > 1
                          ? Colors.blue.shade600
                          : Colors.grey.shade400,
                ),
                onPressed:
                    controller.currentPage.value > 1
                        ? controller.previousPage
                        : null,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Página ${controller.currentPage.value} de ${controller.totalPages}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color:
                      controller.currentPage.value < controller.totalPages
                          ? Colors.blue.shade600
                          : Colors.grey.shade400,
                ),
                onPressed:
                    controller.currentPage.value < controller.totalPages
                        ? controller.nextPage
                        : null,
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildRoleSelector(String? selectedRole, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.security, size: 20, color: Colors.blue.shade600),
            const SizedBox(width: 8),
            Text(
              'Rol',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '*',
              style: TextStyle(
                color: Colors.red.shade400,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: selectedRole,
            decoration: InputDecoration(
              hintText: 'Selecciona un rol',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
            items: const [
              DropdownMenuItem<String>(
                value: 'admin',
                child: Text('Administrador'),
              ),
              DropdownMenuItem<String>(value: 'client', child: Text('Cliente')),
            ],
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildClientCompanyInfo(LoggedUserController loggedUserController) {
    // Obtener la empresa del usuario logueado directamente desde el controller
    final loggedUser = loggedUserController.user.value;
    final companies = loggedUser?.companies;

    final companyName =
        companies != null && companies.isNotEmpty
            ? companies.first.name
            : 'Empresa asignada';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.business, color: Colors.blue.shade600, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Empresa',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  companyName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade800,
                  ),
                ),
                Text(
                  'El usuario se creará automáticamente en esta empresa',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanySelection(UsersController controller, User? user) {
    // Initialize selected companies if editing
    if (user != null && user.companies != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.setSelectedCompanies(
          user.companies!.map((company) => company.id).toList(),
        );
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.business, size: 20, color: Colors.blue.shade600),
            const SizedBox(width: 8),
            Text(
              'Empresas',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '*',
              style: TextStyle(
                color: Colors.red.shade400,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Selecciona las empresas a las que pertenece este usuario (mínimo 1):',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 12),

        // Company selection content
        Obx(() {
          if (controller.isLoadingCompanies.value) {
            return Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }

          if (controller.companies.isEmpty) {
            return Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('No hay empresas disponibles'),
                ),
              ),
            );
          }

          return _buildDropdownView(controller);
        }),

        const SizedBox(height: 8),
        Obx(() {
          final selectedCount = controller.selectedCompanyIds.length;
          return Text(
            selectedCount == 0
                ? 'Selecciona al menos una empresa'
                : '$selectedCount empresa${selectedCount > 1 ? 's' : ''} seleccionada${selectedCount > 1 ? 's' : ''}',
            style: TextStyle(
              fontSize: 12,
              color:
                  selectedCount == 0
                      ? Colors.red.shade600
                      : Colors.green.shade600,
              fontWeight: FontWeight.w500,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDropdownView(UsersController controller) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // Header with select all/deselect all buttons
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Vista Dropdown',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ActionButton(
                        button: 'Todas',
                        label: 'Todas',
                        onPressed: controller.selectAllCompanies,
                        color: Colors.blue.shade600,
                        isSmall: true,
                      ),
                      const SizedBox(width: 8),
                      ActionButton(
                        button: 'Ninguna',
                        label: 'Ninguna',
                        onPressed: controller.deselectAllCompanies,
                        color: Colors.grey.shade600,
                        isSmall: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Dropdown content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children:
                    controller.companies.map((company) {
                      final isSelected = controller.isCompanySelected(
                        company.id,
                      );

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          onTap:
                              () =>
                                  controller.toggleCompanySelection(company.id),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? Colors.blue.shade50
                                      : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? Colors.blue.shade300
                                        : Colors.grey.shade300,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  color:
                                      isSelected
                                          ? Colors.blue.shade600
                                          : Colors.grey.shade400,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        company.name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                              isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.normal,
                                          color:
                                              isSelected
                                                  ? Colors.blue.shade700
                                                  : Colors.grey.shade700,
                                        ),
                                      ),
                                      Text(
                                        '${company.employeeCount} empleados',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// COMPONENTES MODERNOS

class _ModernActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ModernActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _CompactActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

// COMPONENTES MODERNOS PARA EL MODAL

class _ModernTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData icon;
  final bool isRequired;
  final bool enabled;
  final bool isPassword;

  const _ModernTextField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.icon,
    this.isRequired = false,
    this.enabled = true,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.blue.shade600),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              Text(
                '*',
                style: TextStyle(
                  color: Colors.red.shade400,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            enabled: enabled,
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
              ),
              filled: true,
              fillColor: enabled ? Colors.white : Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ModernOutlinedButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _ModernOutlinedButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.grey.shade700,
          side: BorderSide(color: Colors.grey.shade300),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Colors.grey.shade700),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _ModernElevatedButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _ModernElevatedButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade400,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
