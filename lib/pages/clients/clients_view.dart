import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/navigation_controller.dart';
import '../../routing/routes.dart';
import '../../widgets/loading.dart';
import '../../helpers/responsiveness.dart';
import '../../helpers/scaffold_helper.dart';
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

                // Información adicional del usuario
                ResponsiveWidget.isSmallScreen(context)
                    ? Column(
                      children: [
                        _InfoCard(
                          icon: Icons.badge,
                          label: 'Documento',
                          value: client.document,
                          color: Colors.orange.shade400,
                        ),
                        const SizedBox(height: 12),
                        _InfoCard(
                          icon: Icons.email,
                          label: 'Email',
                          value: client.email ?? 'No especificado',
                          color: Colors.purple.shade400,
                        ),
                        const SizedBox(height: 12),
                        _InfoCard(
                          icon: Icons.phone,
                          label: 'Teléfono',
                          value:
                              client.phone != null && client.phone!.isNotEmpty
                                  ? client.phone!
                                  : 'No registrado',
                          color: Colors.green.shade400,
                        ),
                        const SizedBox(height: 12),
                        _InfoCard(
                          icon: Icons.business,
                          label: 'Empresa',
                          value:
                              client.company != null &&
                                      client.company!.name.isNotEmpty
                                  ? client.company!.name
                                  : 'No especificada',
                          color: Colors.indigo.shade400,
                        ),
                      ],
                    )
                    : Column(
                      children: [
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
                                value: client.email ?? 'No especificado',
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
                                    client.phone != null &&
                                            client.phone!.isNotEmpty
                                        ? client.phone!
                                        : 'No registrado',
                                color: Colors.green.shade400,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _InfoCard(
                                icon: Icons.business,
                                label: 'Empresa',
                                value:
                                    client.company != null &&
                                            client.company!.name.isNotEmpty
                                        ? client.company!.name
                                        : 'No especificada',
                                color: Colors.indigo.shade400,
                              ),
                            ),
                          ],
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
      builder: (context) => ClientFormModal(client: client),
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
                    leading:
                        ResponsiveWidget.isSmallScreen(context)
                            ? IconButton(
                              icon: const Icon(Icons.menu),
                              color: Colors.blue.shade800,
                              onPressed: () {
                                ScaffoldHelper.openParentDrawer(context);
                              },
                            )
                            : null,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        'Usuarios del Sistema',
                        style: TextStyle(
                          color: Colors.blue.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize:
                              ResponsiveWidget.isSmallScreen(context) ? 18 : 24,
                        ),
                      ),
                      centerTitle: true,
                    ),
                    actions: [
                      ResponsiveWidget.isSmallScreen(context)
                          ? IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: () => clientController.fetchClients(),
                            tooltip: 'Actualizar',
                          )
                          : _ModernActionButton(
                            icon: Icons.refresh,
                            label: 'Actualizar',
                            color: Colors.blue.shade400,
                            onPressed: () {
                              clientController.fetchClients();
                            },
                          ),
                      if (!ResponsiveWidget.isSmallScreen(context))
                        const SizedBox(width: 12),
                      ResponsiveWidget.isSmallScreen(context)
                          ? IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () async {
                              loading(context);
                              Get.back();
                              _showClientModal(context, clientController);
                            },
                            tooltip: 'Crear Usuario',
                          )
                          : _ModernActionButton(
                            icon: Icons.add,
                            label: 'Crear Usuario',
                            color: Colors.green.shade400,
                            onPressed: () async {
                              loading(context);
                              Get.back();
                              _showClientModal(context, clientController);
                            },
                          ),
                      if (!ResponsiveWidget.isSmallScreen(context))
                        const SizedBox(width: 16),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(
                        ResponsiveWidget.isSmallScreen(context) ? 12 : 24,
                      ),
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
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.filter_list,
                                      color: Colors.blue.shade600,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Filtros',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade800,
                                      ),
                                    ),
                                    const Spacer(),
                                    Obx(() {
                                      if (clientController.hasActiveFilters) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade100,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            'Filtros activos',
                                            style: TextStyle(
                                              color: Colors.blue.shade700,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    }),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Indicador de filtros activos
                                Obx(() {
                                  if (clientController.hasActiveFilters) {
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.blue.shade200,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.info_outline,
                                            color: Colors.blue.shade600,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              clientController
                                                  .activeFiltersDescription,
                                              style: TextStyle(
                                                color: Colors.blue.shade800,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                }),

                                // Filtros
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Búsqueda general
                                    TextField(
                                      onChanged: (value) {
                                        clientController.searchQuery.value =
                                            value;
                                      },
                                      decoration: InputDecoration(
                                        hintText:
                                            'Buscar por nombre, apellido...',
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: Colors.blue.shade400,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    // Filtros responsive
                                    ResponsiveWidget.isSmallScreen(context)
                                        ? Column(
                                          children: [
                                            TextField(
                                              onChanged:
                                                  clientController
                                                      .updateDocumentFilter,
                                              decoration: InputDecoration(
                                                labelText: 'Documento',
                                                prefixIcon: Icon(
                                                  Icons.badge,
                                                  color: Colors.blue.shade400,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            TextField(
                                              onChanged:
                                                  clientController
                                                      .updateEmailFilter,
                                              decoration: InputDecoration(
                                                labelText: 'Email',
                                                prefixIcon: Icon(
                                                  Icons.email,
                                                  color: Colors.blue.shade400,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Obx(
                                              () => DropdownButtonFormField<
                                                bool?
                                              >(
                                                value:
                                                    clientController
                                                        .isActiveFilter
                                                        .value,
                                                decoration: InputDecoration(
                                                  labelText: 'Estado',
                                                  prefixIcon: Icon(
                                                    Icons.toggle_on,
                                                    color: Colors.blue.shade400,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                ),
                                                items: const [
                                                  DropdownMenuItem(
                                                    value: null,
                                                    child: Text('Todos'),
                                                  ),
                                                  DropdownMenuItem(
                                                    value: true,
                                                    child: Text('Activos'),
                                                  ),
                                                  DropdownMenuItem(
                                                    value: false,
                                                    child: Text('Inactivos'),
                                                  ),
                                                ],
                                                onChanged: (value) {
                                                  clientController
                                                      .updateIsActiveFilter(
                                                        value,
                                                      );
                                                },
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Obx(
                                              () => DropdownButtonFormField<
                                                String
                                              >(
                                                value:
                                                    clientController
                                                            .companyIdFilter
                                                            .value
                                                            .isEmpty
                                                        ? null
                                                        : clientController
                                                            .companyIdFilter
                                                            .value,
                                                decoration: InputDecoration(
                                                  labelText: 'Empresa',
                                                  prefixIcon: Icon(
                                                    Icons.business,
                                                    color: Colors.blue.shade400,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                ),
                                                items: [
                                                  const DropdownMenuItem(
                                                    value: null,
                                                    child: Text('Todas'),
                                                  ),
                                                  ...clientController.companies
                                                      .map(
                                                        (company) =>
                                                            DropdownMenuItem(
                                                              value: company.id,
                                                              child: Text(
                                                                company.name,
                                                              ),
                                                            ),
                                                      ),
                                                ],
                                                onChanged: (value) {
                                                  clientController
                                                      .updateCompanyIdFilter(
                                                        value ?? '',
                                                      );
                                                },
                                              ),
                                            ),
                                          ],
                                        )
                                        : Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: TextField(
                                                    onChanged:
                                                        clientController
                                                            .updateDocumentFilter,
                                                    decoration: InputDecoration(
                                                      labelText: 'Documento',
                                                      prefixIcon: Icon(
                                                        Icons.badge,
                                                        color:
                                                            Colors
                                                                .blue
                                                                .shade400,
                                                      ),
                                                      border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: TextField(
                                                    onChanged:
                                                        clientController
                                                            .updateEmailFilter,
                                                    decoration: InputDecoration(
                                                      labelText: 'Email',
                                                      prefixIcon: Icon(
                                                        Icons.email,
                                                        color:
                                                            Colors
                                                                .blue
                                                                .shade400,
                                                      ),
                                                      border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Obx(
                                                    () => DropdownButtonFormField<
                                                      bool?
                                                    >(
                                                      value:
                                                          clientController
                                                              .isActiveFilter
                                                              .value,
                                                      decoration: InputDecoration(
                                                        labelText: 'Estado',
                                                        prefixIcon: Icon(
                                                          Icons.toggle_on,
                                                          color:
                                                              Colors
                                                                  .blue
                                                                  .shade400,
                                                        ),
                                                        border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                        ),
                                                      ),
                                                      items: const [
                                                        DropdownMenuItem(
                                                          value: null,
                                                          child: Text('Todos'),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: true,
                                                          child: Text(
                                                            'Activos',
                                                          ),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: false,
                                                          child: Text(
                                                            'Inactivos',
                                                          ),
                                                        ),
                                                      ],
                                                      onChanged: (value) {
                                                        clientController
                                                            .updateIsActiveFilter(
                                                              value,
                                                            );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: Obx(
                                                    () => DropdownButtonFormField<
                                                      String
                                                    >(
                                                      value:
                                                          clientController
                                                                  .companyIdFilter
                                                                  .value
                                                                  .isEmpty
                                                              ? null
                                                              : clientController
                                                                  .companyIdFilter
                                                                  .value,
                                                      decoration: InputDecoration(
                                                        labelText: 'Empresa',
                                                        prefixIcon: Icon(
                                                          Icons.business,
                                                          color:
                                                              Colors
                                                                  .blue
                                                                  .shade400,
                                                        ),
                                                        border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                        ),
                                                      ),
                                                      items: [
                                                        const DropdownMenuItem(
                                                          value: null,
                                                          child: Text('Todas'),
                                                        ),
                                                        ...clientController
                                                            .companies
                                                            .map(
                                                              (company) =>
                                                                  DropdownMenuItem(
                                                                    value:
                                                                        company
                                                                            .id,
                                                                    child: Text(
                                                                      company
                                                                          .name,
                                                                    ),
                                                                  ),
                                                            ),
                                                      ],
                                                      onChanged: (value) {
                                                        clientController
                                                            .updateCompanyIdFilter(
                                                              value ?? '',
                                                            );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                    const SizedBox(height: 16),

                                    // Botones de acción
                                    ResponsiveWidget.isSmallScreen(context)
                                        ? Column(
                                          children: [
                                            SizedBox(
                                              width: double.infinity,
                                              child: OutlinedButton.icon(
                                                onPressed: () {
                                                  clientController
                                                      .clearAllFilters();
                                                },
                                                icon: Icon(
                                                  Icons.clear_all,
                                                  color: Colors.red.shade600,
                                                  size: 18,
                                                ),
                                                label: Text(
                                                  'Limpiar Filtros',
                                                  style: TextStyle(
                                                    color: Colors.red.shade600,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                style: OutlinedButton.styleFrom(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 12,
                                                      ),
                                                  side: BorderSide(
                                                    color: Colors.red.shade400,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton.icon(
                                                onPressed: () {
                                                  clientController
                                                      .applyFilters();
                                                },
                                                icon: const Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                                label: const Text(
                                                  'Aplicar Filtros',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.blue.shade600,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 12,
                                                      ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                  elevation: 2,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                        : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            OutlinedButton.icon(
                                              onPressed: () {
                                                clientController
                                                    .clearAllFilters();
                                              },
                                              icon: Icon(
                                                Icons.clear_all,
                                                color: Colors.red.shade600,
                                                size: 18,
                                              ),
                                              label: Text(
                                                'Limpiar Filtros',
                                                style: TextStyle(
                                                  color: Colors.red.shade600,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              style: OutlinedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 12,
                                                    ),
                                                side: BorderSide(
                                                  color: Colors.red.shade400,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            ElevatedButton.icon(
                                              onPressed: () {
                                                clientController.applyFilters();
                                              },
                                              icon: const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                              label: const Text(
                                                'Aplicar Filtros',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.blue.shade600,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 12,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                elevation: 2,
                                              ),
                                            ),
                                          ],
                                        ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Lista de usuarios
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
                                      Text('Cargando usuarios...'),
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
                                        'No hay usuarios registrados',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Crea el primer usuario para comenzar',
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
                                      'Usuarios Registrados',
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
                                        '${clients.length} usuarios',
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
    final isSmallScreen = ResponsiveWidget.isSmallScreen(Get.context!);

    return Obx(() {
      return isSmallScreen
          ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                      child: Obx(
                        () => DropdownButton<int>(
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
                              controller.setLimit(newValue);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('por página'),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                            ? () => controller.setPage(
                              controller.currentPage.value - 1,
                            )
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
                      '${controller.currentPage.value}/${controller.totalPages.value}',
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
                          controller.currentPage.value <
                                  controller.totalPages.value
                              ? Colors.blue.shade600
                              : Colors.grey.shade400,
                    ),
                    onPressed:
                        controller.currentPage.value <
                                controller.totalPages.value
                            ? () => controller.setPage(
                              controller.currentPage.value + 1,
                            )
                            : null,
                  ),
                ],
              ),
            ],
          )
          : Row(
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
                      child: Obx(
                        () => DropdownButton<int>(
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
                              controller.setLimit(newValue);
                            }
                          },
                        ),
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
                            ? () => controller.setPage(
                              controller.currentPage.value - 1,
                            )
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
                          controller.currentPage.value <
                                  controller.totalPages.value
                              ? Colors.blue.shade600
                              : Colors.grey.shade400,
                    ),
                    onPressed:
                        controller.currentPage.value <
                                controller.totalPages.value
                            ? () => controller.setPage(
                              controller.currentPage.value + 1,
                            )
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
