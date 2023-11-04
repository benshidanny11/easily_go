import 'package:easylygo_app/common/colors.dart';
import 'package:easylygo_app/common/text_styles.dart';
import 'package:easylygo_app/common/widgets.dart';
import 'package:easylygo_app/constants/routes.dart';
import 'package:easylygo_app/constants/string_constants.dart';
import 'package:easylygo_app/models/Journey.dart';
import 'package:easylygo_app/services/journey_service.dart';
import 'package:easylygo_app/utils/alert_util.dart';
import 'package:easylygo_app/utils/date_util.dart';
import 'package:flutter/material.dart';

class JourneyItem extends StatelessWidget {
  final Journey journey;
  const JourneyItem({super.key, required this.journey});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, VIEW_DRIVER_JOURNEY_DETAILS, arguments:  journey);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 5),
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
                  child:
                      const Icon(Icons.time_to_leave, color: AppColors.mainColor),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${journey.origin} - ${journey.destination}',
                      style: textStyleTitle(17),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      'Starts at ${DateUtil.getDateTimeString(journey.startTime)} (${journey.joinedPassengers.length} joined)',
                      style: textStyleTitle(13),
                    )
                  ],
                ),
              ],
            ),
            journey.jorneyStatus==JOURNEY_STATUS_CANCELED?CommonWidgets.tag(AppColors.colorWarning, 'Canceled'): GestureDetector(
                onTap: () {
                  AlertUtil.showAlertDialog(context, () async{
                    AlertUtil.showLoadingAlertDialig(context, 'Canceling jorney', false);
                   await JourneyService.cancelJourney(journey);
                   Navigator.of(context).pop();
    
                  }, 'Cancel journey', 'Are you sure you want to canel journey?');
                },
                child: const Icon(
                  Icons.cancel,
                  color: AppColors.mainColor,
                ))
          ],
        ),
      ),
    );
  }
}
