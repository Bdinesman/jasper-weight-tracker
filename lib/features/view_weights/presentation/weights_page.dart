import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:weight_tracker/core/presentation/blocs/authentication/authentication_bloc.dart';
import 'package:weight_tracker/features/add_weight/presentation/add_weight_dialog.dart';
import 'package:weight_tracker/features/view_weights/domain/entities/weight_data.dart';
import 'package:weight_tracker/features/view_weights/presentation/cubit/weights_cubit.dart';
import 'package:weight_tracker/features/view_weights/presentation/weights_page_content.dart';

class ViewWeightsPage extends StatefulWidget {
  const ViewWeightsPage({super.key});

  @override
  State<ViewWeightsPage> createState() => _ViewWeightsPageState();
}

class _ViewWeightsPageState extends State<ViewWeightsPage> {
  late WeightsCubit _weightsCubit;
  @override
  void initState() {
    _weightsCubit = WeightsCubit(
      weightsRepository: GetIt.I.get(),
    )..init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _weightsCubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Weight Tracker'),
          actions: [
            TextButton(
              onPressed: GetIt.I.get<AuthenticationBloc>().signOut,
              child: const Text('Sign Out'),
            )
          ],
        ),
        body: const SafeArea(
          child: WeightsPageContent(),
        ),
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        floatingActionButton: FloatingActionButton(
          onPressed: _newWeightPressed,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> _newWeightPressed() async {
    var weightData = await _showNewWeightDialog();
    if (weightData == null) return;
    _weightsCubit.addWeight(weightData);
  }

  Future<WeightData?> _showNewWeightDialog() => showDialog(
        context: context,
        builder: (context) => const AddWeightDialog(),
      );
}
