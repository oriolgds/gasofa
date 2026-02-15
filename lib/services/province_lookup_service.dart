/// Service to map coordinates to Spanish provinces and find nearby provinces
library;

class ProvinceLookupService {
  static final ProvinceLookupService _instance =
      ProvinceLookupService._internal();
  factory ProvinceLookupService() => _instance;
  ProvinceLookupService._internal();

  /// Map of province codes to their approximate bounding boxes [minLat, maxLat, minLon, maxLon]
  static const Map<String, List<double>> _provinceBounds = {
    // Andalucía
    '04': [36.7, 37.5, -3.0, -1.5], // Almería
    '11': [36.0, 37.0, -6.5, -5.3], // Cádiz
    '14': [37.0, 38.8, -5.5, -4.0], // Córdoba
    '18': [36.7, 37.8, -4.0, -2.4], // Granada
    '21': [37.1, 38.0, -7.6, -6.2], // Huelva
    '23': [37.5, 38.6, -4.0, -2.5], // Jaén
    '29': [36.4, 37.3, -5.6, -4.0], // Málaga
    '41': [36.8, 38.0, -6.5, -4.9], // Sevilla
    // Aragón
    '22': [41.4, 42.9, -1.0, 0.8], // Huesca
    '44': [39.8, 41.2, -2.3, -0.2], // Teruel
    '50': [41.0, 42.4, -2.0, -0.5], // Zaragoza
    // Asturias
    '33': [42.9, 43.7, -7.2, -4.5], // Asturias
    // Baleares
    '07': [38.6, 40.1, 1.2, 4.4], // Baleares
    // Canarias
    '35': [27.6, 29.5, -18.2, -13.4], // Las Palmas
    '38': [27.6, 29.4, -18.2, -13.3], // Santa Cruz de Tenerife
    // Cantabria
    '39': [42.8, 43.5, -4.9, -3.2], // Cantabria
    // Castilla-La Mancha
    '02': [38.4, 39.7, -3.0, -1.1], // Albacete
    '13': [38.5, 39.9, -5.0, -3.0], // Ciudad Real
    '16': [39.5, 40.9, -3.3, -1.4], // Cuenca
    '19': [40.1, 41.3, -3.5, -1.6], // Guadalajara
    '45': [39.2, 40.4, -5.5, -3.7], // Toledo
    // Castilla y León
    '05': [40.0, 41.3, -5.7, -4.2], // Ávila
    '09': [41.7, 43.0, -4.2, -2.7], // Burgos
    '24': [42.0, 43.2, -7.2, -5.0], // León
    '34': [41.7, 43.0, -5.2, -3.7], // Palencia
    '37': [40.3, 41.4, -7.0, -5.6], // Salamanca
    '40': [40.8, 42.0, -4.6, -3.0], // Segovia
    '42': [41.2, 42.3, -3.5, -1.7], // Soria
    '47': [41.2, 42.3, -5.8, -4.3], // Valladolid
    '49': [41.2, 42.4, -6.9, -5.2], // Zamora
    // Cataluña
    '08': [41.2, 42.5, 1.0, 3.3], // Barcelona
    '17': [41.6, 42.5, 2.1, 3.4], // Girona
    '25': [41.5, 42.9, 0.5, 1.8], // Lleida
    '43': [40.5, 41.5, 0.2, 1.6], // Tarragona
    // Comunidad Valenciana
    '03': [38.0, 39.0, -1.0, 0.0], // Alicante
    '12': [39.6, 40.9, -0.8, 0.6], // Castellón
    '46': [38.7, 40.1, -1.5, -0.2], // Valencia
    // Extremadura
    '06': [37.9, 39.7, -7.6, -5.0], // Badajoz
    '10': [39.2, 40.5, -6.9, -5.1], // Cáceres
    // Galicia
    '15': [42.6, 43.8, -9.3, -7.7], // A Coruña
    '27': [42.2, 43.8, -7.7, -6.7], // Lugo
    '32': [41.8, 42.8, -8.5, -6.7], // Ourense
    '36': [42.0, 42.8, -9.0, -8.4], // Pontevedra
    // Madrid
    '28': [39.9, 41.2, -4.6, -3.1], // Madrid
    // Murcia
    '30': [37.4, 38.8, -2.4, -0.6], // Murcia
    // Navarra
    '31': [41.9, 43.2, -2.5, -0.8], // Navarra
    // País Vasco
    '01': [42.5, 43.2, -3.2, -2.3], // Álava
    '48': [43.0, 43.5, -3.1, -2.6], // Bizkaia
    '20': [42.9, 43.4, -2.5, -1.7], // Gipuzkoa
    // La Rioja
    '26': [41.9, 42.7, -3.2, -1.7], // La Rioja
    // Ceuta y Melilla
    '51': [35.8, 35.9, -5.4, -5.3], // Ceuta
    '52': [35.2, 35.3, -2.9, -2.9], // Melilla
  };

  /// Map of province codes to their neighboring provinces
  static const Map<String, List<String>> _provinceAdjacency = {
    '04': ['18', '29', '23'], // Almería
    '11': ['29', '41'], // Cádiz
    '14': ['41', '18', '23', '13'], // Córdoba
    '18': ['04', '29', '14', '23', '02'], // Granada
    '21': ['41', '06'], // Huelva
    '23': ['18', '14', '13', '02'], // Jaén
    '29': ['11', '41', '14', '18', '04'], // Málaga
    '41': ['21', '06', '10', '14', '29', '11'], // Sevilla
    '22': ['50', '31', '25'], // Huesca
    '44': ['50', '42', '16', '12', '43'], // Teruel
    '50': ['22', '31', '26', '42', '19', '40', '44'], // Zaragoza
    '33': ['27', '24', '39'], // Asturias
    '39': ['33', '24', '09', '01'], // Cantabria
    '02': ['13', '16', '12', '46', '30', '18', '23'], // Albacete
    '13': ['45', '10', '06', '14', '23', '02', '16'], // Ciudad Real
    '16': ['28', '19', '44', '12', '46', '02', '13', '45'], // Cuenca
    '19': ['28', '40', '42', '50', '44', '16'], // Guadalajara
    '45': ['28', '05', '10', '13', '16'], // Toledo
    '05': ['28', '40', '47', '37', '10', '45'], // Ávila
    '09': ['39', '34', '26', '42', '40'], // Burgos
    '24': ['33', '27', '32', '49', '47', '34'], // León
    '34': ['24', '39', '09', '47'], // Palencia
    '37': ['05', '47', '49', '10', '06'], // Salamanca
    '40': ['05', '28', '19', '42', '09', '47'], // Segovia
    '42': ['40', '19', '50', '26', '09'], // Soria
    '47': ['49', '37', '05', '40', '09', '34', '24'], // Valladolid
    '49': ['32', '27', '24', '47', '37'], // Zamora
    '08': ['17', '25', '43', '46'], // Barcelona
    '17': ['25', '08'], // Girona
    '25': ['22', '17', '08', '43'], // Lleida
    '43': ['25', '08', '46', '44'], // Tarragona
    '03': ['30', '02', '46'], // Alicante
    '12': ['44', '16', '46', '43'], // Castellón
    '46': ['12', '44', '16', '02', '03', '08', '43'], // Valencia
    '06': ['10', '13', '14', '41', '21', '37'], // Badajoz
    '10': ['05', '45', '13', '06', '37', '40'], // Cáceres
    '15': ['27', '36'], // A Coruña
    '27': ['15', '33', '24', '32', '36'], // Lugo
    '32': ['49', '24', '27', '36'], // Ourense
    '36': ['15', '27', '32'], // Pontevedra
    '28': ['40', '19', '16', '45', '05'], // Madrid
    '30': ['02', '03'], // Murcia
    '31': ['22', '50', '26', '20', '01'], // Navarra
    '01': ['39', '09', '26', '31', '48'], // Álava
    '48': ['20', '01'], // Bizkaia
    '20': ['31', '01', '48'], // Gipuzkoa
    '26': ['31', '50', '42', '09', '01'], // La Rioja
    '07': [], // Baleares (island)
    '35': [], // Las Palmas (island)
    '38': [], // Santa Cruz de Tenerife (island)
    '51': [], // Ceuta (enclave)
    '52': [], // Melilla (enclave)
  };

  /// Get province code from coordinates
  /// Returns null if coordinates don't match any province
  String? getProvinceCodeFromCoordinates(double lat, double lon) {
    for (final entry in _provinceBounds.entries) {
      final bounds = entry.value;
      final minLat = bounds[0];
      final maxLat = bounds[1];
      final minLon = bounds[2];
      final maxLon = bounds[3];

      if (lat >= minLat && lat <= maxLat && lon >= minLon && lon <= maxLon) {
        return entry.key;
      }
    }
    return null;
  }

  /// Get list of neighboring province codes
  /// Returns empty list if province code not found
  List<String> getNearbyProvinceCodes(String provinceCode) {
    return _provinceAdjacency[provinceCode] ?? [];
  }

  /// Get all province codes except the specified ones
  /// Useful for getting remaining provinces to load in background
  /// Get list of province codes that intersect with the given bounds
  List<String> getProvincesInBounds(
    double minLat,
    double maxLat,
    double minLon,
    double maxLon,
  ) {
    final List<String> intersectingProvinces = [];

    for (final entry in _provinceBounds.entries) {
      final bounds = entry.value;
      final pMinLat = bounds[0];
      final pMaxLat = bounds[1];
      final pMinLon = bounds[2];
      final pMaxLon = bounds[3];

      // Check for intersection
      // A rectangle intersects another if they overlap on both axes
      bool latOverlap = (minLat <= pMaxLat) && (maxLat >= pMinLat);
      bool lonOverlap = (minLon <= pMaxLon) && (maxLon >= pMinLon);

      if (latOverlap && lonOverlap) {
        intersectingProvinces.add(entry.key);
      }
    }

    return intersectingProvinces;
  }
}
