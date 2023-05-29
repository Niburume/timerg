import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  Icon icon;
  Function? onTap;
  CircleButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap;
      },
      child: CircleAvatar(
        child: icon,
      ),
    );
  }
}
