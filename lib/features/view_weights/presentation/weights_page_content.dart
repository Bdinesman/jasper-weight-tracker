import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/features/view_weights/presentation/cubit/weights_cubit.dart';
import 'package:weight_tracker/features/view_weights/presentation/widgets/weights_list.dart';

class WeightsPageContent extends StatelessWidget {
  const WeightsPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeightsCubit, WeightsState>(
      builder: (context, state) {
        return switch (state) {
          WeightsInProgress() => const Center(
              child: CircularProgressIndicator(),
            ),
          WeightsSuccess(weights: var weights) => WeightsList(
              weights: weights,
              onDeletePressed: context.read<WeightsCubit>().deleteWeight,
            ),
          WeightsError() => const Center(child: Text('Something Went Wrong!')),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}
