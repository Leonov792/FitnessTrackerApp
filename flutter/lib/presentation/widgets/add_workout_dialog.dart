import 'package:flutter/material.dart';

/// Result of the dialog: user-entered steps and minutes.
typedef AddWorkoutResult = ({int steps, int minutes});

class AddWorkoutDialog extends StatefulWidget {
  const AddWorkoutDialog({super.key});

  @override
  State<AddWorkoutDialog> createState() => _AddWorkoutDialogState();
}

class _AddWorkoutDialogState extends State<AddWorkoutDialog> {
  final TextEditingController _stepsController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();

  @override
  void dispose() {
    _stepsController.dispose();
    _minutesController.dispose();
    super.dispose();
  }

  void _submit() {
    final steps = int.tryParse(_stepsController.text) ?? 0;
    final minutes = int.tryParse(_minutesController.text) ?? 0;
    if (steps <= 0) {
      return;
    }
    Navigator.of(context).pop((steps: steps, minutes: minutes));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add workout'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _stepsController,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Steps'),
          ),
          TextField(
            controller: _minutesController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Minutes'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Add')),
      ],
    );
  }
}
