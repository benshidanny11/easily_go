import 'package:flutter/material.dart';

class AlertUtil{

 static void showLoadingAlertDialig(BuildContext context,String title,bool dismisDialog){
  
      AlertDialog alert = AlertDialog(  
    title: Text(title),  
    content: const Row(
      children: [
        CircularProgressIndicator(),
        SizedBox(width: 5,),
        Text("Please wait..."),
      ],
    ),  
  );  
  showDialog(  
    context: context,  
    builder: (BuildContext ctx) {  
      if(dismisDialog){
        Navigator.of(ctx).pop();
      }
      return alert;  
    },  
  );  
 }

}