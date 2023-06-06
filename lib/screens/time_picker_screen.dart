import 'package:flutter/material.dart';

class TimePickerScreen extends StatefulWidget {
  static const routeName = 'time_picker_screen';
  const TimePickerScreen({Key? key}) : super(key: key);

  @override
  State<TimePickerScreen> createState() => _TimePickerScreenState();
}

class _TimePickerScreenState extends State<TimePickerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set time'),
      ),
      body: Column(
        // shrinkWrap: true,
        children: [
          TimePickerDialog(initialTime: TimeOfDay(hour: 10, minute: 15)),
          DatePickerDialog(
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100)),
        ],
      ),
    );
  }
}
