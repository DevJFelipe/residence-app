import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/core/theme/app_colors.dart';
import 'package:residence_app/core/theme/app_text_styles.dart';

class PqrsScreen extends StatefulWidget {
  const PqrsScreen({super.key});

  @override
  State<PqrsScreen> createState() => _PqrsScreenState();
}

class _PqrsScreenState extends State<PqrsScreen> {
  int _activeFilter = 0;

  static const _filterLabels = [
    'Todas',
    'Peticiones',
    'Quejas',
    'Reclamos',
    'Sugerencias',
  ];

  // Mock PQRS data
  static final _pqrsItems = [
    _PqrsItem(
      type: 'Petición',
      subject: 'Solicitud de parqueadero adicional',
      unit: 'Apto 301 - Torre 2',
      resident: 'María González',
      time: 'Hace 2 horas',
      status: 'Abierto',
      priority: 'high',
    ),
    _PqrsItem(
      type: 'Queja',
      subject: 'Ruido excesivo en horario nocturno',
      unit: 'Apto 502 - Torre 1',
      resident: 'Carlos Ramírez',
      time: 'Hace 4 horas',
      status: 'En Proceso',
      priority: 'high',
    ),
    _PqrsItem(
      type: 'Reclamo',
      subject: 'Cobro duplicado en cuota de marzo',
      unit: 'Apto 203 - Torre 3',
      resident: 'Ana Martínez',
      time: 'Hace 6 horas',
      status: 'Abierto',
      priority: 'medium',
    ),
    _PqrsItem(
      type: 'Sugerencia',
      subject: 'Instalación de cámaras en parqueadero',
      unit: 'Apto 401 - Torre 2',
      resident: 'Luis Hernández',
      time: 'Hace 1 día',
      status: 'En Proceso',
      priority: 'low',
    ),
    _PqrsItem(
      type: 'Petición',
      subject: 'Permiso para remodelación interior',
      unit: 'Apto 102 - Torre 1',
      resident: 'Sandra López',
      time: 'Hace 2 días',
      status: 'Resuelto',
      priority: 'medium',
    ),
    _PqrsItem(
      type: 'Queja',
      subject: 'Filtración de agua en techo',
      unit: 'Apto 601 - Torre 3',
      resident: 'Pedro Vargas',
      time: 'Hace 3 días',
      status: 'Cerrado',
      priority: 'high',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatCards(),
                  const SizedBox(height: 24),
                  _buildFilterTabs(),
                  const SizedBox(height: 16),
                  _buildPqrsList(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: SizedBox(
        height: 64,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PQRS',
                style: GoogleFonts.publicSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  height: 28 / 20,
                  letterSpacing: -0.5,
                  color: AppColors.textDark,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.borderLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.search_rounded,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCards() {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.6,
      children: [
        _StatCard(label: 'Total', value: '24', color: AppColors.primary),
        _StatCard(label: 'Abiertas', value: '8', color: AppColors.error),
        _StatCard(label: 'En Proceso', value: '6', color: AppColors.warning),
        _StatCard(label: 'Resueltas', value: '10', color: AppColors.success),
      ],
    );
  }

  Widget _buildFilterTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_filterLabels.length, (index) {
          final isActive = index == _activeFilter;
          return Padding(
            padding: EdgeInsets.only(right: index < _filterLabels.length - 1 ? 8 : 0),
            child: GestureDetector(
              onTap: () => setState(() => _activeFilter = index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive ? AppColors.primary : AppColors.divider,
                  ),
                ),
                child: Text(
                  _filterLabels[index],
                  style: GoogleFonts.publicSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPqrsList() {
    final filtered = _activeFilter == 0
        ? _pqrsItems
        : _pqrsItems.where((item) {
            switch (_activeFilter) {
              case 1:
                return item.type == 'Petición';
              case 2:
                return item.type == 'Queja';
              case 3:
                return item.type == 'Reclamo';
              case 4:
                return item.type == 'Sugerencia';
              default:
                return true;
            }
          }).toList();

    return Column(
      children: filtered.map((item) => _buildPqrsCard(item)).toList(),
    );
  }

  Widget _buildPqrsCard(_PqrsItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: type badge + priority dot
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _typeColor(item.type).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.type,
                  style: GoogleFonts.publicSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _typeColor(item.type),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _priorityColor(item.priority),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStatusBadge(item.status),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Subject
          Text(
            item.subject,
            style: AppTextStyles.semiBold14,
          ),
          const SizedBox(height: 6),
          // Unit + Resident
          Text(
            '${item.unit} \u2022 ${item.resident}',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 4),
          // Date
          Text(
            item.time,
            style: GoogleFonts.publicSans(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: GoogleFonts.publicSans(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'Petición':
        return AppColors.info;
      case 'Queja':
        return AppColors.error;
      case 'Reclamo':
        return AppColors.warning;
      case 'Sugerencia':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Abierto':
        return AppColors.error;
      case 'En Proceso':
        return AppColors.warning;
      case 'Resuelto':
        return AppColors.success;
      case 'Cerrado':
        return AppColors.textSecondary;
      default:
        return AppColors.textSecondary;
    }
  }

  Color _priorityColor(String priority) {
    switch (priority) {
      case 'high':
        return AppColors.error;
      case 'medium':
        return AppColors.warning;
      case 'low':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: GoogleFonts.publicSans(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              height: 1.2,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _PqrsItem {
  final String type;
  final String subject;
  final String unit;
  final String resident;
  final String time;
  final String status;
  final String priority;

  const _PqrsItem({
    required this.type,
    required this.subject,
    required this.unit,
    required this.resident,
    required this.time,
    required this.status,
    required this.priority,
  });
}
