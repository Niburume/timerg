import 'package:flutter/material.dart';
import 'package:timerg/components/general_button.dart';
import 'package:timerg/screens/main_screen.dart';
import 'package:timerg/screens/set_project_screen.dart';
import '../Models/pin_position_model.dart';
import 'package:cool_alert/cool_alert.dart';

class ConfirmDialog extends StatefulWidget {
  final PinPosition position;
  final Function? onTap;

  ConfirmDialog({required this.position, this.onTap});

  @override
  State<ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget.position.latitude.toString()),
            const SizedBox(
              height: 10,
            ),
            Text(widget.position.longitude.toString()),
            const SizedBox(
              height: 10,
            ),
            Text('The address: ${widget.position.address}'),
            const SizedBox(
              height: 10,
            ),
            Text('The radius is: ${widget.position.radius.toString()} meters'),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: GeneralButton(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      title: 'Cancel'),
                ),
                Expanded(
                  child: GeneralButton(
                      onTap: () {
                        widget.onTap!();
                      },
                      title: 'Save'),
                ),
                // ElevatedButton(
                //     onPressed: () {
                //       Navigator.pop(context);
                //     },
                //     child: const Text('Cancel')),
                // ElevatedButton(
                //     onPressed: () {
                //       widget.onTap!();
                //       //Navigator.pop(context);
                //     },
                //     child: const Text(' Save ')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
