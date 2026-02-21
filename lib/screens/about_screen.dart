import 'dart:async';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/update_service.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo and Name
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Assuming logo is available as asset, otherwise using icon
                  Container(
                    width: 100,
                    height: 100,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(26),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/icon/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'GASOFA',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          'Versión ${snapshot.data!.version} (Build ${snapshot.data!.buildNumber})',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 16),
                  const _UpdateCard(),
                  const SizedBox(height: 32),
                ],
              ),
            ),

            _buildSectionTitle(theme, 'Aviso Legal y Fuente de Datos'),
            const SizedBox(height: 16),

            _buildInfoCard(
              theme,
              children: [
                Text(
                  'Renuncia de responsabilidad:',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Gasofa es una aplicación independiente desarrollada por terceros y NO está afiliada, asociada, autorizada, respaldada ni conectada oficialmente de ninguna manera con el Ministerio para la Transición Ecológica y el Reto Demográfico de España, ni con ninguna otra entidad gubernamental.',
                ),
                const Divider(height: 24),
                Text(
                  'Fuente de la información:',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Los datos de precios y ubicaciones de las estaciones de servicio mostrados en esta aplicación son de carácter público y se obtienen directamente del Geoportal de Hidrocarburos del Ministerio para la Transición Ecológica y el Reto Demográfico.',
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () => _launchUrl('https://geoportalgasolineras.es/'),
                  child: Text(
                    'https://geoportalgasolineras.es/',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Esta aplicación se limita a recopilar y visualizar dicha información pública para facilitar su consulta por parte de los usuarios, sin modificar los datos originales.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),

            const SizedBox(height: 32),
            _buildSectionTitle(theme, 'Desarrollador'),
            const SizedBox(height: 16),

            _buildInfoCard(
              theme,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.secondaryContainer,
                    child: Text(
                      'OG',
                      style: TextStyle(
                        color: theme.colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                  title: const Text('Oriol Giner'),
                  subtitle: const Text('Desarrollador Full Stack'),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(),
                ),
                _buildLinkRow(
                  theme,
                  Icons.link,
                  'LinkedIn',
                  'https://www.linkedin.com/in/oriol-giner/',
                ),
                const SizedBox(height: 12),
                _buildLinkRow(
                  theme,
                  Icons.language,
                  'Portfolio',
                  'https://oriol.is-a.dev/',
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  Widget _buildInfoCard(ThemeData theme, {required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildLinkRow(
    ThemeData theme,
    IconData icon,
    String label,
    String url,
  ) {
    return InkWell(
      onTap: () => _launchUrl(url),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _UpdateCard extends StatefulWidget {
  const _UpdateCard();

  @override
  State<_UpdateCard> createState() => _UpdateCardState();
}

class _UpdateCardState extends State<_UpdateCard>
    with TickerProviderStateMixin {
  bool _isChecking = false;
  bool? _isUpToDate;

  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _checkUpdate(UpdateService updateService) async {
    setState(() {
      _isChecking = true;
      _isUpToDate = null;
    });

    _rotationController.repeat();
    _pulseController.repeat(reverse: true);

    // Minimum delay for UI polish
    final minDelay = Future.delayed(const Duration(milliseconds: 2000));
    await Future.wait([updateService.checkForUpdate(), minDelay]);

    if (!mounted) return;

    _rotationController.stop();
    _pulseController.stop();
    _pulseController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

    setState(() {
      _isChecking = false;
      _isUpToDate = !updateService.updateAvailable;
    });

    // Revert visual state after 4 seconds if it was up to date
    if (_isUpToDate == true) {
      Future.delayed(const Duration(seconds: 4), () {
        if (mounted) setState(() => _isUpToDate = null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final updateService = context.watch<UpdateService>();

    Color cardColor;
    Color iconColor;
    Color textColor;
    Widget icon;
    String title;
    String subtitle;
    Widget? actionButton;

    if (_isChecking) {
      cardColor = theme.colorScheme.surfaceContainerHighest;
      iconColor = theme.colorScheme.primary;
      textColor = theme.colorScheme.onSurface;
      icon = RotationTransition(
        turns: _rotationController,
        child: Icon(Icons.sync_rounded, color: iconColor, size: 28),
      );
      title = 'Buscando actualizaciones...';
      subtitle = 'Comprobando la última versión disponible';
    } else if (_isUpToDate == true) {
      cardColor = Colors.green.withAlpha(20);
      iconColor = Colors.green;
      textColor = theme.colorScheme.onSurface;
      icon = Icon(Icons.check_circle_rounded, color: iconColor, size: 28);
      title = '¡Estás al día!';
      subtitle = 'Tienes la versión más reciente instalada';
    } else if (updateService.updateAvailable) {
      cardColor = theme.colorScheme.primaryContainer.withAlpha(50);
      iconColor = theme.colorScheme.primary;
      textColor = theme.colorScheme.onSurface;
      icon = Icon(Icons.system_update_rounded, color: iconColor, size: 28);
      title = 'Actualización disponible';
      subtitle =
          'Descarga la última versión para disfrutar de nuevas funciones';
      actionButton = FilledButton.icon(
        onPressed: () {
          updateService.startFlexibleUpdate();
        },
        icon: const Icon(Icons.download_rounded),
        label: const Text('Actualizar ahora'),
        style: FilledButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        ),
      );
    } else {
      cardColor = theme.colorScheme.surface;
      iconColor = theme.colorScheme.primary;
      textColor = theme.colorScheme.onSurface;
      icon = Icon(Icons.update_rounded, color: iconColor, size: 28);
      title = 'Buscar actualizaciones';
      subtitle = 'Mantén la app actualizada para el mejor rendimiento';
      actionButton = OutlinedButton.icon(
        onPressed: () => _checkUpdate(updateService),
        icon: const Icon(Icons.search_rounded),
        label: const Text('Comprobar ahora'),
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.primary,
          side: BorderSide(color: theme.colorScheme.primary.withAlpha(100)),
        ),
      );
    }

    return ScaleTransition(
      scale: _isChecking ? _scaleAnimation : const AlwaysStoppedAnimation(1.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.fastOutSlowIn,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _isUpToDate == true
                ? Colors.green.withAlpha(100)
                : theme.colorScheme.outlineVariant.withAlpha(100),
          ),
          boxShadow: [
            BoxShadow(
              color: _isChecking
                  ? theme.colorScheme.primary.withAlpha(40)
                  : Colors.black.withAlpha(
                      theme.brightness == Brightness.dark ? 20 : 10,
                    ),
              blurRadius: _isChecking ? 24 : 15,
              spreadRadius: _isChecking ? 2 : 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconColor.withAlpha(26),
                    shape: BoxShape.circle,
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: FadeTransition(opacity: animation, child: child),
                      );
                    },
                    child: SizedBox(key: ValueKey(title), child: icon),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        transitionBuilder: (child, animation) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.0, 0.2),
                              end: Offset.zero,
                            ).animate(animation),
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                        child: Text(
                          title,
                          key: ValueKey(title),
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        transitionBuilder: (child, animation) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.0, 0.2),
                              end: Offset.zero,
                            ).animate(animation),
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                        child: Text(
                          subtitle,
                          key: ValueKey(subtitle),
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 13,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
              alignment: Alignment.topCenter,
              child: actionButton != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: AnimatedOpacity(
                        opacity: 1.0,
                        duration: const Duration(milliseconds: 500),
                        child: SizedBox(
                          width: double.infinity,
                          child: actionButton,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
