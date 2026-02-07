/// Fuel type enum representing different fuel types available at gas stations

enum FuelType {
  gasolina95('Gasolina 95', '⛽', 'Precio Gasolina 95 E5'),
  gasolina98('Gasolina 98', '⛽', 'Precio Gasolina 98 E5'),
  dieselA('Diésel A', '🛢️', 'Precio Gasoleo A'),
  dieselB('Diésel B', '🛢️', 'Precio Gasoleo B'),
  dieselPremium('Diésel Premium', '🛢️', 'Precio Gasoleo Premium'),
  glp('GLP/Autogas', '🔥', 'Precio Gases licuados del petróleo'),
  gnc('GNC', '💨', 'Precio Gas Natural Comprimido');

  final String displayName;
  final String icon;
  final String apiField;

  const FuelType(this.displayName, this.icon, this.apiField);
}
