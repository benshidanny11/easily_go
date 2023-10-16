import 'package:flutter/material.dart';

class CommonWidgets{

  static TextButton buttonBlueRounded( {onPressed, label, }){
    return TextButton(onPressed: onPressed, child: Text(label));
  }
}