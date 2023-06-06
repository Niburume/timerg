import 'package:flutter/material.dart';
import 'package:timerg/components/general_button.dart';

class ConfirmationDialog extends StatelessWidget {
  final List<Map<String, String>> dataList;
  final String okTitle;
  final String? cancelTitle;
  final Function onOkTap;
  final Function? onCancelTap;
  ConfirmationDialog(
      {required this.dataList,
      required this.onOkTap,
      this.onCancelTap,
      required this.okTitle,
      this.cancelTitle = 'Cancel'});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 10,
      insetAnimationDuration: Duration(milliseconds: 500),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, i) {
                return lineCard(
                    dataList[i].keys.first, dataList[i].values.first);
              },
              shrinkWrap: true,
            ),
            Row(
              children: [
                Expanded(
                  child: GeneralButton(
                      padding: 5,
                      onTap: () {
                        onCancelTap;
                        Navigator.pop(context);
                      },
                      title: cancelTitle!),
                ),
                Expanded(
                  child: GeneralButton(
                      padding: 5,
                      onTap: () {
                        onOkTap();
                      },
                      title: okTitle),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget lineCard(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label:'),
          Text(
            value,
            maxLines: 3,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider()
        ],
      ),
    );
  }
}
