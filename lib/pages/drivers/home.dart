import 'package:easylygo_app/common/colors.dart';
import 'package:easylygo_app/common/text_styles.dart';
import 'package:easylygo_app/common/widgets.dart';
import 'package:easylygo_app/constants/routes.dart';
import 'package:easylygo_app/items/journey_item.dart';
import 'package:easylygo_app/items/trip_request_item_driver.dart';
import 'package:easylygo_app/models/Journey.dart';
import 'package:easylygo_app/models/TripRequest.dart';
import 'package:easylygo_app/providers/app_provider.dart';
import 'package:easylygo_app/services/journey_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeActivities extends ConsumerStatefulWidget {
  const HomeActivities({super.key});

  @override
  ConsumerState<HomeActivities> createState() => _HomeActivitiesState();
}

class _HomeActivitiesState extends ConsumerState<HomeActivities> {
  int _journeysCount = 0;
   int _tripRequestCount = 0;

  @override
  Widget build(BuildContext context) {
    String userId = ref.read(userProvider).userId.toString();
    final screenHeight=MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your journeyes",
                    style: textStyleTitle(17),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    "You have $_journeysCount active jorneys",
                    style: textStyleContentSmall(12),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, CREATE_JORNEY);
                  },
                  child:
                      const Icon(Icons.add_circle, color: AppColors.mainColor))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          CommonWidgets.customDivider(),
          const SizedBox(
            height: 10,
          ),
          StreamBuilder(
            stream: JourneyService.getMyJourneys(userId),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if(snapshot.hasError){
                  print("**********&&&&&&Error in get journeys --======${snapshot.error} ");
              }
 
                 
              if (snapshot.hasData) {
               
                List<Journey> journeItems = snapshot.data as List<Journey>;
                    _journeysCount=journeItems.length;
                return SizedBox(
                  height: 75.0 * journeItems.length,
                  child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                    return JourneyItem(journey: journeItems[index]);
                  }, itemCount: journeItems.length,),
                );
              } else {
                return const Center(
                  child: Text("An error has occured"),
                );
              }
            },
          ),
          SizedBox(height: 5,),
               Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your trip requests",
                    style: textStyleTitle(17),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    "You have $_tripRequestCount active jorneys",
                    style: textStyleContentSmall(12),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              // GestureDetector(
              //     onTap: () {
                  
              //     },
              //     child:
              //         Row(
              //           children: [
              //             const Icon(Icons.remove_red_eye, color: AppColors.mainColor),
              //             Text('Hide',style: textStyleBlue(12),)
              //           ],
              //         ))
            ],
          ),
                CommonWidgets.customDivider(),
          const SizedBox(
            height: 10,
          ),
          StreamBuilder(
            stream: JourneyService.getDriverTripRequest(userId),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if(snapshot.hasError){
                  print("**********&&&&&&Error in get trip requests --======${snapshot.error} ");
              }
 
                 
              if (snapshot.hasData) {
               
                List<TripRequest> tripRequests = snapshot.data as List<TripRequest>;
                    _journeysCount=tripRequests.length;
                return SizedBox(
                  height: 75.0 * tripRequests.length,
                  child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                    return TripRequestItemDriver(tripRequest: tripRequests[index]);
                  }, itemCount: tripRequests.length,),
                );
              } else {
                return const Center(
                  child: Text("An error has occured"),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
