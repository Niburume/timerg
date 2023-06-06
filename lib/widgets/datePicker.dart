import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({Key? key}) : super(key: key);

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: [
        DatePickerDialog(
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2100)),
        SizedBox(
          height: 20,
        ),
        TimePickerDialog(initialTime: TimeOfDay(hour: 10, minute: 12))
      ],
    );
  }
}
