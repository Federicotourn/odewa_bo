import 'package:odewa_bo/controllers/navigation_controller.dart';
import 'package:odewa_bo/pages/requests/controllers/request_controller.dart';
import 'package:odewa_bo/pages/requests/models/request_model.dart';
import 'package:odewa_bo/controllers/logged_user_controller.dart';
import 'package:odewa_bo/routing/routes.dart';
import 'package:odewa_bo/pages/companies/models/company_model.dart';
import 'package:odewa_bo/pages/companies/services/company_service.dart';
import 'package:odewa_bo/helpers/responsiveness.dart';
import 'package:odewa_bo/helpers/scaffold_helper.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RequestsView extends StatelessWidget {
  const RequestsView({super.key});

  Widget _buildRequestCard(
    OdewaRequest request,
    RequestController controller,
    BuildContext context,
  ) {
    late final LoggedUserController loggedUserController;
    try {
      loggedUserController = Get.find<LoggedUserController>();
    } catch (e) {
      loggedUserController = Get.put(LoggedUserController());
    }
    final NavigationController navigationController =
        Get.find<NavigationController>();
    final isAdmin = loggedUserController.isAdmin;

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
                // Header con información de la solicitud
                ResponsiveWidget.isSmallScreen(Get.context!)
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: RequestStatus.getColor(
                                  request.status,
                                ).withValues(alpha: 0.1),
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
                              child: Text(
                                'Solicitud #${request.id.substring(0, 8)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: RequestStatus.getColor(
                                  request.status,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                RequestStatus.getLabel(request.status),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: RequestStatus.getColor(request.status),
                                ),
                              ),
                            ),
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
                    )
                    : Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: RequestStatus.getColor(
                              request.status,
                            ).withValues(alpha: 0.1),
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
                                      ).withValues(alpha: 0.1),
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

                ResponsiveWidget.isSmallScreen(Get.context!)
                    ? Column(
                      children: [
                        if (request.client != null) ...[
                          Container(
                            width: double.infinity,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                          const SizedBox(height: 12),
                        ],
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.amber.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.business,
                                color: Colors.amber.shade600,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Empresa: ${request.client?.company?.name ?? 'N/A'}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.amber.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                    : Row(
                      children: [
                        if (request.client != null) ...[
                          Expanded(
                            child: Container(
                              height: 75,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.amber.shade200,
                                ),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                          ),
                          const SizedBox(width: 16),
                        ],
                        Expanded(
                          child: Container(
                            height: 75,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.amber.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.business,
                                  color: Colors.amber.shade600,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Empresa: ${request.client?.company?.name ?? 'N/A'}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.amber.shade800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                const SizedBox(height: 16),

                // Información de la solicitud
                ResponsiveWidget.isSmallScreen(Get.context!)
                    ? Column(
                      children: [
                        _InfoCard(
                          icon: Icons.attach_money,
                          label: 'Monto',
                          value: '\$${request.amount}',
                          color: Colors.green.shade400,
                        ),
                        const SizedBox(height: 12),
                        _InfoCard(
                          icon: Icons.calendar_today,
                          label: 'Fecha',
                          value: DateFormat(
                            'dd/MM/yyyy',
                          ).format(DateTime.parse(request.date)),
                          color: Colors.blue.shade400,
                        ),
                      ],
                    )
                    : Row(
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
                            value: DateFormat(
                              'dd/MM/yyyy',
                            ).format(DateTime.parse(request.date)),
                            color: Colors.blue.shade400,
                          ),
                        ),
                      ],
                    ),

                const SizedBox(height: 16),

                // Acciones (solo para admins)
                if (isAdmin)
                  ResponsiveWidget.isSmallScreen(Get.context!)
                      ? SizedBox(
                        width: double.infinity,
                        child: _CompactActionButton(
                          icon: Icons.visibility,
                          label: 'Ver Detalle',
                          color: Colors.teal.shade400,
                          onPressed: () {
                            // Seleccionar la solicitud en el controller
                            controller.selectRequestForDetail(request);
                            // Navegar a la vista detallada usando el router
                            navigationController.navigateTo(
                              requestDetailPageRoute,
                            );
                          },
                        ),
                      )
                      : Row(
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
                              navigationController.navigateTo(
                                requestDetailPageRoute,
                              );
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

  @override
  Widget build(BuildContext context) {
    final RequestController requestsController = Get.put(RequestController());
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
                    leading:
                        ResponsiveWidget.isSmallScreen(context)
                            ? IconButton(
                              icon: const Icon(Icons.menu),
                              color: Colors.teal.shade800,
                              onPressed: () {
                                ScaffoldHelper.openParentDrawer(context);
                              },
                            )
                            : null,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        'Solicitudes del Sistema',
                        style: TextStyle(
                          color: Colors.teal.shade800,
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
                            onPressed: () => requestsController.loadRequests(),
                            tooltip: 'Actualizar',
                          )
                          : _ModernActionButton(
                            icon: Icons.refresh,
                            label: 'Actualizar',
                            color: Colors.teal.shade400,
                            onPressed: () {
                              requestsController.loadRequests();
                            },
                          ),
                      if (!ResponsiveWidget.isSmallScreen(context))
                        const SizedBox(width: 12),
                      ResponsiveWidget.isSmallScreen(context)
                          ? Obx(
                            () => IconButton(
                              icon: Icon(
                                requestsController.isLoading.value
                                    ? Icons.hourglass_empty
                                    : Icons.download,
                              ),
                              onPressed:
                                  requestsController.isLoading.value
                                      ? null
                                      : () =>
                                          requestsController.exportRequests(),
                              tooltip:
                                  requestsController.isLoading.value
                                      ? 'Exportando...'
                                      : 'Exportar',
                            ),
                          )
                          : Obx(
                            () => _ModernActionButton(
                              icon:
                                  requestsController.isLoading.value
                                      ? Icons.hourglass_empty
                                      : Icons.download,
                              label:
                                  requestsController.isLoading.value
                                      ? 'Exportando...'
                                      : 'Exportar',
                              color:
                                  requestsController.isLoading.value
                                      ? Colors.grey.shade400
                                      : Colors.blue.shade400,
                              onPressed:
                                  requestsController.isLoading.value
                                      ? () {}
                                      : () {
                                        requestsController.exportRequests();
                                      },
                            ),
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
                                ResponsiveWidget.isSmallScreen(context)
                                    ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.filter_list,
                                              color: Colors.teal.shade600,
                                              size: 24,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                'Filtros',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.teal.shade800,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Obx(() {
                                          if (requestsController
                                              .hasActiveFilters) {
                                            return Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.teal.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                'Filtros activos',
                                                style: TextStyle(
                                                  color: Colors.teal.shade700,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            );
                                          }
                                          return const SizedBox.shrink();
                                        }),
                                      ],
                                    )
                                    : Row(
                                      children: [
                                        Icon(
                                          Icons.filter_list,
                                          color: Colors.teal.shade600,
                                          size: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'Filtros',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.teal.shade800,
                                          ),
                                        ),
                                        const Spacer(),
                                        Obx(() {
                                          if (requestsController
                                              .hasActiveFilters) {
                                            return Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.teal.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                'Filtros activos',
                                                style: TextStyle(
                                                  color: Colors.teal.shade700,
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
                                  if (requestsController.hasActiveFilters) {
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.teal.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.teal.shade200,
                                        ),
                                      ),
                                      child:
                                          ResponsiveWidget.isSmallScreen(
                                                context,
                                              )
                                              ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.info_outline,
                                                        color:
                                                            Colors
                                                                .teal
                                                                .shade600,
                                                        size: 16,
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: Text(
                                                          requestsController
                                                              .activeFiltersDescription,
                                                          style: TextStyle(
                                                            color:
                                                                Colors
                                                                    .teal
                                                                    .shade800,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  SizedBox(
                                                    width: double.infinity,
                                                    child: TextButton(
                                                      onPressed:
                                                          () =>
                                                              requestsController
                                                                  .clearAllFilters(),
                                                      child: Text(
                                                        'Limpiar',
                                                        style: TextStyle(
                                                          color:
                                                              Colors
                                                                  .teal
                                                                  .shade600,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                              : Row(
                                                children: [
                                                  Icon(
                                                    Icons.info_outline,
                                                    color: Colors.teal.shade600,
                                                    size: 16,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      requestsController
                                                          .activeFiltersDescription,
                                                      style: TextStyle(
                                                        color:
                                                            Colors
                                                                .teal
                                                                .shade800,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed:
                                                        () =>
                                                            requestsController
                                                                .clearAllFilters(),
                                                    child: Text(
                                                      'Limpiar',
                                                      style: TextStyle(
                                                        color:
                                                            Colors
                                                                .teal
                                                                .shade600,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                    // Búsqueda
                                    TextField(
                                      controller:
                                          requestsController.searchController,
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

                                    // Filtros responsive
                                    ResponsiveWidget.isSmallScreen(context)
                                        ? Column(
                                          children: [
                                            DropdownButtonFormField<String>(
                                              value:
                                                  requestsController
                                                      .statusFilter
                                                      .value,
                                              decoration: InputDecoration(
                                                labelText: 'Estado',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
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
                                                      RequestStatus.getLabel(
                                                        status,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                              onChanged: (value) {
                                                if (value != null) {
                                                  requestsController
                                                      .updateStatusFilter(
                                                        value,
                                                      );
                                                }
                                              },
                                            ),
                                            const SizedBox(height: 16),
                                            _buildDateRangeFilter(),
                                          ],
                                        )
                                        : Row(
                                          children: [
                                            Expanded(
                                              child: DropdownButtonFormField<
                                                String
                                              >(
                                                value:
                                                    requestsController
                                                        .statusFilter
                                                        .value,
                                                decoration: InputDecoration(
                                                  labelText: 'Estado',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
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
                                                    (
                                                      status,
                                                    ) => DropdownMenuItem(
                                                      value: status,
                                                      child: Text(
                                                        RequestStatus.getLabel(
                                                          status,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                                onChanged: (value) {
                                                  if (value != null) {
                                                    requestsController
                                                        .updateStatusFilter(
                                                          value,
                                                        );
                                                  }
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: _buildDateRangeFilter(),
                                            ),
                                          ],
                                        ),
                                    const SizedBox(height: 16),

                                    // Filtro de empresas (solo para admins)
                                    Obx(() {
                                      late final LoggedUserController
                                      loggedUserController;
                                      try {
                                        loggedUserController =
                                            Get.find<LoggedUserController>();
                                      } catch (e) {
                                        loggedUserController = Get.put(
                                          LoggedUserController(),
                                        );
                                      }
                                      final isClient =
                                          loggedUserController.isClient;

                                      if (isClient) {
                                        // Para clientes, no mostrar el filtro de empresas
                                        return const SizedBox.shrink();
                                      }

                                      return _CompanyFilterWidget(
                                        controller: requestsController,
                                      );
                                    }),
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

                            final isSmallScreen =
                                ResponsiveWidget.isSmallScreen(Get.context!);

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                isSmallScreen
                                    ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.list,
                                              color: Colors.teal.shade600,
                                              size: 24,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                'Solicitudes Registradas',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.teal.shade800,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.teal.shade100,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
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
                                    )
                                    : Row(
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
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
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
                                    color: Colors.black.withValues(alpha: 0.05),
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
                      '${controller.currentPage.value}/${controller.totalPagesValue}',
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
                          controller.currentPage.value <
                                  controller.totalPagesValue
                              ? Colors.teal.shade600
                              : Colors.grey.shade400,
                    ),
                    onPressed:
                        controller.currentPage.value <
                                controller.totalPagesValue
                            ? controller.nextPage
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
                          controller.currentPage.value <
                                  controller.totalPagesValue
                              ? Colors.teal.shade600
                              : Colors.grey.shade400,
                    ),
                    onPressed:
                        controller.currentPage.value <
                                controller.totalPagesValue
                            ? controller.nextPage
                            : null,
                  ),
                ],
              ),
            ],
          );
    });
  }

  Widget _buildDateRangeFilter() {
    return Obx(() {
      final controller = Get.find<RequestController>();
      final startDate = controller.startDate.value;
      final endDate = controller.endDate.value;

      return InkWell(
        onTap: () => _selectDateRange(controller),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade50,
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.teal.shade600, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  startDate != null && endDate != null
                      ? '${startDate.day}/${startDate.month}/${startDate.year} - ${endDate.day}/${endDate.month}/${endDate.year}'
                      : 'Seleccionar rango de fechas',
                  style: TextStyle(
                    color:
                        startDate != null && endDate != null
                            ? Colors.grey.shade800
                            : Colors.grey.shade500,
                    fontSize: 14,
                  ),
                ),
              ),
              if (startDate != null && endDate != null)
                IconButton(
                  onPressed: () => controller.clearDateFilters(),
                  icon: Icon(Icons.clear, color: Colors.red.shade600, size: 18),
                  tooltip: 'Limpiar fechas',
                ),
            ],
          ),
        ),
      );
    });
  }

  Future<void> _selectDateRange(RequestController controller) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: Get.context!,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange:
          controller.startDate.value != null && controller.endDate.value != null
              ? DateTimeRange(
                start: controller.startDate.value!,
                end: controller.endDate.value!,
              )
              : null,
      locale: const Locale('es', 'ES'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.teal.shade600,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.updateDateFilters(picked.start, picked.end);
    }
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

// Widget para el filtro de empresas
class _CompanyFilterWidget extends StatefulWidget {
  final RequestController controller;

  const _CompanyFilterWidget({required this.controller});

  @override
  State<_CompanyFilterWidget> createState() => _CompanyFilterWidgetState();
}

class _CompanyFilterWidgetState extends State<_CompanyFilterWidget> {
  final CompanyService _companyService = Get.find<CompanyService>();
  List<Company> _companies = [];
  bool _isLoadingCompanies = false;

  @override
  void initState() {
    super.initState();
    _loadCompanies();
  }

  Future<void> _loadCompanies() async {
    setState(() {
      _isLoadingCompanies = true;
    });

    try {
      late final LoggedUserController loggedUserController;
      try {
        loggedUserController = Get.find<LoggedUserController>();
      } catch (e) {
        loggedUserController = Get.put(LoggedUserController());
      }

      final isClient = loggedUserController.isClient;
      final user = loggedUserController.user.value;

      if (isClient && user?.companies != null && user!.companies!.isNotEmpty) {
        // Para clientes, solo mostrar su empresa
        setState(() {
          _companies =
              user.companies!.map((loginCompany) {
                return Company(
                  id: loginCompany.id,
                  name: loginCompany.name,
                  employeeCount: loginCompany.employeeCount,
                  maxSalaryPercentage: loginCompany.maxSalaryPercentage,
                  isActive: loginCompany.isActive,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  deletedAt: null,
                  createdById: null,
                  updatedById: null,
                  deletedById: null,
                );
              }).toList();

          // Si es cliente, automáticamente seleccionar su empresa
          if (_companies.isNotEmpty) {
            widget.controller.updateCompanyFilters([_companies.first.id]);
          }
        });
      } else {
        // Para admins, cargar todas las empresas
        final (success, response, error) = await _companyService
            .getAllCompanies(
              page: 1,
              limit: 100, // Cargar todas las empresas
            );

        if (success && response != null) {
          setState(() {
            _companies =
                response.data.where((company) => company.isActive).toList();
          });
        } else {
          Get.snackbar(
            'Error',
            'No se pudieron cargar las empresas: $error',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade100,
            colorText: Colors.red.shade800,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al cargar empresas: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    } finally {
      setState(() {
        _isLoadingCompanies = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Builder(
          builder: (context) {
            late final LoggedUserController loggedUserController;
            try {
              loggedUserController = Get.find<LoggedUserController>();
            } catch (e) {
              loggedUserController = Get.put(LoggedUserController());
            }
            final isClient = loggedUserController.isClient;

            return Row(
              children: [
                Text(
                  'Empresas',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
                if (!isClient) ...[
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      widget.controller.updateCompanyFilters(
                        _companies.map((c) => c.id).toList(),
                      );
                    },
                    child: Text(
                      'Seleccionar todas',
                      style: TextStyle(
                        color: Colors.teal.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      widget.controller.clearCompanyFilters();
                    },
                    child: Text(
                      'Limpiar',
                      style: TextStyle(
                        color: Colors.red.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        if (_isLoadingCompanies)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(child: CircularProgressIndicator()),
          )
        else if (_companies.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'No hay empresas disponibles',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ),
          )
        else
          Builder(
            builder: (context) {
              late final LoggedUserController loggedUserController;
              try {
                loggedUserController = Get.find<LoggedUserController>();
              } catch (e) {
                loggedUserController = Get.put(LoggedUserController());
              }
              final isClient = loggedUserController.isClient;

              return Obx(() {
                // Leer el valor observable directamente
                final selectedIds =
                    widget.controller.selectedCompanyIds.toList();

                return Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _companies.length,
                    itemBuilder: (context, index) {
                      final company = _companies[index];
                      final isSelected = selectedIds.contains(company.id);

                      // Si es cliente, la empresa siempre está seleccionada y no se puede cambiar
                      final isClientCompany =
                          isClient && _companies.length == 1;

                      return InkWell(
                        onTap:
                            isClientCompany
                                ? null
                                : () {
                                  widget.controller.toggleCompany(company.id);
                                },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color:
                                (isSelected || isClientCompany)
                                    ? Colors.teal.shade50
                                    : Colors.transparent,
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade200,
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                (isSelected || isClientCompany)
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color:
                                    (isSelected || isClientCompany)
                                        ? Colors.teal.shade600
                                        : Colors.grey.shade400,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  company.name,
                                  style: TextStyle(
                                    color:
                                        (isSelected || isClientCompany)
                                            ? Colors.teal.shade800
                                            : Colors.grey.shade700,
                                    fontWeight:
                                        (isSelected || isClientCompany)
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              if (isSelected || isClientCompany)
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.teal.shade600,
                                  size: 16,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              });
            },
          ),
      ],
    );
  }
}

// COMPONENTES MODERNOS PARA EL MODAL

// class _ModernTextField extends StatelessWidget {
//   final String label;
//   final String hint;
//   final TextEditingController controller;
//   final IconData icon;
//   final bool isRequired;
//   final bool enabled;
//   final bool isPassword;

//   const _ModernTextField({
//     required this.label,
//     required this.hint,
//     required this.controller,
//     required this.icon,
//     this.isRequired = false,
//     this.enabled = true,
//     this.isPassword = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(icon, size: 20, color: Colors.teal.shade600),
//             const SizedBox(width: 8),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey.shade700,
//               ),
//             ),
//             if (isRequired) ...[
//               const SizedBox(width: 4),
//               Text(
//                 '*',
//                 style: TextStyle(
//                   color: Colors.red.shade400,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ],
//         ),
//         const SizedBox(height: 8),
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withValues(alpha: 0.05),
//                 blurRadius: 10,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: TextField(
//             controller: controller,
//             enabled: enabled,
//             obscureText: isPassword,
//             decoration: InputDecoration(
//               hintText: hint,
//               hintStyle: TextStyle(color: Colors.grey.shade400),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(16),
//                 borderSide: BorderSide(color: Colors.grey.shade300),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(16),
//                 borderSide: BorderSide(color: Colors.grey.shade300),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(16),
//                 borderSide: BorderSide(color: Colors.teal.shade400, width: 2),
//               ),
//               filled: true,
//               fillColor: enabled ? Colors.white : Colors.grey.shade100,
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 20,
//                 vertical: 16,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _ModernOutlinedButton extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final VoidCallback onPressed;

//   const _ModernOutlinedButton({
//     required this.label,
//     required this.icon,
//     required this.onPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade400),
//       ),
//       child: OutlinedButton.icon(
//         onPressed: onPressed,
//         icon: Icon(icon, color: Colors.grey.shade600, size: 20),
//         label: Text(
//           label,
//           style: TextStyle(
//             color: Colors.grey.shade600,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         style: OutlinedButton.styleFrom(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           side: BorderSide.none,
//         ),
//       ),
//     );
//   }
// }

// class _ModernElevatedButton extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final VoidCallback onPressed;

//   const _ModernElevatedButton({
//     required this.label,
//     required this.icon,
//     required this.onPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.teal.shade400.withValues(alpha: 0.3),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: ElevatedButton.icon(
//         onPressed: onPressed,
//         icon: Icon(icon, color: Colors.white, size: 20),
//         label: Text(
//           label,
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.teal.shade400,
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           elevation: 0,
//         ),
//       ),
//     );
//   }
// }
