import 'package:easylygo_app/common/colors.dart';
import 'package:flutter/material.dart';

class ButtonBlue extends StatelessWidget {
  final void Function() onPress;
  final String label;
  final double width;
  final IconData? icon;
  final bool showIcon;
  const ButtonBlue(
      {super.key,
      required this.onPress,
      required this.label,
      this.width = 100,
      this.showIcon = false,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        child: ElevatedButton(
          onPressed: onPress,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mainColor,
            foregroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              showIcon
                  ? Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: icon != null ? Icon(icon) : Container(),
                    )
                  :  Container(),
              Text(label),
            ],
          ),
        ));
  }
}
