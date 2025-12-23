import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:odewa_bo/pages/companies/models/company_model.dart';
import 'package:odewa_bo/pages/companies/services/company_service.dart';
import 'package:odewa_bo/helpers/responsiveness.dart';

class DashboardFilters extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> selectedCompanyIds;
  final Function(DateTime?, DateTime?, List<String>) onFiltersChanged;

  const DashboardFilters({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.selectedCompanyIds,
    required this.onFiltersChanged,
  });

  @override
  State<DashboardFilters> createState() => _DashboardFiltersState();
}

class _DashboardFiltersState extends State<DashboardFilters> {
  final CompanyService _companyService = Get.find<CompanyService>();
  late DateTime? _startDate;
  late DateTime? _endDate;
  late List<String> _selectedCompanyIds;
  List<Company> _companies = [];
  bool _isLoadingCompanies = false;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate;
    _endDate = widget.endDate;
    _selectedCompanyIds = List.from(widget.selectedCompanyIds);
    _loadCompanies();
  }

  @override
  void didUpdateWidget(DashboardFilters oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sincronizar las variables locales con las props del widget cuando cambian
    if (widget.startDate != oldWidget.startDate) {
      _startDate = widget.startDate;
    }
    if (widget.endDate != oldWidget.endDate) {
      _endDate = widget.endDate;
    }
    if (widget.selectedCompanyIds != oldWidget.selectedCompanyIds) {
      _selectedCompanyIds = List.from(widget.selectedCompanyIds);
    }
  }

  Future<void> _loadCompanies() async {
    setState(() {
      _isLoadingCompanies = true;
    });

    try {
      final (success, response, error) = await _companyService.getAllCompanies(
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

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange:
          _startDate != null && _endDate != null
              ? DateTimeRange(start: _startDate!, end: _endDate!)
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
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _applyFilters();
    }
  }

  void _toggleCompany(String companyId) {
    setState(() {
      if (_selectedCompanyIds.contains(companyId)) {
        _selectedCompanyIds.remove(companyId);
      } else {
        _selectedCompanyIds.add(companyId);
      }
    });
    _applyFilters();
  }

  void _selectAllCompanies() {
    setState(() {
      _selectedCompanyIds = _companies.map((company) => company.id).toList();
    });
    _applyFilters();
  }

  void _clearAllCompanies() {
    setState(() {
      _selectedCompanyIds.clear();
    });
    _applyFilters();
  }

  void _clearDateRange() {
    setState(() {
      _startDate = null;
      _endDate = null;
    });
    _applyFilters();
  }

  void _applyFilters() {
    widget.onFiltersChanged(_startDate, _endDate, _selectedCompanyIds);
  }

  void _clearAllFilters() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _selectedCompanyIds.clear();
    });
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // Header del filtro
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_list,
                    color: Colors.teal.shade600,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Filtros del Dashboard',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade800,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      if (_hasActiveFilters())
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.teal.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_getActiveFiltersCount()} filtros',
                            style: TextStyle(
                              color: Colors.teal.shade700,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.teal.shade600,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Contenido expandible
          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filtro de fechas
                  _buildDateRangeFilter(),

                  const SizedBox(height: 24),

                  // Filtro de empresas
                  _buildCompanyFilter(),

                  const SizedBox(height: 20),

                  // Botones de acción
                  _buildActionButtons(),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDateRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rango de Fechas',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: _selectDateRange,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade50,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Colors.teal.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _startDate != null && _endDate != null
                              ? '${DateFormat('dd/MM/yyyy').format(_startDate!)} - ${DateFormat('dd/MM/yyyy').format(_endDate!)}'
                              : 'Seleccionar rango de fechas',
                          style: TextStyle(
                            color:
                                _startDate != null && _endDate != null
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_startDate != null && _endDate != null) ...[
              const SizedBox(width: 12),
              IconButton(
                onPressed: _clearDateRange,
                icon: Icon(Icons.clear, color: Colors.red.shade600),
                tooltip: 'Limpiar fechas',
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildCompanyFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Empresas',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: _selectAllCompanies,
              child: Text(
                'Seleccionar todas',
                style: TextStyle(color: Colors.teal.shade600, fontSize: 12),
              ),
            ),
            TextButton(
              onPressed: _clearAllCompanies,
              child: Text(
                'Limpiar',
                style: TextStyle(color: Colors.red.shade600, fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_isLoadingCompanies)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          )
        else if (_companies.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Center(
              child: Text(
                'No hay empresas disponibles',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ),
          )
        else
          Container(
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
                final isSelected = _selectedCompanyIds.contains(company.id);

                return InkWell(
                  onTap: () => _toggleCompany(company.id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? Colors.teal.shade50 : Colors.transparent,
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
                          isSelected
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color:
                              isSelected
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
                                  isSelected
                                      ? Colors.teal.shade800
                                      : Colors.grey.shade700,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (isSelected)
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
          ),
      ],
    );
  }

  Widget _buildActionButtons() {
    final isSmallScreen = ResponsiveWidget.isSmallScreen(context);

    return isSmallScreen
        ? Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _clearAllFilters,
                icon: Icon(
                  Icons.clear_all,
                  size: 18,
                  color: Colors.red.shade600,
                ),
                label: const Text('Limpiar todos'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red.shade600,
                  side: BorderSide(color: Colors.red.shade300),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _applyFilters,
                icon: const Icon(Icons.search, size: 18, color: Colors.white),
                label: const Text('Aplicar filtros'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        )
        : Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _clearAllFilters,
                icon: const Icon(Icons.clear_all, size: 18),
                label: const Text('Limpiar todos'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red.shade600,
                  side: BorderSide(color: Colors.red.shade300),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _applyFilters,
                icon: const Icon(Icons.search, size: 18),
                label: const Text('Aplicar filtros'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        );
  }

  bool _hasActiveFilters() {
    return (_startDate != null && _endDate != null) ||
        _selectedCompanyIds.isNotEmpty;
  }

  int _getActiveFiltersCount() {
    int count = 0;
    if (_startDate != null && _endDate != null) count++;
    if (_selectedCompanyIds.isNotEmpty) count++;
    return count;
  }
}
