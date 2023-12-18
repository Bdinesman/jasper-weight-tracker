import 'package:weight_tracker/features/view_weights/data/dtos/weight_request.dart';
import 'package:weight_tracker/features/view_weights/data/services/weights_api_service.dart';
import 'package:weight_tracker/features/view_weights/domain/entities/weight_data.dart';

class WeightsService {
  WeightsService({required WeightsApiService weightsApiService})
      : _weightsApiService = weightsApiService;
  final WeightsApiService _weightsApiService;

  Future<void> saveWeight(WeightData data, String userId) async {
    try {
      return _weightsApiService
          .saveWeight(WeightRequest.fromWeightData(data, userId));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteWeight(WeightData weight) async {
    try {
      return _weightsApiService.deleteWeight(weight);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<WeightData>> getUserWeights(String userId) async {
    try {
      return _weightsApiService.getUserWeights(userId);
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<WeightData>> getUserWeightsStream(String userId) =>
      _weightsApiService.getUserWeightsStream(userId);
}
