/// Redesigned map screen with always-visible stations and price markers

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/constants.dart';
import '../models/gas_station.dart';
import '../providers/gas_stations_provider.dart';

class MapScreenRedesigned extends StatefulWidget {
  const MapScreenRedesigned({super.key});

  @override
  State<MapScreenRedesigned> createState() => _MapScreenRedesignedState();
}

class _MapScreenRedesignedState extends State<MapScreenRedesigned> {
  final MapController _mapController = MapController();
  GasStation? _selectedStation;
  LatLngBounds? _currentBounds;
  double _currentZoom = 6.0;

  @override
  Widget build(BuildContext context) {
    return Consumer<GasStationsProvider>(
      builder: (context, provider, _) {
        // Default center (Spain)
        double centerLat = 40.4168;
        double centerLng = -3.7038;
        double zoom = 6.0;

        // Center on user or stations
        if (provider.userPosition != null) {
          centerLat = provider.userPosition!.latitude;
          centerLng = provider.userPosition!.longitude;
          zoom = 12.0;
        } else if (provider.filteredStations.isNotEmpty) {
          final stations = provider.filteredStations;
          centerLat =
              stations.map((s) => s.latitude).reduce((a, b) => a + b) /
              stations.length;
          centerLng =
              stations.map((s) => s.longitude).reduce((a, b) => a + b) /
              stations.length;
          zoom = 11.0;
        }

        return Stack(
          children: [
            // Map
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(centerLat, centerLng),
                initialZoom: zoom,
                onTap: (_, __) => setState(() => _selectedStation = null),
                onPositionChanged: (position, hasGesture) {
                  final bounds = position.visibleBounds;
                  setState(() {
                    _currentBounds = bounds;
                    _currentZoom = position.zoom;
                  });
                },
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                ),
              ),
              children: [
                // OpenStreetMap tiles
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.gasofa.app',
                ),

                // User location
                if (provider.userPosition != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(
                          provider.userPosition!.latitude,
                          provider.userPosition!.longitude,
                        ),
                        width: 24,
                        height: 24,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withAlpha(77),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                // Stations (sorted so green/cheap appear on top)
                MarkerLayer(
                  markers: () {
                    // Filter by viewport if bounds available
                    var stations = provider.filteredStations;
                    if (_currentBounds != null) {
                      stations = stations.where((s) {
                        return _currentBounds!.contains(
                          LatLng(s.latitude, s.longitude),
                        );
                      }).toList();
                    }

                    // Zoom-based filtering:
                    // If zoom < 10, show only cheap (green) stations
                    if (_currentZoom < 10.0) {
                      stations = stations.where((s) {
                        final priceCategory =
                            GasStationsProvider.getPriceCategory(
                              s.getPrice(provider.selectedFuelType),
                              provider.filteredStations,
                              provider.selectedFuelType,
                            );
                        return priceCategory == PriceCategory.low;
                      }).toList();
                    }

                    // Add price category to each station for sorting
                    final stationsWithCategory = stations.map((station) {
                      final priceCategory =
                          GasStationsProvider.getPriceCategory(
                            station.getPrice(provider.selectedFuelType),
                            provider.filteredStations,
                            provider.selectedFuelType,
                          );
                      return (station: station, category: priceCategory);
                    }).toList();

                    // Sort: high (red) first, then medium, then low (green) last (on top)
                    stationsWithCategory.sort((a, b) {
                      const order = {
                        PriceCategory.high: 0,
                        PriceCategory.unknown: 1,
                        PriceCategory.medium: 2,
                        PriceCategory.low: 3,
                      };
                      return order[a.category]!.compareTo(order[b.category]!);
                    });

                    return stationsWithCategory.map((item) {
                      return Marker(
                        point: LatLng(
                          item.station.latitude,
                          item.station.longitude,
                        ),
                        width: 60,
                        height: 36,
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _selectedStation = item.station);
                            _mapController.move(
                              LatLng(
                                item.station.latitude,
                                item.station.longitude,
                              ),
                              _mapController.camera.zoom,
                            );
                          },
                          child: _PriceMarker(
                            price: item.station.getPrice(
                              provider.selectedFuelType,
                            ),
                            category: item.category,
                            isSelected: _selectedStation?.id == item.station.id,
                          ),
                        ),
                      );
                    }).toList();
                  }(),
                ),
              ],
            ),

            // Header
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 12,
                  left: 16,
                  right: 16,
                  bottom: 12,
                ),
                decoration: BoxDecoration(color: AppColors.surface),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(13),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            provider.selectedFuelType.icon,
                            size: 16,
                            color: AppColors.text,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            provider.selectedFuelType.displayName,
                            style: TextStyle(
                              color: AppColors.text,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (provider.loadingState == LoadingState.loading ||
                        provider.loadingState == LoadingState.syncing)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(13),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            ),
                            if (provider.syncStatus != null) ...[
                              const SizedBox(width: 8),
                              Text(
                                provider.syncStatus!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Re-center button
            if (provider.userPosition != null)
              Positioned(
                right: 16,
                bottom: _selectedStation != null ? 180 : 100,
                child: GestureDetector(
                  onTap: () {
                    _mapController.move(
                      LatLng(
                        provider.userPosition!.latitude,
                        provider.userPosition!.longitude,
                      ),
                      14.0,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(20),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.my_location_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                ),
              ),

            // Selected station sheet
            if (_selectedStation != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _StationSheet(
                  station: _selectedStation!,
                  provider: provider,
                  onClose: () => setState(() => _selectedStation = null),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _PriceMarker extends StatelessWidget {
  final double? price;
  final PriceCategory category;
  final bool isSelected;

  const _PriceMarker({
    required this.price,
    required this.category,
    required this.isSelected,
  });

  Color get color {
    switch (category) {
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
    return AnimatedScale(
      scale: isSelected ? 1.15 : 1.0,
      duration: const Duration(milliseconds: 150),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white, width: isSelected ? 3 : 2),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(isSelected ? 128 : 77),
              blurRadius: isSelected ? 12 : 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          price != null ? '${price!.toStringAsFixed(2)}€' : '-',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _StationSheet extends StatelessWidget {
  final GasStation station;
  final GasStationsProvider provider;
  final VoidCallback onClose;

  const _StationSheet({
    required this.station,
    required this.provider,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final price = station.getPrice(provider.selectedFuelType);
    final priceCategory = GasStationsProvider.getPriceCategory(
      price,
      provider.filteredStations,
      provider.selectedFuelType,
    );

    Color priceColor;
    switch (priceCategory) {
      case PriceCategory.low:
        priceColor = AppColors.priceGood;
      case PriceCategory.medium:
        priceColor = AppColors.priceMedium;
      case PriceCategory.high:
        priceColor = AppColors.priceHigh;
      case PriceCategory.unknown:
        priceColor = AppColors.textLight;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            // Content
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: priceColor.withAlpha(26),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        price?.toStringAsFixed(3) ?? '-',
                        style: TextStyle(
                          color: priceColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        '€/L',
                        style: TextStyle(
                          color: priceColor.withAlpha(179),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        station.name,
                        style: TextStyle(
                          color: AppColors.text,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Actions
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () async {
                      final url = Uri.parse(
                        'https://www.google.com/maps/dir/?api=1&destination=${station.latitude},${station.longitude}',
                      );
                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                    icon: const Icon(Icons.directions_rounded, size: 20),
                    label: const Text('Cómo llegar'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: onClose,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
