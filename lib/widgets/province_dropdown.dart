/// Province dropdown selector widget

import 'package:flutter/material.dart';
import '../config/constants.dart';

class ProvinceDropdown extends StatelessWidget {
  final String? selectedProvinceCode;
  final ValueChanged<String?> onChanged;
  final bool useLocation;
  final VoidCallback onUseLocationTap;

  const ProvinceDropdown({
    super.key,
    required this.selectedProvinceCode,
    required this.onChanged,
    required this.useLocation,
    required this.onUseLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Convert map to sorted list
    final sortedProvinces = provincesCodes.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Use location toggle
        InkWell(
          onTap: onUseLocationTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: useLocation
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: useLocation
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withOpacity(0.5),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.my_location,
                  color: useLocation
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Usar mi ubicación',
                    style: TextStyle(
                      color: useLocation
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurface,
                      fontWeight: useLocation
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
                if (useLocation)
                  Icon(Icons.check_circle, color: theme.colorScheme.primary),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Province dropdown
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.5),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: const Text('Selecciona una provincia'),
              value: selectedProvinceCode,
              onChanged: onChanged,
              items: sortedProvinces.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
