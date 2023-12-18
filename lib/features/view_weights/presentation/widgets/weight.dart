import 'package:flutter/material.dart';
import 'package:weight_tracker/features/view_weights/domain/entities/weight_data.dart';

class Weight extends StatelessWidget {
  const Weight({
    super.key,
    required this.weight,
    required this.onDeletePressed,
  });
  final WeightData weight;
  final void Function(WeightData weidghtData) onDeletePressed;
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      tileColor: colorScheme.background,
      title: Text(weight.createdDtm.toLocal().toString()),
      subtitle: Text(
        '${weight.weight} ${weight.unitType}',
      ),
      trailing: IconButton(
        style: IconButton.styleFrom(
          foregroundColor: colorScheme.error,
        ),
        icon: const Icon(Icons.delete),
        onPressed: () => onDeletePressed(weight),
      ),
    );
  }
}
