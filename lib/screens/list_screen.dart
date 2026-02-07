/// Redesigned list screen with full-screen scrolling

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/constants.dart';
import '../models/fuel_type.dart';
import '../models/gas_station.dart';
import '../providers/gas_stations_provider.dart';
import 'station_detail_screen.dart';

class ListScreenRedesigned extends StatelessWidget {
  const ListScreenRedesigned({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GasStationsProvider>(
      builder: (context, provider, _) {
        return CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(child: _buildHeader(context, provider)),

            // Content
            if (provider.loadingState == LoadingState.loading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (provider.loadingState == LoadingState.error)
              SliverFillRemaining(child: _buildErrorState(context, provider))
            else if (provider.filteredStations.isEmpty)
              SliverFillRemaining(child: _buildEmptyState(context))
            else
              _buildStationsList(context, provider),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, GasStationsProvider provider) {
    final stations = provider.filteredStations;
    final cheapest = stations.isNotEmpty
        ? stations.reduce(
            (a, b) =>
                (a.getPrice(provider.selectedFuelType) ?? double.infinity) <
                    (b.getPrice(provider.selectedFuelType) ?? double.infinity)
                ? a
                : b,
          )
        : null;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      decoration: BoxDecoration(color: AppColors.background),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => _showFuelPicker(context, provider),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(26),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        provider.selectedFuelType.icon,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        provider.selectedFuelType.displayName,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Builder(
                    builder: (context) {
                      if (provider.loadingState == LoadingState.syncing ||
                          provider.processingStatus != null) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  provider.processingStatus ??
                                      provider.syncStatus ??
                                      'Cargando...',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (stations.isNotEmpty) {
                        return Text(
                          '${stations.length} gasolineras',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ],
          ),

          // Search bar
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(8),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              onChanged: provider.setSearchQuery,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre...',
                hintStyle: TextStyle(color: AppColors.textLight, fontSize: 14),
                border: InputBorder.none,
                icon: Icon(
                  Icons.search_rounded,
                  color: AppColors.textLight,
                  size: 20,
                ),
                suffixIcon: provider.searchQuery.isNotEmpty
                    ? GestureDetector(
                        onTap: () => provider.setSearchQuery(''),
                        child: Icon(
                          Icons.close_rounded,
                          color: AppColors.textLight,
                          size: 18,
                        ),
                      )
                    : null,
              ),
            ),
          ),

          if (cheapest != null) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.priceGood.withAlpha(26),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.local_offer_rounded,
                      color: AppColors.priceGood,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Más barata',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          cheapest.name,
                          style: TextStyle(
                            color: AppColors.text,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        cheapest
                                .getPrice(provider.selectedFuelType)
                                ?.toStringAsFixed(3) ??
                            '-',
                        style: TextStyle(
                          color: AppColors.priceGood,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        '€/L',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],

          // Sort options
          if (stations.isNotEmpty) ...[
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildSortChip(
                    context,
                    provider,
                    SortMode.price,
                    Icons.euro,
                    'Precio',
                  ),
                  const SizedBox(width: 8),
                  _buildSortChip(
                    context,
                    provider,
                    SortMode.distance,
                    Icons.near_me,
                    'Distancia',
                    enabled: provider.hasLocation,
                  ),
                  const SizedBox(width: 8),
                  _buildSortChip(
                    context,
                    provider,
                    SortMode.combined,
                    Icons.balance,
                    'Combinado',
                    enabled: provider.hasLocation,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSortChip(
    BuildContext context,
    GasStationsProvider provider,
    SortMode mode,
    IconData icon,
    String label, {
    bool enabled = true,
  }) {
    final isSelected = provider.sortMode == mode;
    final color = !enabled
        ? AppColors.textLight
        : isSelected
        ? Colors.white
        : AppColors.text;

    return GestureDetector(
      onTap: enabled ? () => provider.setSortMode(mode) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? null
              : Border.all(color: AppColors.textLight.withAlpha(77)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStationsList(
    BuildContext context,
    GasStationsProvider provider,
  ) {
    final stations = provider.filteredStations;

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final station = stations[index];
        final price = station.getPrice(provider.selectedFuelType);
        final priceCategory = provider.getCategoryForPrice(price);

        return _StationCard(
          station: station,
          fuelType: provider.selectedFuelType,
          priceCategory: priceCategory,
          onTap: () => _navigateToDetail(context, station),
        );
      }, childCount: stations.length),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.local_gas_station_outlined,
                size: 48,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No hay gasolineras',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Cambia el tipo de combustible o espera mientras cargamos los datos',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, GasStationsProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.priceHigh.withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: AppColors.priceHigh,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Error al cargar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              provider.errorMessage ?? 'Ocurrió un error inesperado',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => provider.fetchStations(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, GasStation station) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StationDetailScreen(station: station),
      ),
    );
  }

  void _showFuelPicker(BuildContext context, GasStationsProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Tipo de combustible',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: FuelType.values.map((fuel) {
                final isSelected = provider.selectedFuelType == fuel;
                return GestureDetector(
                  onTap: () {
                    provider.setFuelType(fuel);
                    Navigator.pop(context);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? null
                          : Border.all(
                              color: AppColors.textLight.withAlpha(51),
                            ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          fuel.icon,
                          size: 18,
                          color: isSelected ? Colors.white : AppColors.text,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          fuel.displayName,
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.text,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _StationCard extends StatelessWidget {
  final GasStation station;
  final dynamic fuelType;
  final PriceCategory priceCategory;
  final VoidCallback onTap;

  const _StationCard({
    required this.station,
    required this.fuelType,
    required this.priceCategory,
    required this.onTap,
  });

  Color get priceColor {
    switch (priceCategory) {
      case PriceCategory.low:
        return AppColors.priceGood;
      case PriceCategory.medium:
        return AppColors.priceMedium;
      case PriceCategory.high:
        return AppColors.priceHigh;
      case PriceCategory.unknown:
        return AppColors.textLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final price = station.getPrice(fuelType);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Price badge
            Container(
              width: 65,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: priceColor.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    price?.toStringAsFixed(3) ?? '-',
                    style: TextStyle(
                      color: priceColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '€/L',
                    style: TextStyle(
                      color: priceColor.withAlpha(179),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    station.name,
                    style: TextStyle(
                      color: AppColors.text,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    station.address,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (station.distanceKm != null) ...[
                        Icon(
                          Icons.near_me_rounded,
                          size: 14,
                          color: AppColors.textLight,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          station.distanceFormatted,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Icon(
                        Icons.schedule_rounded,
                        size: 14,
                        color: AppColors.textLight,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          station.schedule,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }
}
