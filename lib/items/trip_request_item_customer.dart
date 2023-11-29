import 'package:easylygo_app/common/colors.dart';
import 'package:easylygo_app/common/text_styles.dart';
import 'package:easylygo_app/common/widgets.dart';
import 'package:easylygo_app/constants/routes.dart';
import 'package:easylygo_app/constants/string_constants.dart';
import 'package:easylygo_app/models/TripRequest.dart';
import 'package:flutter/material.dart';

class TripRequestItemCustomer extends StatelessWidget {
  final TripRequest tripRequest;
  const TripRequestItemCustomer({super.key, required this.tripRequest});

  @override
  Widget build(BuildContext context) {
    final scrreenWidth=MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, CUSTOMER_TRIP_REQUEST_DETAILS, arguments: tripRequest);
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
                      tripRequest.driverDetails.fullName.toString(),
                      style: textStyleTitle(17),
                    ),
                    const SizedBox(
                      height: 4,
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
          ],
        ),
      ),
    );
  }
}
