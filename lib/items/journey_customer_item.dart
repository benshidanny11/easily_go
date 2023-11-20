import 'package:easylygo_app/common/colors.dart';
import 'package:easylygo_app/common/text_styles.dart';
import 'package:easylygo_app/common/widgets.dart';
import 'package:easylygo_app/constants/routes.dart';
import 'package:easylygo_app/constants/string_constants.dart';
import 'package:easylygo_app/models/Journey.dart';
import 'package:easylygo_app/utils/date_util.dart';
import 'package:flutter/material.dart';

class JourneyCustomerItem extends StatelessWidget {
  final Journey journey;
  const JourneyCustomerItem({super.key, required this.journey});

  @override
  Widget build(BuildContext context) {
    final scrreenWidth=MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, CUSTOMER_POSTED_JOURNEY_DETAILS, arguments:  journey);
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: EdgeInsets.all( 5),
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
                  width:15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                            const  Icon(
                                Icons.my_location,
                                size: 15,
                                color: AppColors.mainColor,
                              ),
                            const  SizedBox(
                                width: 2,
                              ),
                              SizedBox(
                                width: scrreenWidth * .63,
                                child: Text(
                                  maxLines: 2,
                                  overflow: TextOverflow
                                      .ellipsis,
                                   journey.origin,
                                  style: textStyleTitle(12),
                                ),
                              ),
                            ],
                          ),
                         const SizedBox(
                            height: 3,
                          ),
                          Row(
                            children: [
                            const  Icon(
                                Icons.location_on,
                                 size: 15,
                                color: AppColors.mainColor,
                              ),
                            const  SizedBox(
                                width: 2,
                              ),
                              SizedBox(
                                width: scrreenWidth * .63,
                                child: Text(
                                  maxLines: 2,
                                  overflow: TextOverflow
                                      .ellipsis,
                                  journey.destination,
                                  style: textStyleTitle(12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      DateUtil.getDateTimeString(journey.startTime),
                      style: textStyleTitle(13).copyWith(fontWeight: FontWeight.w300),
                    )
                  ],
                ),
              ],
            ),
           CommonWidgets.tag( journey.jorneyStatus==JOURNEY_STATUS_PENDING?AppColors.colorWarning:AppColors.colorError, journey.jorneyStatus)
          ],
        ),
      ),
    );
  }
}
