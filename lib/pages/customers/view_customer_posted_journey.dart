import 'package:easylygo_app/common/colors.dart';
import 'package:easylygo_app/common/text_styles.dart';
import 'package:easylygo_app/common/widgets.dart';
import 'package:easylygo_app/models/Journey.dart';
import 'package:easylygo_app/models/UserModel.dart';
import 'package:easylygo_app/providers/app_provider.dart';
import 'package:easylygo_app/services/journey_service.dart';
import 'package:easylygo_app/utils/alert_util.dart';
import 'package:easylygo_app/utils/date_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewCustomerPostedJourney extends ConsumerStatefulWidget {
  const ViewCustomerPostedJourney({super.key});

  @override
  ConsumerState<ViewCustomerPostedJourney> createState() =>
      _ViewCustomerPostedJourneyState();
}

class _ViewCustomerPostedJourneyState
    extends ConsumerState<ViewCustomerPostedJourney> {
  @override
  Widget build(BuildContext context) {
    final Journey journey =
        ModalRoute.of(context)!.settings.arguments as Journey;
    UserModel user = ref.read(userProvider);
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
              'Journey posted by ${journey.ownerDetails.fullName}',
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
                                'Journey detalis',
                                style: textStyleContentSmall(12),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              JourneyService.checkCustomerJoinedJourney(journey.joinedPassengers, user.userId.toString())?Text(
                                  'You have already joined the journey',
                                  style: textStyleContentSmall(12)): Text(
                                  'Review the journey and join',
                                  style: textStyleContentSmall(12)),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CommonWidgets.customDivider(),
                  const SizedBox(
                    height: 30,
                  ),
                  // const Row(
                  //   children: [
                  //     Icon(
                  //       Icons.account_box,
                  //       color: AppColors.mainColor,
                  //     ),
                  //     SizedBox(
                  //       width: 10,
                  //     ),
                  //     Text('Customer name')
                  //   ],
                  // ),
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
                          const Text('Phone number'),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(journey.ownerDetails.phoneNumber.toString()),
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
                        Icons.location_on,
                        color: AppColors.mainColor,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Pick-up location'),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(journey.origin),
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
                          Text(journey.destination.toString()),
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
                          Text(DateUtil.getDateTimeString(journey.createdAt)),
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
                        Icons.date_range,
                        color: AppColors.mainColor,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Start at'),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(DateUtil.getDateTimeString(journey.startTime)),
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
                        FontAwesomeIcons.dollarSign,
                        color: AppColors.mainColor,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Jorney price'),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(journey.journeyPricePerKM.toString()),
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
                          const Text('Journey status'),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(journey.jorneyStatus),
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
                 JourneyService.checkCustomerJoinedJourney(journey.joinedPassengers, user.userId.toString())? CommonWidgets.buttonBlueRounded(
                    onPressed: () async {
                      var url = Uri(
                          scheme: 'tel',
                          path: journey.ownerDetails.phoneNumber);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, webViewConfiguration: const WebViewConfiguration());
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    label: 'Call driver',
                  ): CommonWidgets.buttonBlueRounded(
                    onPressed: () async{
                      AlertUtil.showLoadingAlertDialig(
                          context, 'Joining journey', false);
                    await  JourneyService.customerJoinJourney(journey, user);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    label: 'Join journey',
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
