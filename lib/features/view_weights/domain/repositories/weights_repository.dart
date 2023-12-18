import 'package:weight_tracker/features/view_weights/data/services/weights_service.dart';
import 'package:weight_tracker/features/view_weights/domain/entities/weight_data.dart';

class WeightsRepository {
  WeightsRepository({
    required String userId,
    required WeightsService weightsService,
  })  : _userId = userId,
        _weightsService = weightsService;
  final String _userId;
  final WeightsService _weightsService;
  List<WeightData> _weights = [];
  List<WeightData> get weights => List.unmodifiable(_weights);
  Future<void> init() async {
    try {
      _weights = await _weightsService.getUserWeights(_userId);
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<WeightData>> get $weights =>
      _weightsService.getUserWeightsStream(_userId);

  Future<void> saveWeight(WeightData data) async {
    try {
      return _weightsService.saveWeight(data, _userId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteWeight(WeightData weight) async {
    try {
      return _weightsService.deleteWeight(weight);
    } catch (e) {
      rethrow;
    }
  }
}
