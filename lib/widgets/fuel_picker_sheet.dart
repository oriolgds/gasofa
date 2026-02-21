/// Shared fuel type picker bottom sheet
library;

import 'package:flutter/material.dart';
import '../config/constants.dart';
import '../models/fuel_type.dart';
import '../providers/gas_stations_provider.dart';

// --- Fuel category metadata ---

enum _FuelCategory { gasolina, diesel, alternativo }

extension _FuelCategoryExt on _FuelCategory {
  String get label {
    switch (this) {
      case _FuelCategory.gasolina:
        return 'Gasolina';
      case _FuelCategory.diesel:
        return 'Diésel';
      case _FuelCategory.alternativo:
        return 'Alternativos';
    }
  }

  Color get color {
    switch (this) {
      case _FuelCategory.gasolina:
        return const Color(0xFF5B8FC9); // blue
      case _FuelCategory.diesel:
        return const Color(0xFFC49A3C); // amber
      case _FuelCategory.alternativo:
        return const Color(0xFF5EAD7D); // green
    }
  }
}

_FuelCategory _categoryOf(FuelType fuel) {
  switch (fuel) {
    case FuelType.gasolina95:
    case FuelType.gasolina98:
      return _FuelCategory.gasolina;
    case FuelType.dieselA:
    case FuelType.dieselB:
    case FuelType.dieselPremium:
      return _FuelCategory.diesel;
    case FuelType.glp:
    case FuelType.gnc:
      return _FuelCategory.alternativo;
  }
}

String _descriptionOf(FuelType fuel) {
  switch (fuel) {
    case FuelType.gasolina95:
      return 'La más habitual, para la mayoría de turismos';
    case FuelType.gasolina98:
      return 'Mayor octanaje, mejor rendimiento';
    case FuelType.dieselA:
      return 'Gasóleo de uso rodado estándar';
    case FuelType.dieselB:
      return 'Uso agrícola e industrial';
    case FuelType.dieselPremium:
      return 'Aditivos para mayor limpieza del motor';
    case FuelType.glp:
      return 'Gas licuado, más económico y menos emisiones';
    case FuelType.gnc:
      return 'Gas natural comprimido, muy bajo coste';
  }
}

// --- Public entry point ---

void showFuelPickerSheet(BuildContext context, GasStationsProvider provider) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => _FuelPickerSheet(provider: provider),
  );
}

// --- Sheet widget ---

class _FuelPickerSheet extends StatelessWidget {
  final GasStationsProvider provider;

  const _FuelPickerSheet({required this.provider});

  @override
  Widget build(BuildContext context) {
    // Group fuels by category
    final groups = <_FuelCategory, List<FuelType>>{};
    for (final fuel in FuelType.values) {
      final cat = _categoryOf(fuel);
      groups.putIfAbsent(cat, () => []).add(fuel);
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
            child: Text(
              'Combustible',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Text(
              'Selecciona el tipo que quieres comparar',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ),

          // Categories
          ...groups.entries.map(
            (entry) => _buildCategory(context, entry.key, entry.value),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildCategory(
    BuildContext context,
    _FuelCategory category,
    List<FuelType> fuels,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category label
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: category.color,
                  shape: BoxShape.circle,
                ),
              ),
              Text(
                category.label.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Fuel cards
          ...fuels.map((fuel) => _buildFuelRow(context, fuel, category)),
        ],
      ),
    );
  }

  Widget _buildFuelRow(
    BuildContext context,
    FuelType fuel,
    _FuelCategory category,
  ) {
    final isSelected = provider.selectedFuelType == fuel;
    final color = category.color;

    return GestureDetector(
      onTap: () {
        provider.setFuelType(fuel);
        Navigator.pop(context);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withAlpha(20) : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color.withAlpha(120) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              fuel.icon,
              size: 20,
              color: isSelected ? color : AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fuel.displayName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected ? color : AppColors.text,
                    ),
                  ),
                  Text(
                    _descriptionOf(fuel),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_rounded, size: 18, color: color)
            else
              const SizedBox(width: 18),
          ],
        ),
      ),
    );
  }
}
