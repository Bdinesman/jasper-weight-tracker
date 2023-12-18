import 'package:flutter/material.dart';
import 'package:weight_tracker/features/view_weights/domain/entities/weight_data.dart';
import 'package:weight_tracker/features/view_weights/presentation/widgets/weight.dart';

class WeightsList extends StatelessWidget {
  const WeightsList({
    super.key,
    required this.weights,
    required this.onDeletePressed,
  });
  final List<WeightData> weights;
  final void Function(WeightData weidghtData) onDeletePressed;

  @override
  Widget build(BuildContext context) {
    if (weights.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Text('No Weights to Display'),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(8.0),
      itemCount: weights.length,
      itemBuilder: (context, index) => Weight(
        weight: weights[index],
        onDeletePressed: onDeletePressed,
      ),
      separatorBuilder: (context, index) => const SizedBox(height: 8.0),
    );
  }
}
