/// Fuel type selector widget with chips

import 'package:flutter/material.dart';
import '../models/fuel_type.dart';

class FuelTypeSelector extends StatelessWidget {
  final FuelType selectedFuelType;
  final ValueChanged<FuelType> onChanged;

  const FuelTypeSelector({
    super.key,
    required this.selectedFuelType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: FuelType.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final fuelType = FuelType.values[index];
          final isSelected = fuelType == selectedFuelType;

          return FilterChip(
            label: Text('${fuelType.icon} ${fuelType.displayName}'),
            selected: isSelected,
            onSelected: (_) => onChanged(fuelType),
            backgroundColor: Theme.of(context).colorScheme.surface,
            selectedColor: Theme.of(context).colorScheme.primaryContainer,
            labelStyle: TextStyle(
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline.withOpacity(0.5),
              ),
            ),
          );
        },
      ),
    );
  }
}
