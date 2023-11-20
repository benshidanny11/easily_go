import 'package:easylygo_app/common/colors.dart';
import 'package:easylygo_app/common/text_styles.dart';
import 'package:easylygo_app/models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UserItem extends StatelessWidget {
  final UserModel userModel;
  const UserItem({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //  Navigator.pushNamed(context, CUSTOMER_TRIP_REQUEST_DETAIL);
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(
                width: 1, color: const Color.fromARGB(255, 232, 232, 232)),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  child: const Icon(Icons.account_circle,
                      color: AppColors.mainColor),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userModel.fullName.toString(),
                      style: textStyleTitle(16),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      userModel.phoneNumber.toString(),
                      style: textStyleContentSmall(13),
                    )
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: () async{
                   var url = Uri(
                          scheme: 'tel',
                          path: userModel.phoneNumber);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, webViewConfiguration: WebViewConfiguration());
                      } else {
                        throw 'Could not launch $url';
                      }
              },
              child: const  Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.call,
                  color: AppColors.mainColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
