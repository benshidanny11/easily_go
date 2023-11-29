import 'package:easylygo_app/common/colors.dart';
import 'package:easylygo_app/common/text_styles.dart';
import 'package:easylygo_app/common/widgets.dart';
import 'package:easylygo_app/models/TripRequest.dart';
import 'package:easylygo_app/utils/date_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewCustomerTripRequest extends StatelessWidget {
  const ViewCustomerTripRequest({super.key});

  @override
  Widget build(BuildContext context) {
    final TripRequest tripRequest =
        ModalRoute.of(context)!.settings.arguments as TripRequest;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Easily go'),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your trip request',
              style: textStyleTitle(16),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: AppColors.colorBackGroundLight,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            FontAwesomeIcons.car,
                            color: AppColors.mainColor,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Trip request detalis',
                                style: textStyleContentSmall(12),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                            ],
                          )
                        ],
                      ),
                      // tripRequest.status == REQUEST_STATUS_PENDING
                      //     ? PopupMenuButton<String>(
                      //         onSelected: (String result) async {
                      //           AlertUtil.showLoadingAlertDialig(
                      //               context,
                      //               result == REQUEST_STATUS_APROVED
                      //                   ? 'Approving request'
                      //                   : 'Rejecting request',
                      //               false);
                      //           if (result == REQUEST_STATUS_APROVED) {
                      //             await JourneyService.approveTrip(tripRequest);
                      //           } else {
                      //             await JourneyService.rejectTrip(tripRequest);
                      //           }
                      //           Navigator.pop(context);
                      //           Navigator.pop(context);
                      //           ScaffoldMessenger.of(context)
                      //               .showSnackBar(SnackBar(
                      //             content: Text("Request has been $result!"),
                      //           ));
                      //         },
                      //         itemBuilder: (BuildContext context) =>
                      //             <PopupMenuEntry<String>>[
                      //           const PopupMenuItem<String>(
                      //             value: REQUEST_STATUS_APROVED,
                      //             child: Text('Approve'),
                      //           ),
                      //           const PopupMenuItem<String>(
                      //             value: REQUEST_STATUS_REJECTED,
                      //             child: Text('Reject'),
                      //           ),
                      //         ],
                      //       )
                      //     : Container()
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CommonWidgets.customDivider(),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.account_box,
                        color: AppColors.mainColor,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(tripRequest.driverDetails.fullName.toString())
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppColors.mainColor,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Driver phone number'),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(tripRequest.driverDetails.phoneNumber
                              .toString()),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppColors.mainColor,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Pick-up location'),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(tripRequest.requestOrigin),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppColors.mainColor,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Drop-off location'),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(tripRequest.requestDestination),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.date_range,
                        color: AppColors.mainColor,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Create at'),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(DateUtil.getDateTimeString(
                              tripRequest.createdAt)),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.update,
                        color: AppColors.mainColor,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Status'),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(tripRequest.status.toString()),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CommonWidgets.customDivider(),
                  const SizedBox(
                    height: 20,
                  ),
                  CommonWidgets.buttonBlueRounded(
                    onPressed: () async {
                      var url = Uri(
                          scheme: 'tel',
                          path: tripRequest.driverDetails.phoneNumber);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, webViewConfiguration: const WebViewConfiguration());
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    label: 'Call driver',
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
