/// Main shell with bottom navigation bar
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/constants.dart';
import '../providers/gas_stations_provider.dart';
import '../services/update_service.dart';
import '../widgets/fuel_picker_sheet.dart';
import 'list_screen.dart';
import 'map_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _pageIndex = 0;
  final _updateService = UpdateService();
  bool _updateAvailable = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadInitialData();
      await _updateService.checkForUpdate();
      if (mounted && _updateService.updateAvailable) {
        setState(() => _updateAvailable = true);
      }
    });
  }

  Future<void> _loadInitialData() async {
    final provider = context.read<GasStationsProvider>();
    await provider.fetchUserLocation();
    await provider.fetchStations();
  }

  void _onNavTap(int index) {
    if (index == 1) {
      final provider = context.read<GasStationsProvider>();
      showFuelPickerSheet(context, provider);
      return;
    }
    setState(() => _pageIndex = index == 0 ? 0 : 1);
  }

  int get _navIndex => _pageIndex == 0 ? 0 : 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _pageIndex,
        children: const [ListScreenRedesigned(), MapScreenRedesigned()],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Consumer<GasStationsProvider>(
      builder: (context, provider, _) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(
              top: BorderSide(
                color: AppColors.textLight.withAlpha(40),
                width: 0.5,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 60,
              child: Row(
                children: [
                  _NavItem(
                    icon: Icons.format_list_bulleted_rounded,
                    label: 'Lista',
                    selected: _navIndex == 0,
                    onTap: () => _onNavTap(0),
                  ),
                  _FuelNavItem(
                    selectedFuelType: provider.selectedFuelType.displayName,
                    onTap: () => _onNavTap(1),
                  ),
                  _NavItem(
                    icon: Icons.map_outlined,
                    label: 'Mapa',
                    selected: _navIndex == 2,
                    onTap: () => _onNavTap(2),
                  ),
                  if (_updateAvailable)
                    _UpdateNavItem(
                      onTap: () async {
                        await _updateService.startFlexibleUpdate();
                        setState(() => _updateAvailable = false);
                      },
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Standard nav item ──────────────────────────────────────────────────────

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textLight;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Fuel selector nav item (centre) ────────────────────────────────────────

class _FuelNavItem extends StatelessWidget {
  final String selectedFuelType;
  final VoidCallback onTap;

  const _FuelNavItem({required this.selectedFuelType, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // A simple icon + tiny selector arrow — nothing fancy
            Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.local_gas_station_rounded,
                  size: 24,
                  color: AppColors.textSecondary,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.swap_vert_rounded,
                      size: 9,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              selectedFuelType,
              style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Update notification item ───────────────────────────────────────────────

class _UpdateNavItem extends StatelessWidget {
  final VoidCallback onTap;

  const _UpdateNavItem({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 64,
        height: double.infinity,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.priceGood.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.system_update_rounded,
                size: 16,
                color: AppColors.priceGood,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'Actualizar',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.priceGood,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
