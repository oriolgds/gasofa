/// Redesigned map screen with always-visible stations and price markers
library;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/constants.dart';
import '../models/gas_station.dart';
import '../providers/gas_stations_provider.dart';
import '../services/update_service.dart';
import '../widgets/fuel_picker_sheet.dart';
import 'about_screen.dart';

class MapScreenRedesigned extends StatefulWidget {
  const MapScreenRedesigned({super.key});

  @override
  State<MapScreenRedesigned> createState() => _MapScreenRedesignedState();
}

class _MapScreenRedesignedState extends State<MapScreenRedesigned> {
  final MapController _mapController = MapController();
  Timer? _debounce;
  GasStation? _selectedStation;
  LatLngBounds? _currentBounds;
  double _currentZoom = 6.0;

  int _selectedLayerIndex = 0;
  final List<Map<String, String>> _mapLayers = [
    {
      'name': 'Estándar (OSM)',
      'url': 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    },
    {
      'name': 'Carto Claro',
      'url': 'https://a.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
    },
    {
      'name': 'Carto Oscuro',
      'url': 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
    },
    {
      'name': 'Topográfico',
      'url': 'https://a.tile.opentopomap.org/{z}/{x}/{y}.png',
    },
  ];

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final updateService = context.watch<UpdateService>();
    final updateAvailable = updateService.updateAvailable;

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
        } else if (provider.allFilteredStations.isNotEmpty) {
          final stations = provider.allFilteredStations;
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
                maxZoom: 18.0,
                onMapReady: () {
                  if (mounted) {
                    setState(() {
                      _currentBounds = _mapController.camera.visibleBounds;
                      _currentZoom = _mapController.camera.zoom;
                    });
                  }
                },
                onTap: (_, _) => setState(() => _selectedStation = null),
                onPositionChanged: (position, hasGesture) {
                  // Debounce map updates to prevent lag
                  if (_debounce?.isActive ?? false) _debounce!.cancel();
                  _debounce = Timer(const Duration(milliseconds: 200), () {
                    if (mounted) {
                      setState(() {
                        _currentBounds = position.visibleBounds;
                        _currentZoom = position.zoom;
                      });
                    }
                  });
                },
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                ),
              ),
              children: [
                // Map tiles based on selected layer
                TileLayer(
                  urlTemplate: _mapLayers[_selectedLayerIndex]['url']!,
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
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary.withAlpha(77),
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
                    // Use optimized grid-based filtering
                    List<GasStation> stations;

                    if (_currentBounds != null) {
                      stations = provider.getStationsForMap(
                        bounds: _currentBounds!,
                        zoom: _currentZoom,
                      );
                    } else {
                      // Fallback if no bounds yet (e.g. init)
                      // Don't show anything until we know where we are, or show filtered if few
                      if (provider.allFilteredStations.length < 50) {
                        stations = provider.allFilteredStations;
                      } else {
                        stations = [];
                      }
                    }

                    // Add price category to each station for sorting
                    final stationsWithCategory = stations.map((station) {
                      final priceCategory = provider.getCategoryForPrice(
                        station.getPrice(provider.selectedFuelType),
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
                decoration: BoxDecoration(color: theme.colorScheme.surface),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => showFuelPickerSheet(context, provider),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(
                                theme.brightness == Brightness.dark ? 25 : 13,
                              ),
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
                              color: theme.colorScheme.onSurface,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              provider.selectedFuelType.displayName,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 16,
                              color: theme.colorScheme.onSurface,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Update Button
                    if (updateAvailable)
                      GestureDetector(
                        onTap: () => updateService.startFlexibleUpdate(),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.priceGood.withAlpha(50),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(
                                  theme.brightness == Brightness.dark ? 25 : 13,
                                ),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.system_update_rounded,
                            color: AppColors.priceGood,
                            size: 22,
                          ),
                        ),
                      ),
                    // Info Button
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AboutScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(
                                theme.brightness == Brightness.dark ? 25 : 13,
                              ),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.info_outline_rounded,
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Loading Indicator (Moved below Info Button)
            if (provider.loadingState == LoadingState.loading ||
                provider.loadingState == LoadingState.syncing ||
                provider.processingStatus != null)
              Positioned(
                top:
                    MediaQuery.of(context).padding.top +
                    60, // Below info button
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(
                          theme.brightness == Brightness.dark ? 25 : 13,
                        ),
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
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          provider.processingStatus ??
                              provider.syncStatus ??
                              'Cargando...',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Map Controls (Layers, Zoom, Recenter)
            Positioned(
              right: 16,
              bottom: _selectedStation != null ? 180 : 100,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Layers button
                  PopupMenuButton<int>(
                    initialValue: _selectedLayerIndex,
                    onSelected: (int index) {
                      setState(() {
                        _selectedLayerIndex = index;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    offset: const Offset(-10, 0),
                    itemBuilder: (BuildContext context) {
                      return List<PopupMenuEntry<int>>.generate(
                        _mapLayers.length,
                        (int index) {
                          return PopupMenuItem<int>(
                            value: index,
                            child: Row(
                              children: [
                                Icon(
                                  index == _selectedLayerIndex
                                      ? Icons.check_circle_rounded
                                      : Icons.radio_button_unchecked,
                                  color: index == _selectedLayerIndex
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurfaceVariant,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _mapLayers[index]['name']!,
                                  style: TextStyle(
                                    fontWeight: index == _selectedLayerIndex
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(
                              theme.brightness == Brightness.dark ? 25 : 20,
                            ),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.layers_rounded,
                        color: theme.colorScheme.primary,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Zoom controls
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(
                            theme.brightness == Brightness.dark ? 25 : 20,
                          ),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            final currentZoom = _mapController.camera.zoom;
                            if (currentZoom < 18.0) {
                              _mapController.move(
                                _mapController.camera.center,
                                currentZoom + 1.0,
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Icon(
                              Icons.add_rounded,
                              color: theme.colorScheme.primary,
                              size: 22,
                            ),
                          ),
                        ),
                        Container(
                          height: 1,
                          width: 24,
                          color: theme.colorScheme.outlineVariant,
                        ),
                        GestureDetector(
                          onTap: () {
                            final currentZoom = _mapController.camera.zoom;
                            if (currentZoom > 3.0) {
                              _mapController.move(
                                _mapController.camera.center,
                                currentZoom - 1.0,
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Icon(
                              Icons.remove_rounded,
                              color: theme.colorScheme.primary,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Re-center button
                  if (provider.userPosition != null) ...[
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () async {
                        await provider.fetchUserLocation();
                        if (provider.userPosition != null) {
                          _mapController.move(
                            LatLng(
                              provider.userPosition!.latitude,
                              provider.userPosition!.longitude,
                            ),
                            14.0,
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(
                                theme.brightness == Brightness.dark ? 25 : 20,
                              ),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.my_location_rounded,
                          color: theme.colorScheme.primary,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ],
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
    final priceCategory = provider.getCategoryForPrice(price);

    final Color priceColor = switch (priceCategory) {
      PriceCategory.low => AppColors.priceGood,
      PriceCategory.medium => AppColors.priceMedium,
      PriceCategory.high => AppColors.priceHigh,
      PriceCategory.unknown => AppColors.textLight,
    };

    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(
              theme.brightness == Brightness.dark ? 40 : 26,
            ),
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
                color: theme.colorScheme.outlineVariant,
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
                          color: theme.colorScheme.onSurface,
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
                          color: theme.colorScheme.onSurfaceVariant,
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
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
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
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      color: theme.colorScheme.onSurfaceVariant,
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
