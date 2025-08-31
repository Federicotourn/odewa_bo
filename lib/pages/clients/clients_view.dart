import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/navigation_controller.dart';
import '../../routing/routes.dart';
import '../../widgets/loading.dart';
import 'components/client_form_modal.dart';
import 'controllers/client_controller.dart';
import 'models/client_model.dart';

class ClientsView extends StatelessWidget {
  const ClientsView({super.key});

  Widget _buildClientCard(
    Client client,
    ClientController controller,
    BuildContext context,
  ) {
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
                // Header con información del empleado
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
                            '${client.firstName} ${client.lastName}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      client.isActive == true
                                          ? Colors.green.shade100
                                          : Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  client.isActive == true
                                      ? 'Activo'
                                      : 'Inactivo',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        client.isActive == true
                                            ? Colors.green.shade700
                                            : Colors.red.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Información adicional del empleado
                Row(
                  children: [
                    Expanded(
                      child: _InfoCard(
                        icon: Icons.badge,
                        label: 'Documento',
                        value: client.document,
                        color: Colors.orange.shade400,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _InfoCard(
                        icon: Icons.email,
                        label: 'Email',
                        value: client.email,
                        color: Colors.purple.shade400,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _InfoCard(
                        icon: Icons.phone,
                        label: 'Teléfono',
                        value:
                            client.phone != null && client.phone!.isNotEmpty
                                ? client.phone!
                                : 'No registrado',
                        color: Colors.green.shade400,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _InfoCard(
                        icon: Icons.account_balance,
                        label: 'Banco',
                        value:
                            client.bank != null && client.bank!.isNotEmpty
                                ? client.bank!
                                : 'No registrado',
                        color: Colors.indigo.shade400,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Acciones
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _CompactActionButton(
                      icon: Icons.visibility,
                      label: 'Ver Detalle',
                      color: Colors.teal.shade400,
                      onPressed: () {
                        final NavigationController navigationController =
                            Get.find<NavigationController>();
                        controller.selectClientForDetail(client);
                        navigationController.navigateTo(clientDetailPageRoute);
                      },
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

  void _showClientModal(
    BuildContext context,
    ClientController controller, {
    Client? client,
  }) {
    showDialog(
      context: context,
      builder:
          (context) => ClientFormModal(
            client: client,
            onSubmit: (Client newClient) {
              if (client != null) {
                controller.updateClient(newClient);
              } else {
                controller.createClient(newClient);
              }
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ClientController clientController = Get.put(ClientController());

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
                    Colors.purple.shade50,
                    Colors.indigo.shade50,
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
                        '👥 Empleados del Sistema',
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
                          clientController.fetchClients();
                        },
                      ),
                      const SizedBox(width: 12),
                      _ModernActionButton(
                        icon: Icons.add,
                        label: 'Crear Empleado',
                        color: Colors.green.shade400,
                        onPressed: () async {
                          loading(context);
                          Get.back();
                          _showClientModal(context, clientController);
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
                          // Lista de empleados
                          Obx(() {
                            if (clientController.isLoading.value) {
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
                                      Text('Cargando empleados...'),
                                    ],
                                  ),
                                ),
                              );
                            }

                            final clients = clientController.clients;
                            if (clients.isEmpty) {
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
                                        Icons.people_outlined,
                                        size: 64,
                                        color: Colors.grey.shade400,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No hay empleados registrados',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Crea el primer empleado para comenzar',
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
                                      'Empleados Registrados',
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
                                        '${clients.length} empleados',
                                        style: TextStyle(
                                          color: Colors.blue.shade700,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                ...clients.map(
                                  (client) => _buildClientCard(
                                    client,
                                    clientController,
                                    context,
                                  ),
                                ),
                              ],
                            );
                          }),

                          const SizedBox(height: 24),

                          // Controles de paginación
                          Obx(() {
                            final totalPages =
                                clientController.totalPages.value;

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
                              child: _buildPaginationControls(clientController),
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

  Widget _buildPaginationControls(ClientController controller) {
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
                    value: controller.limit,
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
                        controller.fetchClients();
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
                        ? () =>
                            controller.setPage(controller.currentPage.value - 1)
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
                  'Página ${controller.currentPage.value} de ${controller.totalPages.value}',
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
                      controller.currentPage.value < controller.totalPages.value
                          ? Colors.blue.shade600
                          : Colors.grey.shade400,
                ),
                onPressed:
                    controller.currentPage.value < controller.totalPages.value
                        ? () =>
                            controller.setPage(controller.currentPage.value + 1)
                        : null,
              ),
            ],
          ),
        ],
      );
    });
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
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 20),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
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
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 16),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
