import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weight_tracker/features/view_weights/data/dtos/weight_request.dart';
import 'package:weight_tracker/features/view_weights/data/dtos/weight_response.dart';
import 'package:weight_tracker/features/view_weights/domain/entities/weight_data.dart';

class WeightsApiService {
  WeightsApiService();
  CollectionReference get _collectionReference =>
      FirebaseFirestore.instance.collection('weights');

  Future<void> saveWeight(WeightRequest data) async {
    try {
      await _collectionReference.add(data.toJson());
      return;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteWeight(WeightData data) async {
    try {
      await _collectionReference.doc(data.id).delete();
      return;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<WeightData>> getUserWeights(String userId) async {
    try {
      var weightsCollection = await _collectionReference
          .withConverter(
            fromFirestore: (snapshot, _) => WeightData.fromWeightResponse(
              WeightResponse.fromSnapshot(snapshot),
            ),
            toFirestore: (weightData, _) =>
                WeightRequest.fromWeightData(weightData, userId).toJson(),
          )
          .where('userId', isEqualTo: userId)
          .orderBy(
            'createdDtm',
            descending: true,
          )
          .get();
      return weightsCollection.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<WeightData>> getUserWeightsStream(String userId) =>
      _collectionReference
          .withConverter(
            fromFirestore: (snapshot, _) => WeightData.fromWeightResponse(
              WeightResponse.fromSnapshot(snapshot),
            ),
            toFirestore: (weightData, _) =>
                WeightRequest.fromWeightData(weightData, userId).toJson(),
          )
          .where('userId', isEqualTo: userId)
          .orderBy(
            'createdDtm',
            descending: true,
          )
          .snapshots()
          .map((event) => event.docs.map((doc) => doc.data()).toList());
}
