import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weight_tracker/features/view_weights/domain/entities/weight_data.dart';

class WeightResponse {
  WeightResponse({
    required this.id,
    required this.userId,
    required this.weight,
    required this.unitType,
    required DateTime createdDtm,
  }) : createdDtm = createdDtm.isUtc ? createdDtm : createdDtm.toUtc();

  factory WeightResponse.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    var json = snapshot.data();
    if (json == null) throw Exception();

    return WeightResponse(
      id: snapshot.id,
      userId: json['userId'] as String,
      weight: (json['weight'] as num).toDouble(),
      unitType: WeightUnitType.fromString(json['unitType'] as String),
      createdDtm: (json['createdDtm'] as Timestamp).toDate().toUtc(),
    );
  }

  final String id;
  final String userId;
  final double weight;
  final WeightUnitType unitType;
  final DateTime createdDtm;

  Map<String, dynamic> toJson() => {
        'weight': weight,
        'userId': userId,
        'unitType': '$unitType',
        'createdDtm': createdDtm,
      };

  @override
  operator ==(Object other) =>
      other is WeightResponse && other.id == id && other.userId == id;

  @override
  int get hashCode => Object.hashAll([
        id,
        userId,
        weight,
        unitType,
        createdDtm,
      ]);
}
