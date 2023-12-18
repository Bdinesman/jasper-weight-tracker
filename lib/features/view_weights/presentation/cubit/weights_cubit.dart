import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weight_tracker/features/view_weights/domain/entities/weight_data.dart';
import 'package:weight_tracker/features/view_weights/domain/repositories/weights_repository.dart';

part 'weights_state.dart';

class WeightsCubit extends Cubit<WeightsState> {
  WeightsCubit({
    required WeightsRepository weightsRepository,
  })  : _weightsRepository = weightsRepository,
        super(WeightsInitial());
  final WeightsRepository _weightsRepository;
  StreamSubscription<List<WeightData>>? _weightsListener;
  Future<void> init() async {
    if (state is! WeightsInitial) return;
    emit(WeightsInProgress());
    try {
      _weightsRepository.init();
      final weights = _weightsRepository.weights;
      emit(WeightsSuccess(weights: weights));
      _weightsListener ??= _weightsRepository.$weights.listen(
        (weights) => emit(WeightsSuccess(weights: weights)),
      );
    } catch (error) {
      emit(WeightsError(error: error));
    }
  }

  Future<void> addWeight(WeightData weight) async {
    try {
      _weightsRepository.saveWeight(weight);
    } catch (error) {
      emit(WeightsError(error: error));
    }
  }

  Future<void> deleteWeight(WeightData weight) async {
    try {
      _weightsRepository.deleteWeight(weight);
    } catch (error) {
      emit(WeightsError(error: error));
    }
  }

  @override
  Future<void> close() {
    _weightsListener?.cancel();
    return super.close();
  }
}
