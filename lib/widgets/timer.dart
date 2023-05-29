import 'package:flutter/material.dart';
import 'package:timerg/components/circle_button.dart';
import 'package:timerg/components/general_button.dart';

class TimerWidget extends StatefulWidget {
  final String projectName;
  TimerWidget({required this.projectName});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: Container(
        decoration: BoxDecoration(color: Colors.grey[200]),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                children: [
                  Text(widget.projectName),
                  Expanded(child: Container()),
                  Text('8:56'),
                  Expanded(child: Container()),
                  CircleButton(icon: Icon(Icons.play_arrow)),
                  CircleButton(icon: Icon(Icons.pause)),
                  CircleButton(icon: Icon(Icons.stop)),
                ],
              ),
            ),
            Text('tags'),
            TextField(
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}
