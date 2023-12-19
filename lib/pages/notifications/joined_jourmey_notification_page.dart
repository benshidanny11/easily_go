import 'package:easylygo_app/common/colors.dart';
import 'package:easylygo_app/common/text_styles.dart';
import 'package:easylygo_app/common/widgets.dart';
import 'package:easylygo_app/models/Journey.dart';
import 'package:easylygo_app/models/NotificationModel.dart';
import 'package:easylygo_app/pages/drivers/home_layoout.dart';
import 'package:easylygo_app/pages/notifications/notification_list.dart';
import 'package:easylygo_app/providers/app_provider.dart';
import 'package:easylygo_app/services/notification_servcice.dart';
import 'package:easylygo_app/utils/date_util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class JourneyJoinNotification extends ConsumerStatefulWidget {
  const JourneyJoinNotification({super.key});

  @override
  ConsumerState<JourneyJoinNotification> createState() => _ApprovedRequestNotificationState();
}

class _ApprovedRequestNotificationState extends ConsumerState<JourneyJoinNotification> {
  @override
  Widget build(BuildContext context) {
    RemoteMessage message= ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    String notificationId=message.data['notificationId'];
    String userDocId=ref.read(userProvider).docId.toString();
    print('Notification id======>${message.data['notificationId']}');
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Easily go'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const NotificationsList()),
            );
          },
        ),
        elevation: 1,
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Journey join notification',
              style: textStyleTitle(16),
            ),
            const SizedBox(
              height: 30,
            ),

          StreamBuilder<NotificationModel>(stream: NotificationService.getNotificationDetails(userDocId, notificationId),builder:(BuildContext ctx, AsyncSnapshot snapshot){

            if(snapshot.connectionState==ConnectionState.waiting)  return const Center(child: CircularProgressIndicator(),);

            if(snapshot.hasError ) return const Center(child: Text('An error occured'),);
      
            NotificationModel notificationModel=snapshot.data;
          
            Journey journey=Journey.fromJson(notificationModel.notificationData);

            return Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: AppColors.colorBackGroundLight,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Column(
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
                            'Joined journey notification detalis',
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
                  const SizedBox(height: 15,),
                  CommonWidgets.customDivider(),
                  const SizedBox(height: 20,),
                  CommonWidgets.buttonBlueRounded(onPressed: (){
                     Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomePage(
                            )),
                  );
                  },label: 'Go to journeys', )
                ],
              ),
            );
          }),
          ],
        ),
      ),
    );
  }
}