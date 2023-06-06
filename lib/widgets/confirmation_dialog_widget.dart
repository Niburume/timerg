import 'package:flutter/material.dart';
import 'package:timerg/components/general_button.dart';
import 'package:timerg/screens/main_screen.dart';
import 'package:timerg/screens/set_project_screen.dart';
import '../Models/pin_position_model.dart';
import 'package:cool_alert/cool_alert.dart';

class ConfirmDialog extends StatefulWidget {
  final List<Map<String, String>> dataList = [{}];
  final String line1;
  final String value1;
  final String? line2;
  final String? value2;
  final String? line3;
  final String? value3;
  final String? line4;
  final String? value4;
  final Function? onTap;
  final String confirmLabel;

  ConfirmDialog(
      {this.onTap,
      required this.line1,
      required this.value1,
      this.line2,
      this.value2,
      this.line3,
      this.value3,
      this.line4,
      this.value4,
      required this.confirmLabel});

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
            lineCard(widget.line1, widget.value1),
            widget.line2 != null
                ? lineCard(widget.line2!, widget.value2!)
                : Container(),
            const SizedBox(
              height: 10,
            ),
            widget.line3 != null
                ? lineCard(widget.line3!, widget.value3!)
                : Container(),
            const SizedBox(
              height: 10,
            ),
            widget.line4 != null
                ? lineCard(widget.line4!, widget.value4!)
                : Container(),
            const SizedBox(
              height: 10,
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
                      title: widget.confirmLabel),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget lineCard(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(label), SingleChildScrollView(child: Text(value))],
          ),
          SizedBox(
            height: 10,
          ),
          Divider()
        ],
      ),
    );
  }
}
