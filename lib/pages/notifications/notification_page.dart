import 'package:easylygo_app/common/colors.dart';
import 'package:easylygo_app/common/text_styles.dart';
import 'package:easylygo_app/common/widgets.dart';
import 'package:easylygo_app/constants/routes.dart';
import 'package:easylygo_app/constants/string_constants.dart';
import 'package:easylygo_app/models/NotificationModel.dart';
import 'package:easylygo_app/models/TripRequest.dart';
import 'package:easylygo_app/pages/notifications/notification_list.dart';
import 'package:easylygo_app/providers/app_provider.dart';
import 'package:easylygo_app/services/notification_servcice.dart';
import 'package:easylygo_app/utils/date_util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotificationPage extends ConsumerWidget {

  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    RemoteMessage message= ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    String notificationId=message.data['notificationId'];
    String notificationType=message.data['notificationType'];
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
             notificationType==TRIP_REQUEST_NOTIFICARION? 'Your trip request notification':'Your trip request approval notification',
              style: textStyleTitle(16),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 20,
            ),

          StreamBuilder<NotificationModel>(stream: NotificationService.getNotificationDetails(userDocId, notificationId),builder:(BuildContext ctx, AsyncSnapshot snapshot){

            if(snapshot.connectionState==ConnectionState.waiting)  return const Center(child: CircularProgressIndicator(),);

            if(snapshot.hasError ) return const Center(child: Text('An error occured'),);
      
            NotificationModel notificationModel=snapshot.data;
          
            TripRequest tripRequest=TripRequest.fromJosn(notificationModel.notificationData);

            return   Container(
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
                            'Trip request notification detalis',
                            style: textStyleContentSmall(12),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
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
                  Row(
                    children: [
                      const Icon(
                        Icons.account_box,
                        color: AppColors.mainColor,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(tripRequest.customerDetails.fullName.toString())
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
                          const Text('Customer phone number'),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(tripRequest.customerDetails.phoneNumber
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
                        Icons.message,
                        color: AppColors.mainColor,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Customer message'),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(tripRequest.requestMessage.toString()),
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
                    if(notificationType==TRIP_REQUEST_NOTIFICARION){
                    Navigator.pushReplacementNamed(context, VIEW_TRIP_REQUEST_DETAILS, arguments: tripRequest);
                    }else{
                      Navigator.pushReplacementNamed(context, CUSTOMER_TRIP_REQUEST_DETAILS, arguments: tripRequest); 
                    }
                    },
                    label: 'View trip',
                  )
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