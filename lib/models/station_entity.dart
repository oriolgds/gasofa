import 'package:isar/isar.dart';
import 'gas_station.dart';
import 'fuel_type.dart';

part 'station_entity.g.dart';

@collection
class StationEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String ideess;

  late String name;
  late String address;
  late String postalCode;
  late String locality;
  late String municipality;

  @Index()
  late String province;

  late double latitude;
  late double longitude;
  late String schedule;

  // Prices
  @Index()
  double? priceGasolina95;
  double? priceGasolina98;
  @Index()
  double? priceDieselA;
  double? priceDieselB;
  double? priceDieselPremium;
  double? priceGlp;

  StationEntity();

  // Helper to convert from Domain Model
  factory StationEntity.fromGasStation(GasStation station) {
    return StationEntity()
      ..ideess = station.id
      ..name = station.name
      ..address = station.address
      ..postalCode = station.postalCode
      ..locality = station.locality
      ..municipality = station.municipality
      ..province = station.province
      ..latitude = station.latitude
      ..longitude = station.longitude
      ..schedule = station.schedule
      ..priceGasolina95 = station.prices[FuelType.gasolina95]
      ..priceGasolina98 = station.prices[FuelType.gasolina98]
      ..priceDieselA = station.prices[FuelType.dieselA]
      ..priceDieselB = station.prices[FuelType.dieselB]
      ..priceDieselPremium = station.prices[FuelType.dieselPremium]
      ..priceGlp = station.prices[FuelType.glp];
  }

  // Helper to convert to Domain Model
  GasStation toGasStation() {
    return GasStation(
      id: ideess,
      name: name,
      address: address,
      postalCode: postalCode,
      locality: locality,
      municipality: municipality,
      province: province,
      latitude: latitude,
      longitude: longitude,
      schedule: schedule,
      prices: {
        FuelType.gasolina95: priceGasolina95,
        FuelType.gasolina98: priceGasolina98,
        FuelType.dieselA: priceDieselA,
        FuelType.dieselB: priceDieselB,
        FuelType.dieselPremium: priceDieselPremium,
        FuelType.glp: priceGlp,
      },
      // Distance is calculated at runtime, not stored
    );
  }
}
