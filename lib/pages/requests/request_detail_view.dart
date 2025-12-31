import 'package:odewa_bo/controllers/navigation_controller.dart';
import 'package:odewa_bo/pages/requests/controllers/request_controller.dart';
import 'package:odewa_bo/pages/requests/models/request_model.dart';
import 'package:odewa_bo/pages/companies/models/company_model.dart';
import 'package:odewa_bo/pages/requests/components/receipt_upload_dialog.dart';
import 'package:odewa_bo/helpers/responsiveness.dart';
import 'package:odewa_bo/helpers/scaffold_helper.dart';
import 'package:intl/intl.dart';
// import 'package:odewa_bo/controllers/logged_user_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class RequestDetailView extends StatelessWidget {
  const RequestDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final RequestController requestController = Get.put(RequestController());
    // final LoggedUserController loggedUserController =
    //     Get.find<LoggedUserController>();

    return Scaffold(
      body: Container(
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
            // AppBar personalizado
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.teal.shade800),
                onPressed: () => Get.find<NavigationController>().goBack(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  '📋 Detalle de Solicitud',
                  style: TextStyle(
                    color: Colors.teal.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveWidget.isSmallScreen(context) ? 18 : 24,
                  ),
                ),
                centerTitle: true,
              ),
              actions: [
                if (ResponsiveWidget.isSmallScreen(context))
                  IconButton(
                    icon: const Icon(Icons.menu),
                    color: Colors.teal.shade800,
                    onPressed: () {
                      ScaffoldHelper.openParentDrawer(context);
                    },
                    tooltip: 'Menú',
                  ),
                IconButton(
                  icon: Icon(Icons.refresh, color: Colors.teal.shade800),
                  onPressed: () => requestController.loadRequests(),
                ),
                const SizedBox(width: 16),
              ],
            ),

            // Contenido principal
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(
                  ResponsiveWidget.isSmallScreen(context) ? 12 : 24,
                ),
                child: Obx(() {
                  // Usar directamente el objeto request pasado como parámetro
                  return Column(
                    children: [
                      // Header de la solicitud
                      _buildRequestHeader(
                        requestController.selectedRequest.value!,
                        context,
                      ),

                      const SizedBox(height: 24),

                      // Información de la solicitud
                      // _buildRequestInfo(
                      //   requestController.selectedRequest.value!,
                      // ),

                      // const SizedBox(height: 24),

                      // Información del cliente
                      if (requestController.selectedRequest.value!.client !=
                          null) ...[
                        _buildClientInfo(
                          requestController.selectedRequest.value!.client!,
                        ),
                        const SizedBox(height: 24),

                        // Información de la empresa del cliente
                        // if (requestController
                        //         .selectedRequest
                        //         .value!
                        //         .client!
                        //         .company !=
                        //     null)
                        //   _buildCompanyInfo(
                        //     requestController
                        //         .selectedRequest
                        //         .value!
                        //         .client!
                        //         .company!,
                        //   ),
                        // if (requestController
                        //         .selectedRequest
                        //         .value!
                        //         .client!
                        //         .company !=
                        //     null)
                        //   const SizedBox(height: 24),
                      ],

                      // Sección de cambio de estado
                      _buildStatusChangeSection(
                        requestController.selectedRequest.value!,
                        requestController,
                        context,
                      ),

                      const SizedBox(height: 32),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestHeader(OdewaRequest request, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
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
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: RequestStatus.getColor(
                    request.status,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.request_page,
                  color: RequestStatus.getColor(request.status),
                  size: 32,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Solicitud #${request.id.substring(0, 8)}',
                      style: TextStyle(
                        fontSize:
                            ResponsiveWidget.isSmallScreen(context) ? 20 : 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ResponsiveWidget.isSmallScreen(context)
                        ? Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: RequestStatus.getColor(
                                  request.status,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
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
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    request.isActive
                                        ? Colors.green.shade100
                                        : Colors.red.shade100,
                                borderRadius: BorderRadius.circular(20),
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
                        )
                        : Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: RequestStatus.getColor(
                                  request.status,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                RequestStatus.getLabel(request.status),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: RequestStatus.getColor(request.status),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    request.isActive
                                        ? Colors.green.shade100
                                        : Colors.red.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                request.isActive ? 'Activa' : 'Inactiva',
                                style: TextStyle(
                                  fontSize: 14,
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
          SizedBox(height: ResponsiveWidget.isSmallScreen(context) ? 16 : 20),
          ResponsiveWidget.isSmallScreen(context)
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
                  const SizedBox(height: 12),
                  _InfoCard(
                    icon: Icons.access_time,
                    label: 'Creada',
                    value: DateFormat(
                      'dd/MM/yyyy HH:mm',
                    ).format(request.createdAt.toLocal()),
                    color: Colors.purple.shade400,
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
                  const SizedBox(width: 16),
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.access_time,
                      label: 'Creada',
                      value: DateFormat(
                        'dd/MM/yyyy HH:mm',
                      ).format(request.createdAt.toLocal()),
                      color: Colors.purple.shade400,
                    ),
                  ),
                ],
              ),
        ],
      ),
    );
  }

  Widget _buildRequestInfo(OdewaRequest request) {
    return Container(
      padding: const EdgeInsets.all(24),
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
              Icon(Icons.info_outline, color: Colors.teal.shade600, size: 24),
              const SizedBox(width: 12),
              Text(
                'Información de la Solicitud',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          infoRow(
            label: 'Estado',
            value: RequestStatus.getLabel(request.status),
          ),
          infoRow(label: 'Monto', value: '\$${request.amount}'),
          infoRow(
            label: 'Fecha',
            value: DateFormat(
              'dd/MM/yyyy',
            ).format(DateTime.parse(request.date)),
          ),
          if (request.deletedAt != null)
            infoRow(
              label: 'Eliminada',
              value: DateFormat(
                'dd/MM/yyyy HH:mm',
              ).format(request.deletedAt as DateTime),
            ),
        ],
      ),
    );
  }

  Widget _buildClientInfo(RequestClient client) {
    final isSmallScreen = ResponsiveWidget.isSmallScreen(Get.context!);

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
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
              Icon(Icons.person, color: Colors.amber.shade600, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Información del Cliente',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 18 : 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: ResponsiveWidget.isSmallScreen(Get.context!) ? 16 : 20,
          ),
          ResponsiveWidget.isSmallScreen(Get.context!)
              ? Column(
                children: [
                  _InfoCard(
                    icon: Icons.person,
                    label: 'Nombre Completo',
                    value: client.fullName,
                    color: Colors.amber.shade600,
                  ),
                  const SizedBox(height: 12),
                  _InfoCard(
                    icon: Icons.email,
                    label: 'Email',
                    value: client.email,
                    color: Colors.blue.shade600,
                  ),
                  const SizedBox(height: 12),
                  _InfoCard(
                    icon: Icons.credit_card,
                    label: 'Documento',
                    value: client.document,
                    color: Colors.green.shade600,
                  ),
                  if (client.employeeNumber != null &&
                      client.employeeNumber!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _InfoCard(
                      icon: Icons.badge_outlined,
                      label: 'Número de Empleado',
                      value: client.employeeNumber!,
                      color: Colors.orange.shade600,
                    ),
                  ],
                ],
              )
              : Row(
                children: [
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.person,
                      label: 'Nombre Completo',
                      value: client.fullName,
                      color: Colors.amber.shade600,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.email,
                      label: 'Email',
                      value: client.email,
                      color: Colors.blue.shade600,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.credit_card,
                      label: 'Documento',
                      value: client.document,
                      color: Colors.green.shade600,
                    ),
                  ),
                  if (client.employeeNumber != null &&
                      client.employeeNumber!.isNotEmpty) ...[
                    const SizedBox(width: 16),
                    Expanded(
                      child: _InfoCard(
                        icon: Icons.badge_outlined,
                        label: 'Número de Empleado',
                        value: client.employeeNumber!,
                        color: Colors.orange.shade600,
                      ),
                    ),
                  ],
                ],
              ),
          const SizedBox(height: 20),

          infoRow(
            label: 'Banco',
            value:
                client.bank != null && client.bank!.isNotEmpty
                    ? client.bank!
                    : 'No especificado',
          ),
          infoRow(
            label: 'Moneda',
            value:
                client.currency != null && client.currency!.isNotEmpty
                    ? client.currency!
                    : 'No especificada',
          ),
          infoRow(
            label: 'Número de Cuenta',
            value:
                client.accountNumber != null && client.accountNumber!.isNotEmpty
                    ? client.accountNumber!
                    : 'No especificado',
            enableCopy:
                client.accountNumber != null &&
                client.accountNumber!.isNotEmpty,
          ),
          // infoRow(
          //   label: 'Sucursal',
          //   value:
          //       client.branch != null && client.branch!.isNotEmpty
          //           ? client.branch!
          //           : 'No especificada',
          // ),
          infoRow(
            label: 'Beneficiario',
            value:
                client.beneficiary != null && client.beneficiary!.isNotEmpty
                    ? client.beneficiary!
                    : 'No especificado',
          ),
          infoRow(
            label: 'Balance Mensual',
            value:
                client.monthlyBalance != null
                    ? '\$${client.monthlyBalance}'
                    : 'No especificado',
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyInfo(Company company) {
    final isSmallScreen = ResponsiveWidget.isSmallScreen(Get.context!);

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
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
              Icon(Icons.business, color: Colors.indigo.shade600, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Información de la Empresa del Cliente',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo.shade800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: ResponsiveWidget.isSmallScreen(Get.context!) ? 16 : 20,
          ),
          ResponsiveWidget.isSmallScreen(Get.context!)
              ? Column(
                children: [
                  _InfoCard(
                    icon: Icons.business,
                    label: 'Nombre de la Empresa',
                    value: company.name,
                    color: Colors.indigo.shade600,
                  ),
                  const SizedBox(height: 12),
                  _InfoCard(
                    icon: Icons.people,
                    label: 'Empleados',
                    value: '${company.employeeCount}',
                    color: Colors.green.shade600,
                  ),
                  const SizedBox(height: 12),
                  _InfoCard(
                    icon: Icons.toggle_on,
                    label: 'Estado',
                    value: company.isActive ? 'Activa' : 'Inactiva',
                    color:
                        company.isActive
                            ? Colors.green.shade600
                            : Colors.red.shade600,
                  ),
                ],
              )
              : Row(
                children: [
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.business,
                      label: 'Nombre de la Empresa',
                      value: company.name,
                      color: Colors.indigo.shade600,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.people,
                      label: 'Empleados',
                      value: '${company.employeeCount}',
                      color: Colors.green.shade600,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.toggle_on,
                      label: 'Estado',
                      value: company.isActive ? 'Activa' : 'Inactiva',
                      color:
                          company.isActive
                              ? Colors.green.shade600
                              : Colors.red.shade600,
                    ),
                  ),
                ],
              ),
          const SizedBox(height: 20),
          infoRow(label: 'ID de la Empresa', value: company.id),
          infoRow(
            label: 'Fecha de Creación',
            value: _formatDateTime(company.createdAt),
          ),
          infoRow(
            label: 'Última Actualización',
            value: _formatDateTime(company.updatedAt),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChangeSection(
    OdewaRequest request,
    RequestController controller,
    BuildContext context,
  ) {
    final availableStatuses = RequestStatus.getAvailableStatuses(
      request.status,
    );
    final isSmallScreen = ResponsiveWidget.isSmallScreen(context);

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
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
              Icon(Icons.update, color: Colors.orange.shade600, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Cambiar Estado',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 18 : 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          Text(
            'Estado actual: ${RequestStatus.getLabel(request.status)}',
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: isSmallScreen ? 16 : 20),

          if (availableStatuses.isEmpty) ...[
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child:
                  isSmallScreen
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info,
                                color: Colors.grey.shade600,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Esta solicitud ha alcanzado un estado final y no puede ser modificada',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                      : Row(
                        children: [
                          Icon(Icons.info, color: Colors.grey.shade600),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Esta solicitud ha alcanzado un estado final y no puede ser modificada',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
            ),
          ] else ...[
            Text(
              'Estados disponibles:',
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: isSmallScreen ? 12 : 16),
            Wrap(
              spacing: isSmallScreen ? 8 : 12,
              runSpacing: isSmallScreen ? 8 : 12,
              children:
                  availableStatuses.map((status) {
                    return _StatusChangeButton(
                      currentStatus: request.status,
                      newStatus: status,
                      onStatusChange: (newStatus) {
                        // Si el nuevo estado es "completed", mostrar el diálogo de receipt
                        if (newStatus == 'completed') {
                          Get.dialog(
                            ReceiptUploadDialog(requestId: request.id),
                            barrierDismissible: false,
                          );
                        } else {
                          controller.updateRequestStatus(request.id, newStatus);
                        }
                      },
                    );
                  }).toList(),
            ),
          ],

          SizedBox(height: isSmallScreen ? 16 : 20),

          // Flujo de estados
          Obx(
            () => Container(
              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.account_tree,
                        color: Colors.blue.shade600,
                        size: isSmallScreen ? 20 : 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Flujo de Estados',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isSmallScreen ? 8 : 12),
                  _buildStatusFlow(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFlow() {
    final requestController = Get.find<RequestController>();
    final status = requestController.selectedRequest.value!.status;
    final isSmallScreen = ResponsiveWidget.isSmallScreen(Get.context!);

    return isSmallScreen
        ? Column(
          children: [
            statusFlowStep(
              status: 'pending',
              label: 'Pendiente',
              isActive: status == 'pending',
              canTransition: true,
            ),
            const SizedBox(height: 12),
            statusFlowStep(
              status: 'approved',
              label: 'Aprobado',
              isActive: status == 'approved',
              canTransition: true,
            ),
            const SizedBox(height: 12),
            statusFlowStep(
              status: 'completed',
              label: 'Completado',
              isActive: status == 'completed',
              canTransition: false,
            ),
            const SizedBox(height: 12),
            statusFlowStep(
              status: 'rejected',
              label: 'Rechazado',
              isActive: status == 'rejected',
              canTransition: false,
              isRejection: true,
            ),
          ],
        )
        : Row(
          children: [
            Expanded(
              child: statusFlowStep(
                status: 'pending',
                label: 'Pendiente',
                isActive: status == 'pending',
                canTransition: true,
              ),
            ),
            statusFlowArrow(),
            Expanded(
              child: statusFlowStep(
                status: 'approved',
                label: 'Aprobado',
                isActive: status == 'approved',
                canTransition: true,
              ),
            ),
            statusFlowArrow(),
            Expanded(
              child: statusFlowStep(
                status: 'completed',
                label: 'Completado',
                isActive: status == 'completed',
                canTransition: false,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: statusFlowStep(
                status: 'rejected',
                label: 'Rechazado',
                isActive: status == 'rejected',
                canTransition: false,
                isRejection: true,
              ),
            ),
          ],
        );
  }

  Widget statusFlowStep({
    required String status,
    required String label,
    required bool isActive,
    required bool canTransition,
    bool isRejection = false,
  }) {
    final isSmallScreen = ResponsiveWidget.isSmallScreen(Get.context!);

    return Column(
      children: [
        Container(
          width: isSmallScreen ? 36 : 40,
          height: isSmallScreen ? 36 : 40,
          decoration: BoxDecoration(
            color:
                isActive
                    ? RequestStatus.getColor(status)
                    : Colors.grey.shade300,
            shape: BoxShape.circle,
            border: Border.all(
              color:
                  isActive
                      ? RequestStatus.getColor(status)
                      : Colors.grey.shade400,
              width: 2,
            ),
          ),
          child: Icon(
            isActive ? Icons.check : Icons.circle,
            color: isActive ? Colors.white : Colors.grey.shade600,
            size: isSmallScreen ? 18 : 20,
          ),
        ),
        SizedBox(height: isSmallScreen ? 6 : 8),
        Text(
          label,
          style: TextStyle(
            fontSize: isSmallScreen ? 11 : 12,
            fontWeight: FontWeight.w600,
            color:
                isActive
                    ? RequestStatus.getColor(status)
                    : Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget statusFlowArrow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Icon(Icons.arrow_forward, color: Colors.grey.shade400, size: 20),
    );
  }

  Widget infoRow({
    required String label,
    required String value,
    bool enableCopy = false,
  }) {
    final isSmallScreen = ResponsiveWidget.isSmallScreen(Get.context!);

    Future<void> _copyToClipboard(String text) async {
      await Clipboard.setData(ClipboardData(text: text));
      if (Get.context != null && Get.context!.mounted) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                const Text('Copiado al portapapeles'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child:
          isSmallScreen
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  enableCopy
                      ? Row(
                        children: [
                          Expanded(
                            child: Text(
                              value,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () => _copyToClipboard(value),
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.copy,
                                size: 18,
                                color: Colors.teal.shade600,
                              ),
                            ),
                          ),
                        ],
                      )
                      : Text(
                        value,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade800,
                        ),
                      ),
                ],
              )
              : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      '$label:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  Expanded(
                    child:
                        enableCopy
                            ? Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () => _copyToClipboard(value),
                                  borderRadius: BorderRadius.circular(8),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.copy,
                                      size: 18,
                                      color: Colors.teal.shade600,
                                    ),
                                  ),
                                ),
                              ],
                            )
                            : Text(
                              value,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade800,
                              ),
                            ),
                  ),
                ],
              ),
    );
  }

  String _formatDate(DateTime date) {
    final localDate = date.toLocal();
    return '${localDate.day.toString().padLeft(2, '0')}/${localDate.month.toString().padLeft(2, '0')}/${localDate.year}';
  }

  String _formatDateTime(DateTime date) {
    final localDate = date.toLocal();
    return '${localDate.day.toString().padLeft(2, '0')}/${localDate.month.toString().padLeft(2, '0')}/${localDate.year} ${localDate.hour.toString().padLeft(2, '0')}:${localDate.minute.toString().padLeft(2, '0')}';
  }
}

class _StatusChangeButton extends StatelessWidget {
  final String currentStatus;
  final String newStatus;
  final Function(String) onStatusChange;

  const _StatusChangeButton({
    required this.currentStatus,
    required this.newStatus,
    required this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    final canChange = RequestStatus.canChangeTo(currentStatus, newStatus);
    final isSmallScreen = ResponsiveWidget.isSmallScreen(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: RequestStatus.getColor(newStatus).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: canChange ? () => onStatusChange(newStatus) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: RequestStatus.getColor(newStatus),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 16 : 20,
            vertical: isSmallScreen ? 10 : 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child:
            isSmallScreen
                ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.update, size: 16, color: Colors.white),
                    const SizedBox(height: 4),
                    Flexible(
                      child: Text(
                        RequestStatus.getLabel(newStatus),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
                : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.update, size: 18, color: Colors.white),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        RequestStatus.getLabel(newStatus),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
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
    final isSmallScreen = ResponsiveWidget.isSmallScreen(context);

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
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
              Icon(icon, color: color, size: isSmallScreen ? 16 : 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 11 : 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 6 : 8),
          Text(
            value,
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
