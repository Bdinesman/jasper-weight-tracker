part of 'weights_cubit.dart';

@immutable
sealed class WeightsState {}

final class WeightsInitial extends WeightsState {}

final class WeightsInProgress extends WeightsState {}

final class WeightsSuccess extends WeightsState {
  WeightsSuccess({required this.weights});
  final List<WeightData> weights;
  @override
  operator ==(Object other) =>
      other is WeightsSuccess &&
      other.weights.length == weights.length &&
      other.weights.every(weights.contains);

  @override
  int get hashCode => Object.hashAll([weights]);
}

final class WeightsError extends WeightsState {
  WeightsError({required this.error});
  final Object error;

  @override
  operator ==(Object other) => other is WeightsError && other.error == error;

  @override
  int get hashCode => Object.hashAll([error]);
}
