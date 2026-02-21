/// Main shell with bottom navigation bar
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gas_stations_provider.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadInitialData();
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: IndexedStack(
        index: _pageIndex,
        children: const [ListScreenRedesigned(), MapScreenRedesigned()],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<GasStationsProvider>(
      builder: (context, provider, _) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.outlineVariant,
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
    final theme = Theme.of(context);
    final color = selected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant;

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
    final theme = Theme.of(context);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withAlpha(80),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.colorScheme.primary.withAlpha(50),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.local_gas_station_rounded,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      selectedFuelType,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
