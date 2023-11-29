import 'package:easylygo_app/common/colors.dart';
import 'package:easylygo_app/common/text_styles.dart';
import 'package:easylygo_app/common/widgets.dart';
import 'package:easylygo_app/constants/routes.dart';
import 'package:easylygo_app/constants/string_constants.dart';
import 'package:easylygo_app/models/TripRequest.dart';
import 'package:easylygo_app/services/journey_service.dart';
import 'package:easylygo_app/utils/alert_util.dart';
import 'package:flutter/material.dart';

class TripRequestItemDriver extends StatelessWidget {
  final TripRequest tripRequest;
  const TripRequestItemDriver({super.key, required this.tripRequest});

  @override
  Widget build(BuildContext context) {
    final scrreenWidth=MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, VIEW_TRIP_REQUEST_DETAILS,
            arguments: tripRequest);
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all( 5),
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
                  child: const Icon(Icons.account_circle, size: 30,
                      color: AppColors.mainColor),
                ),
                const SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tripRequest.customerDetails.fullName.toString(),
                      style: textStyleTitle(17),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
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
                                  tripRequest.requestOrigin,
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
                                  tripRequest.requestDestination,
                                  style: textStyleTitle(12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                     const SizedBox(
                        height: 3,
                      ),
                      CommonWidgets.tag(
                          tripRequest.status == REQUEST_STATUS_PENDING
                              ? AppColors.colorWarning
                              : tripRequest.status == REQUEST_STATUS_APROVED
                                  ? AppColors.colorSuccess
                                  : AppColors.colorError,
                          tripRequest.status)
                    ])
                  ],
                ),
              ],
            ),
            tripRequest.status == REQUEST_STATUS_PENDING
                ? PopupMenuButton<String>(
                    onSelected: (String result) async {
                      AlertUtil.showLoadingAlertDialig(
                          context,
                          result == REQUEST_STATUS_APROVED
                              ? 'Approving request'
                              : 'Rejecting request',
                          false);
                      if (result == REQUEST_STATUS_APROVED) {
                        await JourneyService.approveTrip(tripRequest);
                      } else {
                        await JourneyService.rejectTrip(tripRequest);
                      }
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Request has been $result!"),
                      ));
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: REQUEST_STATUS_APROVED,
                        child: Text('Approve'),
                      ),
                      const PopupMenuItem<String>(
                        value: REQUEST_STATUS_REJECTED,
                        child: Text('Reject'),
                      ),
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
