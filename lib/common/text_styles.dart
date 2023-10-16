import 'package:easylygo_app/common/colors.dart';
import 'package:flutter/material.dart';

 TextStyle textStyleBlue(double textSize){
return TextStyle(
                    color: AppColors.mainColor,
                    fontWeight: FontWeight.w500,
                    fontSize: textSize);
}
// background: rgba(0, 0, 0, 0.85);

 TextStyle textStyleTitle(double textSize){
return TextStyle(
                    color: AppColors.colorTextBold,
                    fontWeight: FontWeight.w700,
                    fontSize: textSize);
}

 TextStyle textStyleContentSmall(double textSize){
return TextStyle(
                    color: AppColors.colorTextBody,
                    fontWeight: FontWeight.w300,
                    fontSize: textSize);
}