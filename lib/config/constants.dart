/// App-wide constants for GASOFA - Pastel Theme
library;

import 'dart:ui';

class AppColors {
  // Pastel color palette
  static const primary = Color(0xFF7C9EB2); // Dusty blue
  static const primaryLight = Color(0xFFB8D4E3); // Light sky blue
  static const secondary = Color(0xFFA8D5BA); // Sage green
  static const accent = Color(0xFFF2C4DE); // Soft pink

  static const background = Color(0xFFFAF9F7); // Warm white
  static const surface = Color(0xFFFFFFFF); // Pure white
  static const surfaceVariant = Color(0xFFF5F3EF); // Cream

  static const text = Color(0xFF2D3436); // Charcoal
  static const textSecondary = Color(0xFF636E72); // Gray
  static const textLight = Color(0xFFB2BEC3); // Light gray

  // Price colors - softer pastels
  static const priceGood = Color(0xFF81C784); // Soft green
  static const priceMedium = Color(0xFFFFD54F); // Soft yellow
  static const priceHigh = Color(0xFFE57373); // Soft red

  // Gradient colors
  static const gradientStart = Color(0xFFE8F4F8); // Very light blue
  static const gradientEnd = Color(0xFFFCE4EC); // Very light pink
}

class ApiConstants {
  static const baseUrl =
      'https://sedeaplicaciones.minetur.gob.es/ServiciosRESTCarburantes/PreciosCarburantes';
  static const allStations = '/EstacionesTerrestres/';
  static const stationsByProvince = '/EstacionesTerrestres/FiltroProvincia/';
  static const fuelTypes = '/Listados/ProductosPetroliferos/';
  static const provinces = '/Listados/Provincias/';
}

/// Province codes for Spain
const Map<String, String> provincesCodes = {
  "15": "A Coruña",
  "01": "Álava",
  "02": "Albacete",
  "03": "Alicante",
  "04": "Almería",
  "33": "Asturias",
  "05": "Ávila",
  "06": "Badajoz",
  "08": "Barcelona",
  "48": "Bizkaia",
  "09": "Burgos",
  "10": "Cáceres",
  "11": "Cádiz",
  "39": "Cantabria",
  "12": "Castellón",
  "51": "Ceuta",
  "13": "Ciudad Real",
  "14": "Córdoba",
  "16": "Cuenca",
  "20": "Gipuzkoa",
  "17": "Girona",
  "18": "Granada",
  "19": "Guadalajara",
  "21": "Huelva",
  "22": "Huesca",
  "07": "Illes Balears",
  "23": "Jaén",
  "26": "La Rioja",
  "35": "Las Palmas",
  "24": "León",
  "25": "Lleida",
  "27": "Lugo",
  "28": "Madrid",
  "29": "Málaga",
  "52": "Melilla",
  "30": "Murcia",
  "31": "Navarra",
  "32": "Ourense",
  "34": "Palencia",
  "36": "Pontevedra",
  "37": "Salamanca",
  "38": "Santa Cruz de Tenerife",
  "40": "Segovia",
  "41": "Sevilla",
  "42": "Soria",
  "43": "Tarragona",
  "44": "Teruel",
  "45": "Toledo",
  "46": "Valencia",
  "47": "Valladolid",
  "49": "Zamora",
  "50": "Zaragoza",
};
