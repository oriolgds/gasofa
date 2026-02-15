/// Home screen with search options and tab navigation
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gas_stations_provider.dart';
import '../widgets/fuel_type_selector.dart';
import '../widgets/province_dropdown.dart';
import 'list_screen.dart';
import 'map_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(theme),

            // Fuel type selector
            const SizedBox(height: 16),
            Consumer<GasStationsProvider>(
              builder: (context, provider, _) => FuelTypeSelector(
                selectedFuelType: provider.selectedFuelType,
                onChanged: provider.setFuelType,
              ),
            ),

            // Province selector
            Padding(
              padding: const EdgeInsets.all(16),
              child: Consumer<GasStationsProvider>(
                builder: (context, provider, _) => ProvinceDropdown(
                  selectedProvinceCode: provider.selectedProvinceCode,
                  onChanged: provider.setProvince,
                  useLocation: provider.useLocation,
                  onUseLocationTap: () async {
                    if (!provider.useLocation) {
                      await provider.fetchUserLocation();
                    }
                    provider.setUseLocation(!provider.useLocation);
                  },
                ),
              ),
            ),

            // Search button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Consumer<GasStationsProvider>(
                builder: (context, provider, _) => SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: provider.loadingState == LoadingState.loading
                        ? null
                        : () => provider.fetchStations(),
                    icon: provider.loadingState == LoadingState.loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.search),
                    label: Text(
                      provider.loadingState == LoadingState.loading
                          ? 'Buscando...'
                          : 'Buscar gasolineras',
                    ),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Tab bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withOpacity(
                  0.5,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: theme.colorScheme.onPrimary,
                unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                tabs: const [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.list, size: 20),
                        SizedBox(width: 8),
                        Text('Lista'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, size: 20),
                        SizedBox(width: 8),
                        Text('Mapa'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Tab view
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [ListScreenRedesigned(), MapScreenRedesigned()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '⛽ GASOFA',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.info_outline, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Encuentra la gasolina más barata cerca de ti',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}
