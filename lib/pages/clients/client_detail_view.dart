import 'package:odewa_bo/controllers/navigation_controller.dart';
import 'package:odewa_bo/pages/clients/controllers/client_controller.dart';
import 'package:odewa_bo/pages/clients/models/client_model.dart';
import 'package:odewa_bo/pages/clients/components/client_form_modal.dart';
import 'package:odewa_bo/widgets/confirmation_dialog.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientDetailView extends StatelessWidget {
  const ClientDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final ClientController clientController = Get.put(ClientController());

    return Scaffold(
      body: Container(
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
            // AppBar personalizado
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.blue.shade800),
                onPressed: () => Get.find<NavigationController>().goBack(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  '👤 Detalle de Empleado',
                  style: TextStyle(
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                centerTitle: true,
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.refresh, color: Colors.blue.shade800),
                  onPressed: () => clientController.fetchClients(),
                ),
                const SizedBox(width: 16),
              ],
            ),

            // Contenido principal
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Obx(() {
                  if (clientController.selectedClient.value == null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No hay empleado seleccionado',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      // Header del cliente
                      _buildClientHeader(
                        clientController.selectedClient.value!,
                        context,
                      ),

                      const SizedBox(height: 24),

                      // Información personal
                      _buildPersonalInfo(
                        clientController.selectedClient.value!,
                      ),

                      const SizedBox(height: 24),

                      // Información bancaria
                      _buildBankingInfo(clientController.selectedClient.value!),

                      const SizedBox(height: 24),

                      // Información de contacto
                      _buildContactInfo(clientController.selectedClient.value!),

                      const SizedBox(height: 24),

                      // Sección de acciones
                      _buildActionsSection(
                        clientController.selectedClient.value!,
                        clientController,
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

  Widget _buildClientHeader(Client client, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
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
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.person,
                  color: Colors.blue.shade600,
                  size: 32,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${client.firstName} ${client.lastName}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
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
                            color:
                                client.isActive
                                    ? Colors.green.shade100
                                    : Colors.red.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            client.isActive ? 'Activo' : 'Inactivo',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color:
                                  client.isActive
                                      ? Colors.green.shade700
                                      : Colors.red.shade700,
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
                            color: Colors.purple.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'ID: ${client.id.substring(0, 8)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.purple.shade700,
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
              const SizedBox(width: 16),
              Expanded(
                child: _InfoCard(
                  icon: Icons.access_time,
                  label: 'Registrado',
                  value: _formatDate(client.createdAt),
                  color: Colors.green.shade400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfo(Client client) {
    return Container(
      padding: const EdgeInsets.all(24),
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
          Row(
            children: [
              Icon(Icons.person_outline, color: Colors.blue.shade600, size: 24),
              const SizedBox(width: 12),
              Text(
                'Información Personal',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _InfoRow(label: 'ID Completo', value: client.id),
          _InfoRow(label: 'Nombre', value: client.firstName),
          _InfoRow(label: 'Apellido', value: client.lastName),
          _InfoRow(label: 'Documento', value: client.document),
          _InfoRow(label: 'Email', value: client.email),
          _InfoRow(
            label: 'Estado',
            value: client.isActive ? 'Activo' : 'Inactivo',
          ),
          _InfoRow(label: 'Creado', value: _formatDateTime(client.createdAt)),
          _InfoRow(
            label: 'Actualizado',
            value: _formatDateTime(client.updatedAt),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(Client client) {
    return Container(
      padding: const EdgeInsets.all(24),
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
          Row(
            children: [
              Icon(Icons.contact_phone, color: Colors.green.shade600, size: 24),
              const SizedBox(width: 12),
              Text(
                'Información de Contacto',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _InfoCard(
                  icon: Icons.phone,
                  label: 'Teléfono',
                  value:
                      client.phone.isNotEmpty
                          ? client.phone
                          : 'No especificado',
                  color: Colors.green.shade600,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _InfoCard(
                  icon: Icons.location_on,
                  label: 'Dirección',
                  value:
                      client.address != null && client.address!.isNotEmpty
                          ? client.address!
                          : 'No especificada',
                  color: Colors.blue.shade600,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _InfoCard(
                  icon: Icons.location_city,
                  label: 'Ciudad',
                  value:
                      client.city != null && client.city!.isNotEmpty
                          ? client.city!
                          : 'No especificada',
                  color: Colors.purple.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBankingInfo(Client client) {
    return Container(
      padding: const EdgeInsets.all(24),
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
          Row(
            children: [
              Icon(
                Icons.account_balance,
                color: Colors.indigo.shade600,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Información Bancaria',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _InfoCard(
                  icon: Icons.account_balance,
                  label: 'Banco',
                  value:
                      client.bank.isNotEmpty ? client.bank : 'No especificado',
                  color: Colors.indigo.shade600,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _InfoCard(
                  icon: Icons.monetization_on,
                  label: 'Moneda',
                  value:
                      client.currency.isNotEmpty
                          ? client.currency
                          : 'No especificada',
                  color: Colors.amber.shade600,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _InfoCard(
                  icon: Icons.credit_card,
                  label: 'Cuenta',
                  value:
                      client.accountNumber.isNotEmpty
                          ? client.accountNumber
                          : 'No especificada',
                  color: Colors.teal.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _InfoRow(
            label: 'Sucursal',
            value: client.branch.isNotEmpty ? client.branch : 'No especificada',
          ),
          _InfoRow(
            label: 'Beneficiario',
            value:
                client.beneficiary.isNotEmpty
                    ? client.beneficiary
                    : 'No especificado',
          ),
          _InfoRow(
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

  Widget _buildActionsSection(
    Client client,
    ClientController controller,
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
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
          Row(
            children: [
              Icon(Icons.settings, color: Colors.orange.shade600, size: 24),
              const SizedBox(width: 12),
              Text(
                'Acciones del Empleado',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Gestiona la información y estado del empleado:',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _ActionButton(
                icon: Icons.edit,
                label: 'Editar Información',
                color: Colors.blue.shade400,
                onPressed: () {
                  _showClientModal(context, controller, client: client);
                },
              ),
              _ActionButton(
                icon: client.isActive ? Icons.block : Icons.check_circle,
                label:
                    client.isActive
                        ? 'Desactivar Empleado'
                        : 'Activar Empleado',
                color:
                    client.isActive
                        ? Colors.orange.shade400
                        : Colors.green.shade400,
                onPressed: () => controller.toggleClientStatus(client),
              ),
              _ActionButton(
                icon: Icons.delete,
                label: 'Eliminar Empleado',
                color: Colors.red.shade400,
                onPressed:
                    () => _showDeleteConfirmation(context, client, controller),
              ),
            ],
          ),
        ],
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

  void _showDeleteConfirmation(
    BuildContext context,
    Client client,
    ClientController controller,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => ConfirmationDialog(
            title: 'Eliminar Empleado',
            message:
                '¿Estás seguro que deseas eliminar a ${client.firstName} ${client.lastName}?',
            onConfirm: () async {
              controller.deleteClient(client.id);
              Navigator.of(context).pop();
              Get.find<NavigationController>().goBack();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      const SizedBox(width: 8),
                      Text('Empleado eliminado exitosamente'),
                    ],
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            onCancel: () => Navigator.pop(context),
          ),
    );
  }

  Widget _InfoRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
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

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
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
