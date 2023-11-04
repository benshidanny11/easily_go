import 'package:easylygo_app/common/colors.dart';
import 'package:easylygo_app/common/text_styles.dart';
import 'package:easylygo_app/common/widgets.dart';
import 'package:easylygo_app/constants/string_constants.dart';
import 'package:easylygo_app/models/Journey.dart';
import 'package:easylygo_app/services/journey_service.dart';
import 'package:easylygo_app/utils/alert_util.dart';
import 'package:easylygo_app/utils/date_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ViewDriverJourney extends StatefulWidget {
  const ViewDriverJourney({super.key});

  @override
  State<ViewDriverJourney> createState() => _ViewDriverJourneyState();
}

class _ViewDriverJourneyState extends State<ViewDriverJourney> {
  @override
  Widget build(BuildContext context) {
    final Journey journey =
        ModalRoute.of(context)!.settings.arguments as Journey;

    return Scaffold(
      appBar: AppBar(
        title: Text('Easily go'),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your journey',
              style: textStyleTitle(16),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.all(10),
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
                              Text(
                                  '${journey.joinedPassengers.length} passengers have joined',
                                  style: textStyleContentSmall(12)),
                            ],
                          )
                        ],
                      ),
                      journey.jorneyStatus == JOURNEY_STATUS_CANCELED
                          ? CommonWidgets.tag(
                              AppColors.colorWarning, 'Canceled')
                          : GestureDetector(
                              onTap: () {
                                AlertUtil.showAlertDialog(context, () async {
                                  AlertUtil.showLoadingAlertDialig(
                                      context, 'Canceling jorney', false);
                                  await JourneyService.cancelJourney(journey);
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                }, 'Cancel journey',
                                    'Are you sure you want to canel journey?');
                              },
                              child: const Icon(
                                Icons.cancel,
                                color: AppColors.mainColor,
                              ))
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
                  SizedBox(height: 15,),
                  CommonWidgets.customDivider(),
                  SizedBox(height: 20,),
                  CommonWidgets.buttonBlueRounded(onPressed: (){

                  },label: 'See joined passengers', )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
