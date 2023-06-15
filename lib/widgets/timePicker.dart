import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class TimePickerW extends StatefulWidget {
  final Function(DateTime dateTime) onTimeSelected;
  DateTime? newTime;
  final DateTime? initialTime;

  TimePickerW({Key? key, required this.onTimeSelected, this.initialTime})
      : super(key: key);

  @override
  State<TimePickerW> createState() => _TimePickerWState();
}

class _TimePickerWState extends State<TimePickerW> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          TimePickerSpinner(
            normalTextStyle: const TextStyle(
                fontSize: 30, fontWeight: FontWeight.w700, color: Colors.grey),
            highlightedTextStyle: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Colors.blueGrey),
            minutesInterval: 10,
            spacing: 50,
            itemHeight: 80,
            isForce2Digits: true,
            initialTime: widget.initialTime,
            onTimeChange: (time) {
              setState(() {
                widget.newTime = time;
              });
            },
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    if (widget.newTime != null) {
                      widget.onTimeSelected(widget.newTime!);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Set')),
              const SizedBox(
                width: 25,
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }
}
