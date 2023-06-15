import 'package:flutter/material.dart';
import 'package:timerg/components/general_button.dart';

class ConfirmationDialog extends StatelessWidget {
  final List<Map<String, String>> dataList;
  final String okTitle;
  final String? cancelTitle;
  final Function onOkTap;
  final Function? onCancelTap;
  final TextEditingController? topTextFieldController;
  final TextEditingController? noteTextFieldController;
  final TextEditingController? addressTextFieldController;
  final bool showTopTextField;
  final bool showAddressTextField;
  final String? topTextFieldHint;
  final String? note;
  final String? noteHint;
  const ConfirmationDialog(
      {super.key,
      required this.dataList,
      required this.onOkTap,
      this.onCancelTap,
      required this.okTitle,
      this.cancelTitle = 'Cancel',
      this.topTextFieldController,
      this.showTopTextField = false,
      this.showAddressTextField = false,
      this.topTextFieldHint,
      this.addressTextFieldController,
      this.noteTextFieldController,
      this.noteHint = 'Note here...',
      this.note});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 10,
      insetAnimationDuration: const Duration(milliseconds: 500),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            showTopTextField
                ? TextField(
                    decoration: InputDecoration(hintText: topTextFieldHint),
                    controller: topTextFieldController,
                  )
                : const SizedBox(
                    height: 0,
                  ),
            showAddressTextField
                ? TextField(
                    decoration: InputDecoration(hintText: topTextFieldHint),
                    controller: addressTextFieldController,
                  )
                : const SizedBox(
                    height: 0,
                  ),
            ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, i) {
                return lineCard(
                    dataList[i].keys.first, dataList[i].values.first);
              },
              shrinkWrap: true,
            ),
            TextField(
              controller: noteTextFieldController,
              decoration: InputDecoration(hintText: noteHint),
              minLines: 2,
              maxLines: 3,
            ),
            const SizedBox(
              height: 10,
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
                        if (showTopTextField == true) {
                          if (topTextFieldController!.text.isEmpty) {
                            showGeneralDialog(
                                barrierDismissible: true,
                                barrierLabel: 'dismiss',
                                barrierColor: Colors.red.withOpacity(0.2),
                                context: context,
                                pageBuilder: (_, __, ___) {
                                  return Dialog(
                                    child: Container(
                                        height: 50,
                                        width: double.infinity,
                                        child: const Center(
                                            child: Text(
                                          'Give a name to the project',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ))),
                                  );
                                });
                            return;
                          }
                        }
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
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
