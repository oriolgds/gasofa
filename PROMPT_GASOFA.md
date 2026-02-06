# 🛢️ GASOFA - App de Precios de Gasolina

## 📋 Descripción General

Crea una aplicación Flutter para consultar y comparar precios de combustible en estaciones de servicio de España. La aplicación debe ser **simple, intuitiva y visualmente atractiva**, permitiendo a los usuarios encontrar las gasolineras más baratas cerca de su ubicación.

---

## 🎯 Objetivos Principales

1. **Consultar precios de carburantes** en tiempo real desde la API oficial del Ministerio
2. **Buscar gasolineras** por ubicación del usuario o por provincia
3. **Ordenar resultados** por distancia y/o precio
4. **Visualizar gasolineras** en mapa (Google Maps) y en formato lista
5. **Filtrar por tipo de combustible** según las preferencias del usuario

---

## 🏗️ Arquitectura y Tecnología

### Stack Tecnológico
- **Framework**: Flutter (última versión estable)
- **Lenguaje**: Dart
- **Mapas**: Google Maps Flutter Plugin (`google_maps_flutter`)
- **HTTP Client**: `http` o `dio`
- **Estado**: Provider, Riverpod o BLoC (elegir uno)
- **Geolocalización**: `geolocator` + `geocoding`
- **Permisos**: `permission_handler`

### Estructura de Carpetas Recomendada
```
lib/
├── main.dart
├── app.dart
├── config/
│   └── constants.dart
├── models/
│   ├── gas_station.dart
│   ├── fuel_type.dart
│   └── province.dart
├── services/
│   ├── api_service.dart
│   ├── location_service.dart
│   └── distance_service.dart
├── providers/ (o bloc/)
│   └── gas_stations_provider.dart
├── screens/
│   ├── home_screen.dart
│   ├── map_screen.dart
│   └── list_screen.dart
├── widgets/
│   ├── gas_station_card.dart
│   ├── fuel_type_selector.dart
│   ├── province_dropdown.dart
│   ├── price_badge.dart
│   └── custom_marker.dart
└── utils/
    ├── formatters.dart
    └── distance_calculator.dart
```

---

## 🌐 API - Ministerio de Industria y Energía

### Base URL
```
https://sedeaplicaciones.minetur.gob.es/ServiciosRESTCarburantes/PreciosCarburantes/
```

### Endpoints Principales

#### 1. Obtener todas las estaciones
```
GET /EstacionesTerrestres/
```

#### 2. Filtrar por provincia
```
GET /EstacionesTerrestres/FiltroProvincia/{IDProvincia}
```
Ejemplo Barcelona: `/EstacionesTerrestres/FiltroProvincia/08`

#### 3. Lista de productos petrolíferos (tipos de combustible)
```
GET /Listados/ProductosPetroliferos/
```

#### 4. Lista de provincias
```
GET /Listados/Provincias/
```

### Estructura de Respuesta JSON

```json
{
  "Fecha": "06/02/2026 23:00:00",
  "ListaEESSPrecio": [...],
  "Nota": "Información de carácter informativo...",
  "ResultadoConsulta": "OK"
}
```

### Modelo de Estación de Servicio (Campos Clave)

| Campo API | Descripción | Tipo |
|-----------|-------------|------|
| `IDEESS` | ID único de la estación | String |
| `Rótulo` | Marca/Nombre (REPSOL, CEPSA, BP...) | String |
| `Dirección` | Dirección de la calle | String |
| `C.P.` | Código postal | String |
| `Localidad` | Localidad | String |
| `Municipio` | Municipio | String |
| `Provincia` | Provincia | String |
| `Latitud` | Latitud (formato "41,385064") | String* |
| `Longitud (WGS84)` | Longitud (formato "2,173404") | String* |
| `Horario` | Horario de apertura | String |
| `Margen` | Margen de carretera (D/I) | String |
| `Tipo Venta` | Tipo de venta (P: Público) | String |

> ⚠️ **IMPORTANTE**: Los campos con coordenadas y precios usan **coma** como separador decimal. Debes convertirlos a `double` reemplazando `,` por `.`

### Campos de Precios de Combustible

| Campo API (codificado) | Combustible |
|------------------------|-------------|
| `Precio Gasolina 95 E5` | Gasolina 95 |
| `Precio Gasolina 98 E5` | Gasolina 98 |
| `Precio Gasoleo A` | Diésel A |
| `Precio Gasoleo B` | Diésel B |
| `Precio Gasoleo Premium` | Diésel Premium |
| `Precio Gases licuados del petróleo` | GLP/Autogas |
| `Precio Gas Natural Comprimido` | GNC |
| `Precio Hidrogeno` | Hidrógeno |

> 📝 **Nota**: Los nombres de campo en JSON usan códigos hexadecimales para espacios (`_x0020_`) y caracteres especiales. Ejemplo: `Precio_x0020_Gasolina_x0020_95_x0020_E5`

### Códigos de Provincias

```dart
const Map<String, String> provincias = {
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
```

---

## 📱 Pantallas y Funcionalidades

### 1. Pantalla Principal (Home)
- **Selector de tipo de combustible** (dropdown o chips)
- **Selector de provincia** (dropdown con opción "Ubicación actual")
- **Botón de búsqueda**
- **Toggle** para cambiar entre vista Mapa y Lista
- **Indicador de carga** mientras se obtienen datos

### 2. Pantalla de Mapa
- **Google Maps** con la ubicación del usuario centrada
- **Marcadores personalizados** para cada gasolinera
  - Color según precio (verde = barato, amarillo = medio, rojo = caro)
  - Info window al pulsar con nombre, precio y distancia
- **Botón flotante** para re-centrar en ubicación actual
- **Bottom sheet** con detalles de la gasolinera seleccionada
- **Navegación** a Google Maps para obtener direcciones

### 3. Pantalla de Lista
- **Lista ordenable** por:
  - Precio (más barato primero)
  - Distancia (más cercano primero)
  - Combinado (mejor relación precio-distancia)
- **Cards de gasolinera** mostrando:
  - Logo/icono de la marca
  - Nombre y dirección
  - Precio del combustible seleccionado
  - Distancia desde ubicación del usuario
  - Indicador visual de precio (badge de color)
- **Pull to refresh** para actualizar datos
- **Acción de tap** para ver en mapa o abrir navegación

---

## 🎨 Diseño UI/UX

### Principios de Diseño
- **Minimalista**: Interfaz limpia sin elementos innecesarios
- **Colores claros**: Fondo blanco/gris claro, acentos en azul/verde
- **Iconografía clara**: Iconos intuitivos para combustibles y acciones
- **Feedback visual**: Estados de carga, errores claros, animaciones sutiles

### Paleta de Colores Sugerida
```dart
// Colores principales
static const Color primary = Color(0xFF2563EB);      // Azul
static const Color secondary = Color(0xFF10B981);    // Verde
static const Color background = Color(0xFFF8FAFC);   // Gris muy claro
static const Color surface = Color(0xFFFFFFFF);      // Blanco
static const Color text = Color(0xFF1E293B);         // Gris oscuro
static const Color textSecondary = Color(0xFF64748B); // Gris medio

// Colores de precios
static const Color priceGood = Color(0xFF22C55E);    // Verde - Barato
static const Color priceMedium = Color(0xFFF59E0B);  // Amarillo - Medio
static const Color priceHigh = Color(0xFFEF4444);    // Rojo - Caro
```

### Tipografía
- **Fuente**: Inter o Roboto
- **Títulos**: Bold, tamaño grande
- **Precios**: Extra Bold, destacado
- **Texto secundario**: Regular, gris

---

## ⚙️ Lógica de Negocio

### Cálculo de Distancia
```dart
import 'package:geolocator/geolocator.dart';

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000; // en km
}
```

### Conversión de Coordenadas (API -> Double)
```dart
double parseCoordinate(String? value) {
  if (value == null || value.isEmpty) return 0.0;
  return double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
}
```

### Conversión de Precios
```dart
double? parsePrice(String? value) {
  if (value == null || value.isEmpty) return null;
  return double.tryParse(value.replaceAll(',', '.'));
}
```

### Ordenamiento Combinado (Precio + Distancia)
```dart
// Factor de ponderación ajustable
double calculateScore(double price, double distanceKm, {double priceWeight = 0.7}) {
  double distanceWeight = 1 - priceWeight;
  double normalizedPrice = price / maxPrice; // normalizar 0-1
  double normalizedDistance = distanceKm / maxDistance; // normalizar 0-1
  return (normalizedPrice * priceWeight) + (normalizedDistance * distanceWeight);
}
```

---

## 📦 Modelo de Datos (Dart)

```dart
class GasStation {
  final String id;
  final String name;
  final String address;
  final String postalCode;
  final String locality;
  final String municipality;
  final String province;
  final double latitude;
  final double longitude;
  final String schedule;
  final Map<FuelType, double?> prices;
  double? distanceKm;

  GasStation({
    required this.id,
    required this.name,
    required this.address,
    required this.postalCode,
    required this.locality,
    required this.municipality,
    required this.province,
    required this.latitude,
    required this.longitude,
    required this.schedule,
    required this.prices,
    this.distanceKm,
  });

  factory GasStation.fromJson(Map<String, dynamic> json) {
    return GasStation(
      id: json['IDEESS'] ?? '',
      name: json['Rótulo'] ?? 'Desconocido',
      address: json['Dirección'] ?? '',
      postalCode: json['C.P.'] ?? '',
      locality: json['Localidad'] ?? '',
      municipality: json['Municipio'] ?? '',
      province: json['Provincia'] ?? '',
      latitude: _parseCoordinate(json['Latitud']),
      longitude: _parseCoordinate(json['Longitud (WGS84)']),
      schedule: json['Horario'] ?? '',
      prices: _parsePrices(json),
    );
  }

  static double _parseCoordinate(String? value) {
    if (value == null || value.isEmpty) return 0.0;
    return double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
  }

  static Map<FuelType, double?> _parsePrices(Map<String, dynamic> json) {
    return {
      FuelType.gasolina95: _parsePrice(json['Precio Gasolina 95 E5']),
      FuelType.gasolina98: _parsePrice(json['Precio Gasolina 98 E5']),
      FuelType.dieselA: _parsePrice(json['Precio Gasoleo A']),
      FuelType.dieselB: _parsePrice(json['Precio Gasoleo B']),
      FuelType.dieselPremium: _parsePrice(json['Precio Gasoleo Premium']),
      FuelType.glp: _parsePrice(json['Precio Gases licuados del petróleo']),
    };
  }

  static double? _parsePrice(String? value) {
    if (value == null || value.isEmpty) return null;
    return double.tryParse(value.replaceAll(',', '.'));
  }
}

enum FuelType {
  gasolina95('Gasolina 95', '⛽'),
  gasolina98('Gasolina 98', '⛽'),
  dieselA('Diésel A', '🛢️'),
  dieselB('Diésel B', '🛢️'),
  dieselPremium('Diésel Premium', '🛢️'),
  glp('GLP/Autogas', '🔥');

  final String displayName;
  final String icon;
  const FuelType(this.displayName, this.icon);
}
```

---

## 🔧 Configuración Necesaria

### 1. Google Maps API Key
Obtener API key de Google Cloud Console y configurar:

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="TU_API_KEY"/>
```

**iOS** (`ios/Runner/AppDelegate.swift`):
```swift
GMSServices.provideAPIKey("TU_API_KEY")
```

### 2. Permisos de Ubicación

**Android** (`AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.INTERNET"/>
```

**iOS** (`Info.plist`):
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Necesitamos tu ubicación para encontrar gasolineras cercanas</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>Necesitamos tu ubicación para encontrar gasolineras cercanas</string>
```

### 3. Dependencias (`pubspec.yaml`)
```yaml
dependencies:
  flutter:
    sdk: flutter
  google_maps_flutter: ^2.5.0
  geolocator: ^10.1.0
  geocoding: ^2.1.1
  permission_handler: ^11.1.0
  http: ^1.1.0
  provider: ^6.1.1  # o riverpod/bloc
  cached_network_image: ^3.3.0
  flutter_svg: ^2.0.9
  shimmer: ^3.0.0  # para loading states
```

---

## ✅ Checklist de Implementación

### Fase 1: Configuración Base
- [ ] Crear proyecto Flutter
- [ ] Configurar dependencias
- [ ] Configurar Google Maps API
- [ ] Configurar permisos de ubicación

### Fase 2: Capa de Datos
- [ ] Crear modelos (GasStation, FuelType, Province)
- [ ] Implementar ApiService
- [ ] Implementar LocationService
- [ ] Implementar DistanceService

### Fase 3: Lógica de Negocio
- [ ] Crear provider/bloc de gasolineras
- [ ] Implementar filtrado por provincia
- [ ] Implementar filtrado por tipo de combustible
- [ ] Implementar ordenamiento

### Fase 4: UI - Pantalla Principal
- [ ] Diseñar layout principal
- [ ] Implementar selector de combustible
- [ ] Implementar selector de provincia
- [ ] Implementar toggle mapa/lista

### Fase 5: UI - Vista de Mapa
- [ ] Integrar Google Maps
- [ ] Crear marcadores personalizados
- [ ] Implementar info windows
- [ ] Implementar bottom sheet de detalles

### Fase 6: UI - Vista de Lista
- [ ] Diseñar cards de gasolinera
- [ ] Implementar ordenamiento
- [ ] Implementar pull to refresh
- [ ] Añadir animaciones

### Fase 7: Pulido
- [ ] Manejo de errores
- [ ] Estados de carga (shimmer)
- [ ] Empty states
- [ ] Pruebas y optimización

---

## 🚀 Extras Opcionales

- **Favoritos**: Guardar gasolineras frecuentes
- **Historial de precios**: Gráfica de evolución
- **Notificaciones**: Alertar cuando el precio baje
- **Modo oscuro**: Tema dark
- **Widgets**: Widget de Android/iOS con precio actual
- **Navegación integrada**: Abrir rutas directamente

---

## 📚 Referencias

- [API REST Carburantes - Documentación](https://sedeaplicaciones.minetur.gob.es/ServiciosRESTCarburantes/PreciosCarburantes/help)
- [Google Maps Flutter Plugin](https://pub.dev/packages/google_maps_flutter)
- [Geolocator Package](https://pub.dev/packages/geolocator)
- [Flutter Documentation](https://docs.flutter.dev/)
