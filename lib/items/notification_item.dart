import 'package:easylygo_app/common/colors.dart';
import 'package:easylygo_app/common/text_styles.dart';
import 'package:easylygo_app/models/NotificationModel.dart';
import 'package:easylygo_app/providers/app_provider.dart';
import 'package:easylygo_app/services/notification_servcice.dart';
import 'package:easylygo_app/utils/date_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotificationItem extends ConsumerWidget {
  final NotificationModel notificationModel;
  const NotificationItem({super.key, required this.notificationModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth=MediaQuery.of(context).size.width;
    final userDocId=ref.read(userProvider).docId.toString();
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, CUSTOMER_TRIP_REQUEST_DETAIL);
        NotificationService.updateOpenedStatus(notificationModel, userDocId);
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: !notificationModel.isOpened ? AppColors.colorBackGroundLight: Colors.transparent,
            border: Border.all(
                width: 1, color: const Color.fromARGB(255, 232, 232, 232)),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  child: const Icon(FontAwesomeIcons.car,
                      color: AppColors.mainColor),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: screenWidth * .8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            notificationModel.title,
                            style: textStyleTitle(16),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              DateUtil.getDateTimeString(notificationModel
                                  .notificationData['createdAt']
                                  .toDate() as DateTime),
                              style: textStyleContentSmall(10),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      notificationModel.body,
                      style: textStyleContentSmall(13),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
