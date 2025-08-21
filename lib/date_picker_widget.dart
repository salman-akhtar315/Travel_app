import 'package:flutter/material.dart';

class MyDatePickerWidget extends StatelessWidget {
  final TextEditingController dateController;

  const MyDatePickerWidget({
    Key? key,
    required this.dateController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: dateController,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        fillColor: Color.fromRGBO(224, 237, 246, 100),
        filled: true,
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          dateController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
        }
      },
    );
  }
}
