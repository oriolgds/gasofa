import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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
