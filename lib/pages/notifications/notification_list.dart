import 'package:easylygo_app/common/text_styles.dart';
import 'package:easylygo_app/items/notification_item.dart';
import 'package:easylygo_app/models/NotificationModel.dart';
import 'package:easylygo_app/pages/drivers/home_layoout.dart';
import 'package:easylygo_app/providers/app_provider.dart';
import 'package:easylygo_app/services/notification_servcice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationsList extends ConsumerWidget {
  const NotificationsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String docId = ref.read(userProvider).docId.toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easily Go'),
        elevation: 1,
         leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5,),
            Text('ALl notifications', style: textStyleTitle(16),),
            const SizedBox(height: 10,),
            StreamBuilder<List<NotificationModel>>(
                stream: NotificationService.getNotificationList(docId),
                builder: (context, snapshot) {
      
                  if (snapshot.hasError){
                    return const Center(
                      child: Text('An error occured'),
                    );
                  }
                
                  List<NotificationModel> notifications = snapshot.data as List<NotificationModel>;
      
                  return SizedBox(
                    height: 70.0 * notifications.length,
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
