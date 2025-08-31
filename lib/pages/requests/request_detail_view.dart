import 'package:odewa_bo/controllers/navigation_controller.dart';
import 'package:odewa_bo/pages/requests/controllers/request_controller.dart';
import 'package:odewa_bo/pages/requests/models/request_model.dart';
// import 'package:odewa_bo/controllers/logged_user_controller.dart';

import 'package:flutter/material.dart';
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
                    fontSize: 24,
                  ),
                ),
                centerTitle: true,
              ),
              actions: [
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
                padding: const EdgeInsets.all(24),
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
                      _buildRequestInfo(
                        requestController.selectedRequest.value!,
                      ),

                      const SizedBox(height: 24),

                      // Información del cliente
                      if (requestController.selectedRequest.value!.client !=
                          null) ...[
                        _buildClientInfo(
                          requestController.selectedRequest.value!.client!,
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Sección de cambio de estado
                      _buildStatusChangeSection(
                        requestController.selectedRequest.value!,
                        requestController,
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
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
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
          const SizedBox(height: 20),
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
              const SizedBox(width: 16),
              Expanded(
                child: _InfoCard(
                  icon: Icons.access_time,
                  label: 'Creada',
                  value: _formatDate(request.createdAt),
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
          infoRow(label: 'ID', value: request.id),
          infoRow(
            label: 'Estado',
            value: RequestStatus.getLabel(request.status),
          ),
          infoRow(label: 'Monto', value: '\$${request.amount}'),
          infoRow(label: 'Fecha', value: request.date),
          infoRow(label: 'Cliente ID', value: request.clientId),
          infoRow(label: 'Creada', value: _formatDateTime(request.createdAt)),
          infoRow(
            label: 'Actualizada',
            value: _formatDateTime(request.updatedAt),
          ),
          if (request.deletedAt != null)
            infoRow(
              label: 'Eliminada',
              value: _formatDateTime(request.deletedAt as DateTime),
            ),
        ],
      ),
    );
  }

  Widget _buildClientInfo(RequestClient client) {
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
              Icon(Icons.person, color: Colors.amber.shade600, size: 24),
              const SizedBox(width: 12),
              Text(
                'Información del Cliente',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
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
            ],
          ),
          const SizedBox(height: 20),
          infoRow(label: 'ID', value: client.id),
          infoRow(
            label: 'Teléfono',
            value: client.phone.isEmpty ? 'No especificado' : client.phone,
          ),
          infoRow(
            label: 'Dirección',
            value: client.address.isEmpty ? 'No especificada' : client.address,
          ),
          infoRow(
            label: 'Ciudad',
            value: client.city.isEmpty ? 'No especificada' : client.city,
          ),
          infoRow(label: 'Banco', value: client.bank),
          infoRow(label: 'Moneda', value: client.currency),
          infoRow(label: 'Número de Cuenta', value: client.accountNumber),
          infoRow(label: 'Sucursal', value: client.branch),
          infoRow(label: 'Beneficiario', value: client.beneficiary),
          infoRow(
            label: 'Balance Mensual',
            value: '\$${client.monthlyBalance}',
          ),
          infoRow(label: 'Creado', value: _formatDateTime(client.createdAt)),
          infoRow(
            label: 'Actualizado',
            value: _formatDateTime(client.updatedAt),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChangeSection(
    OdewaRequest request,
    RequestController controller,
  ) {
    final availableStatuses = RequestStatus.getAvailableStatuses(
      request.status,
    );

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
              Icon(Icons.update, color: Colors.orange.shade600, size: 24),
              const SizedBox(width: 12),
              Text(
                'Cambiar Estado',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Estado actual: ${RequestStatus.getLabel(request.status)}',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 20),

          if (availableStatuses.isEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.grey.shade600),
                  const SizedBox(width: 12),
                  Text(
                    'Esta solicitud ha alcanzado un estado final y no puede ser modificada',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ],
              ),
            ),
          ] else ...[
            Text(
              'Estados disponibles:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children:
                  availableStatuses.map((status) {
                    return _StatusChangeButton(
                      currentStatus: request.status,
                      newStatus: status,
                      onStatusChange: (newStatus) {
                        controller.updateRequestStatus(request.id, newStatus);
                      },
                    );
                  }).toList(),
            ),
          ],

          const SizedBox(height: 20),

          // Flujo de estados
          Obx(
            () => Container(
              padding: const EdgeInsets.all(16),
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
                      Icon(Icons.account_tree, color: Colors.blue.shade600),
                      const SizedBox(width: 8),
                      Text(
                        'Flujo de Estados',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
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
    return Row(
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
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
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
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color:
                isActive
                    ? RequestStatus.getColor(status)
                    : Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
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

  Widget infoRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
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
            child: Text(
              value,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatDateTime(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.update, size: 18, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              RequestStatus.getLabel(newStatus),
              style: const TextStyle(fontWeight: FontWeight.w600),
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
