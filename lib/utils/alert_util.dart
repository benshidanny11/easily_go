import 'package:flutter/material.dart';

class AlertUtil {
  static void showLoadingAlertDialig(
      BuildContext context, String title, bool dismisDialog) {
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5), // Adjust the value as needed
      ),
      title: Text(title),
      content: const Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(
            width: 5,
          ),
          Text("Please wait..."),
        ],
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        if (dismisDialog) {
          Navigator.of(ctx).pop();
        }
        return alert;
      },
    );
  }

  static void showAlertDialog(BuildContext context, Future<void> Function()? onOkTap,
      String title, String alertContent) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(alertContent),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async{
               await onOkTap!();
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

   static void showYesAlertDialog(BuildContext context,
      String title, String alertContent) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(alertContent),
          actions: <Widget>[
            TextButton(
              onPressed: () async{
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
