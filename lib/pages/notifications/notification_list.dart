import 'package:easylygo_app/common/text_styles.dart';
import 'package:easylygo_app/constants/string_constants.dart';
import 'package:easylygo_app/items/notification_item.dart';
import 'package:easylygo_app/models/NotificationModel.dart';
import 'package:easylygo_app/models/UserModel.dart';
import 'package:easylygo_app/pages/customers/customer_home.dart';
import 'package:easylygo_app/pages/drivers/home_layoout.dart';
import 'package:easylygo_app/providers/app_provider.dart';
import 'package:easylygo_app/services/notification_servcice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationsList extends ConsumerWidget {
  const NotificationsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel userModel = ref.read(userProvider);
    String docId = userModel.docId.toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easily Go'),
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (userModel.userRole == DRIVER_ROLE || userModel.userRole == MOTOR_RIDER_ROLE) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            }else{
               Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const CustomerHomePage()),
              );
            }
            
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            Text(
              'ALl notifications',
              style: textStyleTitle(16),
            ),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<List<NotificationModel>>(
                stream: NotificationService.getNotificationList(docId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('An error occured'),
                    );
                  }

                  List<NotificationModel> notifications =
                      snapshot.data as List<NotificationModel>;
                  print(
                      '========+++++++++=====>>>>>>>>>>Notification length${notifications.length}');
                  return SizedBox(
                    height: 75.0 * notifications.length,
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return NotificationItem(
                            notificationModel: notifications[index]);
                      },
                      itemCount: notifications.length,
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
