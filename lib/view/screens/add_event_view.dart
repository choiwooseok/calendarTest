import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../model/event.dart';

class AddEventView extends StatelessWidget {
  const AddEventView(this.selectedDay, {Key? key}) : super(key: key);

  final DateTime? selectedDay;

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final amountController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                hintText: 'Enter a number',
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text;
                final amount = double.tryParse(amountController.text) ?? 0.0;
                if (name.isNotEmpty && amount > 0.0) {
                  Navigator.pop(
                    context,
                    Event(name: name, amount: amount, date: selectedDay!),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
