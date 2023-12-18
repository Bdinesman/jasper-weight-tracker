import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weight_tracker/features/view_weights/domain/entities/weight_data.dart';

class AddWeightDialog extends StatefulWidget {
  const AddWeightDialog({super.key});

  @override
  State<AddWeightDialog> createState() => _AddWeightDialogState();
}

class _AddWeightDialogState extends State<AddWeightDialog> {
  //Using value listenable builders allows for more targeted builds than
  //setState when not using bloc
  final _vnUnit = ValueNotifier<WeightUnitType>(WeightUnitType.pounds);
  final _vnIsValid = ValueNotifier<bool>(false);
  final _formKey = GlobalKey<FormState>();
  double? _weight;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: () =>
            _vnIsValid.value = _formKey.currentState?.validate() ?? false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Weight',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 12.0,
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Weight',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (val) => _weight = double.tryParse(val),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: _validateWeight,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9]{1,}\.{0,1}[0-9]{0,}$'),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Unit of Measurement'),
                    ValueListenableBuilder(
                      valueListenable: _vnUnit,
                      builder: (context, selectedUnit, child) {
                        return DropdownButton<WeightUnitType>(
                          value: _vnUnit.value,
                          items: WeightUnitType.values
                              .map(
                                (unit) => DropdownMenuItem(
                                  value: unit,
                                  enabled: unit != selectedUnit,
                                  child: Text('$unit'),
                                ),
                              )
                              .toList(),
                          onChanged: (WeightUnitType? value) {
                            if (value == null) return;
                            _vnUnit.value = value;
                          },
                        );
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    ValueListenableBuilder(
                        valueListenable: _vnIsValid,
                        builder: (context, isValid, child) {
                          return FilledButton(
                            onPressed: isValid ? _addWeightPressed : null,
                            child: const Text('Add'),
                          );
                        }),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String? _validateWeight(String? value) {
    if (value == null) return 'Please enter a weight';
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  void _addWeightPressed() {
    var weight = _weight;
    if (weight == null) return;
    Navigator.of(context).pop(
      WeightData(
        weight: weight,
        unitType: _vnUnit.value,
        createdDtm: DateTime.now().toUtc(),
      ),
    );
  }
}
