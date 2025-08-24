import 'package:odewa_bo/controllers/navigation_controller.dart';
import 'package:odewa_bo/pages/requests/controllers/request_controller.dart';
import 'package:odewa_bo/pages/requests/models/request_model.dart';
import 'package:odewa_bo/controllers/logged_user_controller.dart';
import 'package:odewa_bo/routing/routes.dart';

import 'package:odewa_bo/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestsView extends StatelessWidget {
  const RequestsView({super.key});

  Widget _buildRequestCard(
    OdewaRequest request,
    RequestController controller,
    BuildContext context,
  ) {
    final LoggedUserController loggedUserController =
        Get.find<LoggedUserController>();
    final NavigationController navigationController =
        Get.find<NavigationController>();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
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
                // Header con información de la solicitud
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: RequestStatus.getColor(
                          request.status,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.request_page,
                        color: RequestStatus.getColor(request.status),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Solicitud #${request.id.substring(0, 8)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal.shade800,
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
                                  color: RequestStatus.getColor(
                                    request.status,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  RequestStatus.getLabel(request.status),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: RequestStatus.getColor(
                                      request.status,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      request.isActive
                                          ? Colors.green.shade100
                                          : Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  request.isActive ? 'Activa' : 'Inactiva',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        request.isActive
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

                // Información de la solicitud
                Row(
                  children: [
                    Expanded(
                      child: _InfoCard(
                        icon: Icons.attach_money,
                        label: 'Monto',
                        value: '\$${request.amount}',
                        color: Colors.green.shade400,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _InfoCard(
                        icon: Icons.calendar_today,
                        label: 'Fecha',
                        value: request.date,
                        color: Colors.blue.shade400,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Información del cliente
                if (request.client != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.amber.shade600,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cliente: ${request.client!.fullName}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.amber.shade800,
                                ),
                              ),
                              Text(
                                'Documento: ${request.client!.document}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.amber.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Acciones
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _CompactActionButton(
                      icon: Icons.visibility,
                      label: 'Ver Detalle',
                      color: Colors.teal.shade400,
                      onPressed: () {
                        // Seleccionar la solicitud en el controller
                        controller.selectRequestForDetail(request);
                        // Navegar a la vista detallada usando el router
                        navigationController.navigateTo(requestDetailPageRoute);
                      },
                    ),
                    // _CompactActionButton(
                    //   icon: Icons.edit,
                    //   label: 'Editar',
                    //   color: Colors.blue.shade400,
                    //   onPressed: () async {
                    //     loading(context);
                    //     Get.back();
                    //     _showRequestModal(
                    //       context,
                    //       controller,
                    //       request: request,
                    //     );
                    //   },
                    // ),
                    // const SizedBox(width: 12),
                    // _CompactActionButton(
                    //   icon: Icons.update,
                    //   label: 'Cambiar Estado',
                    //   color: Colors.orange.shade400,
                    //   onPressed:
                    //       () => _showStatusModal(context, controller, request),
                    // ),
                    // const SizedBox(width: 12),
                    // _CompactActionButton(
                    //   icon: request.isActive ? Icons.block : Icons.check_circle,
                    //   label: request.isActive ? 'Desactivar' : 'Activar',
                    //   color:
                    //       request.isActive
                    //           ? Colors.orange.shade400
                    //           : Colors.green.shade400,
                    //   onPressed: () => controller.toggleRequestStatus(request),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showRequestModal(
    BuildContext context,
    RequestController controller, {
    OdewaRequest? request,
  }) {
    final amountController = TextEditingController(text: request?.amount ?? '');
    final dateController = TextEditingController(text: request?.date ?? '');
    final clientIdController = TextEditingController(
      text: request?.clientId ?? '',
    );

    showDialog(
      context: context,
      builder: (context) {
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
                      colors: [Colors.teal.shade400, Colors.cyan.shade400],
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          request == null ? Icons.add : Icons.edit,
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
                              request == null
                                  ? 'Crear Nueva Solicitud'
                                  : 'Editar Solicitud',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              request == null
                                  ? 'Define una nueva solicitud con sus datos'
                                  : 'Modifica la información de la solicitud existente',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
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
                        // Campo de monto
                        _ModernTextField(
                          label: 'Monto',
                          hint: 'Ej: 500.00',
                          controller: amountController,
                          icon: Icons.attach_money,
                          isRequired: true,
                        ),

                        const SizedBox(height: 20),

                        // Campo de fecha
                        _ModernTextField(
                          label: 'Fecha',
                          hint: 'YYYY-MM-DD',
                          controller: dateController,
                          icon: Icons.calendar_today,
                          isRequired: true,
                        ),

                        const SizedBox(height: 20),

                        // Campo de ID del cliente
                        _ModernTextField(
                          label: 'ID del Cliente',
                          hint: 'UUID del cliente',
                          controller: clientIdController,
                          icon: Icons.person,
                          isRequired: true,
                        ),
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
                            request == null
                                ? 'Crear Solicitud'
                                : 'Actualizar Solicitud',
                        icon: request == null ? Icons.add : Icons.save,
                        onPressed: () async {
                          if (amountController.text.trim().isEmpty ||
                              dateController.text.trim().isEmpty ||
                              clientIdController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    Icon(Icons.warning, color: Colors.white),
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

                          if (request == null) {
                            // Create new request
                            loading(context);
                            controller.amountController.text =
                                amountController.text.trim();
                            controller.dateController.text =
                                dateController.text.trim();
                            controller.clientIdController.text =
                                clientIdController.text.trim();
                            await controller.createRequest();
                            Get.back();
                            Navigator.of(context).pop();
                          } else {
                            // Update existing request
                            loading(context);
                            controller.amountController.text =
                                amountController.text.trim();
                            controller.dateController.text =
                                dateController.text.trim();
                            controller.clientIdController.text =
                                clientIdController.text.trim();
                            await controller.updateRequest(request.id);
                            Get.back();
                            Navigator.of(context).pop();
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
  }

  void _showStatusModal(
    BuildContext context,
    RequestController controller,
    OdewaRequest request,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Cambiar Estado de Solicitud'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Estado actual: ${RequestStatus.getLabel(request.status)}',
                ),
                const SizedBox(height: 20),
                ...RequestStatus.allStatuses.map(
                  (status) => ListTile(
                    leading: Icon(
                      Icons.circle,
                      color: RequestStatus.getColor(status),
                    ),
                    title: Text(RequestStatus.getLabel(status)),
                    onTap: () {
                      controller.updateRequestStatus(request.id, status);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final RequestController requestsController = Get.put(RequestController());
    final LoggedUserController loggedUserController =
        Get.find<LoggedUserController>();

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
                    Colors.teal.shade50,
                    Colors.cyan.shade50,
                    Colors.blue.shade50,
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
                        '📋 Solicitudes del Sistema',
                        style: TextStyle(
                          color: Colors.teal.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      centerTitle: true,
                    ),
                    actions: [
                      // if (loggedUserController.hasPermission('REQUEST_CREATE'))
                      //   _ModernActionButton(
                      //     icon: Icons.add,
                      //     label: 'Crear Solicitud',
                      //     color: Colors.green.shade400,
                      //     onPressed: () async {
                      //       loading(context);
                      //       Get.back();
                      //       _showRequestModal(context, requestsController);
                      //     },
                      //   ),
                      const SizedBox(width: 12),
                      _ModernActionButton(
                        icon: Icons.refresh,
                        label: 'Actualizar',
                        color: Colors.teal.shade400,
                        onPressed: () {
                          requestsController.loadRequests();
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
                          // Filtros
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Filtros',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal.shade800,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextField(
                                      onChanged:
                                          requestsController.updateSearchQuery,
                                      decoration: InputDecoration(
                                        hintText:
                                            'Buscar por cliente, monto o fecha...',
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: Colors.teal.shade400,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    DropdownButtonFormField<String>(
                                      value:
                                          requestsController.statusFilter.value,
                                      decoration: InputDecoration(
                                        labelText: 'Estado',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      items: [
                                        DropdownMenuItem(
                                          value: 'all',
                                          child: Text('Todos'),
                                        ),
                                        ...RequestStatus.allStatuses.map(
                                          (status) => DropdownMenuItem(
                                            value: status,
                                            child: Text(
                                              RequestStatus.getLabel(status),
                                            ),
                                          ),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        if (value != null) {
                                          requestsController.updateStatusFilter(
                                            value,
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Lista de solicitudes
                          Obx(() {
                            if (requestsController.isLoading.value) {
                              return Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
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
                                      Text('Cargando solicitudes...'),
                                    ],
                                  ),
                                ),
                              );
                            }

                            final requests =
                                requestsController.filteredRequests;
                            if (requests.isEmpty) {
                              return Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
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
                                        Icons.request_page_outlined,
                                        size: 64,
                                        color: Colors.grey.shade400,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No hay solicitudes registradas',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Crea la primera solicitud para comenzar',
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
                                      color: Colors.teal.shade600,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Solicitudes Registradas',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal.shade800,
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.teal.shade100,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        '${requests.length} solicitudes',
                                        style: TextStyle(
                                          color: Colors.teal.shade700,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                ...requests.map(
                                  (request) => _buildRequestCard(
                                    request,
                                    requestsController,
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
                                requestsController.totalPagesValue;

                            if (totalPages <= 1) return const SizedBox.shrink();

                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(20),
                              child: _buildPaginationControls(
                                requestsController,
                              ),
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

  Widget _buildPaginationControls(RequestController controller) {
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
                    value: controller.limit.value,
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
                        controller.limit.value = newValue;
                        controller.loadRequests();
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
                          ? Colors.teal.shade600
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
                  color: Colors.teal.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Página ${controller.currentPage.value} de ${controller.totalPagesValue}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade700,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color:
                      controller.currentPage.value < controller.totalPagesValue
                          ? Colors.teal.shade600
                          : Colors.grey.shade400,
                ),
                onPressed:
                    controller.currentPage.value < controller.totalPagesValue
                        ? controller.nextPage
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
            color: color.withOpacity(0.3),
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
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
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
            color: color.withOpacity(0.2),
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
            Icon(icon, size: 20, color: Colors.teal.shade600),
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
                color: Colors.black.withOpacity(0.05),
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
                borderSide: BorderSide(color: Colors.teal.shade400, width: 2),
              ),
              filled: true,
              fillColor: enabled ? Colors.white : Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
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
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.grey.shade600, size: 20),
        label: Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: BorderSide.none,
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
            color: Colors.teal.shade400.withOpacity(0.3),
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
          backgroundColor: Colors.teal.shade400,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
