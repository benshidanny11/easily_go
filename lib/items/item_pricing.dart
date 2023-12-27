import 'package:easylygo_app/common/colors.dart';
import 'package:easylygo_app/common/text_styles.dart';
import 'package:easylygo_app/common/widgets.dart';
import 'package:easylygo_app/constants/routes.dart';
import 'package:easylygo_app/constants/string_constants.dart';
import 'package:easylygo_app/models/TripRequest.dart';
import 'package:easylygo_app/services/journey_service.dart';
import 'package:easylygo_app/utils/alert_util.dart';
import 'package:flutter/material.dart';

class ItemPricing extends StatelessWidget {

 final String title;
 final String description;
  const ItemPricing({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    final scrreenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textStyleBlue(17),
          ),
          const SizedBox(
            height: 3,
          ),
          Row(
            children: [
              SizedBox(
                width: scrreenWidth * .9,
                child: Text(
                  description,
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                  style: textStyleTitle(12),
                ),
              ),
            ],
          ),
         const SizedBox(height: 10,),
          CommonWidgets.customDivider(),
        ],
      ),
    );
  }
}