/// Fuel type enum representing different fuel types available at gas stations
library;

import 'package:flutter/material.dart';

enum FuelType {
  gasolina95('Gasolina 95', Icons.local_gas_station, 'Precio Gasolina 95 E5'),
  gasolina98('Gasolina 98', Icons.local_gas_station, 'Precio Gasolina 98 E5'),
  dieselA('Diésel A', Icons.oil_barrel, 'Precio Gasoleo A'),
  dieselB('Diésel B', Icons.oil_barrel, 'Precio Gasoleo B'),
  dieselPremium('Diésel Premium', Icons.oil_barrel, 'Precio Gasoleo Premium'),
  glp('GLP/Autogas', Icons.propane_tank, 'Precio Gases licuados del petróleo'),
  gnc('GNC', Icons.air, 'Precio Gas Natural Comprimido');

  final String displayName;
  final IconData icon;
  final String apiField;

  const FuelType(this.displayName, this.icon, this.apiField);
}
