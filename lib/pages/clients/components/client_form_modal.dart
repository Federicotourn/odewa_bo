import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/bank_constants.dart';
import '../models/client_model.dart';
import '../controllers/client_controller.dart';
import '../../companies/models/company_model.dart';
import '../../../helpers/responsiveness.dart';

class ClientFormModal extends StatefulWidget {
  final Client? client;

  const ClientFormModal({super.key, this.client});

  @override
  State<ClientFormModal> createState() => _ClientFormModalState();
}

class _ClientFormModalState extends State<ClientFormModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _documentController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _monthlyBalanceController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _employeeNumberController =
      TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _beneficiaryController = TextEditingController();

  // Company selection
  String? _selectedCompanyId;
  // Datos bancarios
  String? _selectedBank;
  String? _selectedCurrency;

  @override
  void initState() {
    super.initState();
    if (widget.client != null) {
      _firstNameController.text = widget.client!.firstName;
      _lastNameController.text = widget.client!.lastName;
      _documentController.text = widget.client!.document;
      _emailController.text = widget.client!.email ?? '';
      _phoneController.text = widget.client!.phone ?? '';
      _monthlyBalanceController.text =
          widget.client!.monthlyBalance?.toString() ?? '';
      _passwordController.text = widget.client!.password ?? '';
      _employeeNumberController.text = widget.client!.employeeNumber ?? '';
      _selectedCompanyId = widget.client!.company?.id;
      _selectedBank = widget.client!.bank;
      _selectedCurrency = widget.client!.currency;
      _accountNumberController.text = widget.client!.accountNumber ?? '';
      _beneficiaryController.text = widget.client!.beneficiary ?? '';
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _documentController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _monthlyBalanceController.dispose();
    _passwordController.dispose();
    _employeeNumberController.dispose();
    _accountNumberController.dispose();
    _beneficiaryController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Crear el objeto cliente
      final newClient = Client(
        id: widget.client?.id ?? '', // Solo se usa al editar
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        document: _documentController.text,
        email: _emailController.text,
        phone: _phoneController.text.isEmpty ? null : _phoneController.text,
        isActive: widget.client?.isActive ?? true,
        createdAt: widget.client?.createdAt ?? DateTime.now(),
        updatedAt: widget.client?.updatedAt ?? DateTime.now(),
        address: widget.client?.address,
        city: widget.client?.city,
        bank: _selectedBank,
        currency: _selectedCurrency,
        accountNumber:
            _accountNumberController.text.trim().isEmpty
                ? null
                : _accountNumberController.text.trim(),
        branch: widget.client?.branch,
        beneficiary:
            _beneficiaryController.text.trim().isEmpty
                ? null
                : _beneficiaryController.text.trim(),
        monthlyBalance:
            _monthlyBalanceController.text.isEmpty
                ? null
                : double.tryParse(_monthlyBalanceController.text),

        employeeNumber:
            _employeeNumberController.text.isEmpty
                ? null
                : _employeeNumberController.text,
        company:
            _selectedCompanyId != null && _selectedCompanyId!.isNotEmpty
                ? Company(
                  id: _selectedCompanyId!,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  deletedAt: null,
                  createdById: null,
                  updatedById: null,
                  deletedById: null,
                  isActive: true,
                  name: '', // Will be filled by the server
                  employeeCount: 0, // Will be filled by the server
                  averageMonthlyBalance: 0, // Will be filled by the server
                )
                : null,
      );

      // Obtener el controlador
      final controller = Get.find<ClientController>();

      bool success = false;
      if (widget.client != null) {
        // Actualizar cliente existente
        success = await controller.updateClient(newClient);
      } else {
        // Crear nuevo cliente
        success = await controller.createClient(newClient);
      }

      if (success) {
        Navigator.pop(context);
      }
      // Los mensajes de éxito/error ya se manejan en el controlador
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = ResponsiveWidget.isSmallScreen(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: isSmallScreen ? Get.width * 0.95 : Get.width * 0.5,
        constraints: BoxConstraints(
          maxHeight: isSmallScreen ? Get.height * 0.9 : Get.height * 0.8,
        ),
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
                  colors: [Colors.blue.shade400, Colors.purple.shade400],
                ),
              ),
              child:
                  isSmallScreen
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  widget.client == null
                                      ? Icons.person_add
                                      : Icons.edit,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  widget.client == null
                                      ? 'Crear Nuevo Usuario'
                                      : 'Editar Usuario',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.client == null
                                ? 'Define un nuevo usuario con sus datos'
                                : 'Modifica la información del usuario existente',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      )
                      : Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              widget.client == null
                                  ? Icons.person_add
                                  : Icons.edit,
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
                                  widget.client == null
                                      ? 'Crear Nuevo Usuario'
                                      : 'Editar Usuario',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.client == null
                                      ? 'Define un nuevo usuario con sus datos'
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
                padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Campo de nombre
                      _ModernTextField(
                        label: 'Nombre',
                        hint: 'Ej: Federico',
                        controller: _firstNameController,
                        icon: Icons.person,
                        isRequired: true,
                      ),

                      const SizedBox(height: 20),

                      // Campo de apellido
                      _ModernTextField(
                        label: 'Apellido',
                        hint: 'Ej: Tourn',
                        controller: _lastNameController,
                        icon: Icons.person_outline,
                        isRequired: true,
                      ),

                      const SizedBox(height: 20),

                      // Campo de documento
                      _ModernTextField(
                        label: 'Documento (Sin puntos, guiones ni espacios)',
                        hint: 'Ej: 12345678',
                        controller: _documentController,
                        icon: Icons.badge,
                        isRequired: true,
                      ),

                      const SizedBox(height: 20),

                      // Campo de número de empleado
                      _ModernTextField(
                        label: 'Número de Empleado',
                        hint: 'Ej: EMP-001',
                        controller: _employeeNumberController,
                        icon: Icons.badge_outlined,
                        isRequired: false,
                      ),

                      const SizedBox(height: 20),

                      // Campo de email
                      _ModernTextField(
                        label: 'Email',
                        hint: 'Ej: federico@ejemplo.com',
                        controller: _emailController,
                        icon: Icons.email,
                        isRequired: true,
                      ),

                      const SizedBox(height: 20),

                      // Campo de teléfono
                      _ModernTextField(
                        label: 'Teléfono',
                        hint: 'Ej: +59895594480',
                        controller: _phoneController,
                        icon: Icons.phone,
                        isRequired: false,
                      ),

                      const SizedBox(height: 20),

                      // Campo de empresa
                      _buildCompanyDropdown(),

                      const SizedBox(height: 20),

                      // Datos bancarios (obligatorios)
                      Row(
                        children: [
                          Text(
                            'Datos bancarios',
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
                      const SizedBox(height: 12),
                      _buildBankDropdown(),
                      const SizedBox(height: 20),
                      _buildCurrencyDropdown(),
                      const SizedBox(height: 20),
                      _ModernTextField(
                        label: 'Número de cuenta',
                        hint: 'Ej: 1234567890',
                        controller: _accountNumberController,
                        icon: Icons.account_balance,
                        isRequired: true,
                      ),
                      const SizedBox(height: 20),
                      _ModernTextField(
                        label: 'Beneficiario',
                        hint: 'Nombre y apellido del beneficiario',
                        controller: _beneficiaryController,
                        icon: Icons.person,
                        isRequired: true,
                      ),

                      const SizedBox(height: 20),

                      // Campo de balance mensual
                      _ModernTextField(
                        label: 'Balance Mensual',
                        hint: 'Ej: 50000',
                        controller: _monthlyBalanceController,
                        icon: Icons.monetization_on,
                        isRequired: true,
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            // Footer con acciones
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child:
                  isSmallScreen
                      ? Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: _ModernOutlinedButton(
                              label: 'Cancelar',
                              icon: Icons.close,
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: _ModernElevatedButton(
                              label:
                                  widget.client == null
                                      ? 'Crear Usuario'
                                      : 'Actualizar Usuario',
                              icon:
                                  widget.client == null
                                      ? Icons.add
                                      : Icons.save,
                              onPressed: () async {
                                if (_firstNameController.text.trim().isEmpty ||
                                    _lastNameController.text.trim().isEmpty ||
                                    _documentController.text.trim().isEmpty ||
                                    _emailController.text.trim().isEmpty ||
                                    _selectedCompanyId == null ||
                                    _selectedCompanyId!.isEmpty ||
                                    _selectedBank == null ||
                                    _selectedBank!.isEmpty ||
                                    _selectedCurrency == null ||
                                    _selectedCurrency!.isEmpty ||
                                    _accountNumberController.text
                                        .trim()
                                        .isEmpty ||
                                    _beneficiaryController.text
                                        .trim()
                                        .isEmpty ||
                                    _monthlyBalanceController.text
                                        .trim()
                                        .isEmpty) {
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

                                if (!GetUtils.isEmail(
                                  _emailController.text.trim(),
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        children: [
                                          Icon(
                                            Icons.warning,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 8),
                                          const Text('Ingresa un email válido'),
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

                                // Validar balance mensual si no está vacío
                                if (_monthlyBalanceController.text
                                        .trim()
                                        .isNotEmpty &&
                                    int.tryParse(
                                          _monthlyBalanceController.text.trim(),
                                        ) ==
                                        null) {
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
                                            'Ingresa un balance mensual válido',
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

                                _submitForm();
                              },
                            ),
                          ),
                        ],
                      )
                      : Row(
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
                                widget.client == null
                                    ? 'Crear Usuario'
                                    : 'Actualizar Usuario',
                            icon:
                                widget.client == null ? Icons.add : Icons.save,
                            onPressed: () async {
                              if (_firstNameController.text.trim().isEmpty ||
                                  _lastNameController.text.trim().isEmpty ||
                                  _documentController.text.trim().isEmpty ||
                                  _emailController.text.trim().isEmpty ||
                                  _selectedCompanyId == null ||
                                  _selectedCompanyId!.isEmpty ||
                                  _selectedBank == null ||
                                  _selectedBank!.isEmpty ||
                                  _selectedCurrency == null ||
                                  _selectedCurrency!.isEmpty ||
                                  _accountNumberController.text
                                      .trim()
                                      .isEmpty ||
                                  _beneficiaryController.text.trim().isEmpty) {
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

                              if (!GetUtils.isEmail(
                                _emailController.text.trim(),
                              )) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(
                                          Icons.warning,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text('Ingresa un email válido'),
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

                              // Validar balance mensual si no está vacío
                              if (_monthlyBalanceController.text
                                      .trim()
                                      .isNotEmpty &&
                                  int.tryParse(
                                        _monthlyBalanceController.text.trim(),
                                      ) ==
                                      null) {
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
                                          'Ingresa un balance mensual válido',
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

                              _submitForm();
                            },
                          ),
                        ],
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyDropdown() {
    return GetBuilder<ClientController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.business, size: 20, color: Colors.blue.shade600),
                const SizedBox(width: 8),
                Text(
                  'Empresa',
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
                value: _selectedCompanyId,
                decoration: InputDecoration(
                  hintText: 'Selecciona una empresa',
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
                    borderSide: BorderSide(
                      color: Colors.blue.shade400,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                items:
                    controller.companies.map((Company company) {
                      return DropdownMenuItem<String>(
                        value: company.id,
                        child: Text(
                          company.name,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCompanyId = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor selecciona una empresa';
                  }
                  return null;
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBankDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.account_balance, size: 20, color: Colors.blue.shade600),
            const SizedBox(width: 8),
            Text(
              'Banco',
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
            value: _selectedBank,
            decoration: InputDecoration(
              hintText: 'Selecciona un banco',
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
            items:
                availableBanks
                    .map(
                      (e) => DropdownMenuItem<String>(
                        value: e.$1,
                        child: Text(e.$2),
                      ),
                    )
                    .toList(),
            onChanged: (String? newValue) {
              setState(() => _selectedBank = newValue);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor selecciona un banco';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCurrencyDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.attach_money, size: 20, color: Colors.blue.shade600),
            const SizedBox(width: 8),
            Text(
              'Moneda',
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
            value: _selectedCurrency,
            decoration: InputDecoration(
              hintText: 'Selecciona moneda',
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
            items:
                availableCurrencies
                    .map(
                      (e) => DropdownMenuItem<String>(
                        value: e.$1,
                        child: Text(e.$2),
                      ),
                    )
                    .toList(),
            onChanged: (String? newValue) {
              setState(() => _selectedCurrency = newValue);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor selecciona una moneda';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}

// COMPONENTES MODERNOS PARA EL MODAL

class _ModernTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData icon;
  final bool isRequired;
  final TextInputType? keyboardType;
  final bool isPassword;

  const _ModernTextField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.icon,
    this.isRequired = false,
    this.keyboardType,
    this.isPassword = false,
  });

  @override
  State<_ModernTextField> createState() => _ModernTextFieldState();
}

class _ModernTextFieldState extends State<_ModernTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(widget.icon, size: 20, color: Colors.blue.shade600),
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            if (widget.isRequired) ...[
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
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText: widget.isPassword ? _obscureText : false,
            decoration: InputDecoration(
              hintText: widget.hint,
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
              suffixIcon:
                  widget.isPassword
                      ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey.shade600,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )
                      : null,
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
            color: Colors.blue.shade400.withValues(alpha: 0.3),
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
          backgroundColor: Colors.blue.shade400,
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
