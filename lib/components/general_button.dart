import 'package:flutter/material.dart';

class GeneralButton extends StatelessWidget {
  final Function()? onTap;
  final String title;
  final Color? backgroundColor;
  final Color? textColor;
  final double padding;
  final double margin;
  const GeneralButton(
      {super.key,
      required this.onTap,
      required this.title,
      this.backgroundColor = Colors.black,
      this.textColor = Colors.white,
      this.padding = 25,
      this.margin = 25});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap!,
      child: Container(
        padding: EdgeInsets.all(padding),
        margin: EdgeInsets.symmetric(horizontal: margin),
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                color: textColor, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
