import 'package:weight_tracker/features/view_weights/data/dtos/weight_response.dart';

enum WeightUnitType implements Object {
  kilograms,
  pounds;

  factory WeightUnitType.fromString(String string) =>
      switch (string.toLowerCase()) {
        'kilograms' => kilograms,
        'pounds' => pounds,
        _ => throw Exception(),
      };
  @override
  String toString() => switch (this) {
        kilograms => 'kilograms',
        pounds => 'pounds',
      };
}

class WeightData {
  WeightData({
    this.id,
    required this.weight,
    required this.unitType,
    required DateTime createdDtm,
  }) : createdDtm = createdDtm.isUtc ? createdDtm : createdDtm.toUtc();

  factory WeightData.fromWeightResponse(WeightResponse response) => WeightData(
        id: response.id,
        weight: response.weight,
        unitType: response.unitType,
        createdDtm: response.createdDtm,
      );

  final String? id;
  final double weight;
  final WeightUnitType unitType;
  final DateTime createdDtm;

  @override
  operator ==(Object other) => other is WeightData && other.id == id;

  @override
  int get hashCode => Object.hashAll([
        id,
        weight,
        unitType,
        createdDtm,
      ]);
}
