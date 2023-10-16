import 'package:easylygo_app/common/colors.dart';
import 'package:flutter/material.dart';

class InputDecorations {

  
  static InputDecoration getInputTextDecoration(String label, IconData icon, bool validate){

    return  InputDecoration(
                      label: Text(label,style: const TextStyle(color: AppColors.colorTextBodyLight),),
                      prefixIcon: Icon(icon),
                       enabledBorder: const UnderlineInputBorder(      
                      borderSide:BorderSide(color: AppColors.colorTextBodyLight),   
                      ),  
              focusedBorder:const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.colorTextBodyLight),
                   ),
                   errorText: validate? '$label can\'t be empty':null
                   );
  }

}