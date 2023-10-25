import 'package:easylygo_app/common/colors.dart';
import 'package:easylygo_app/common/text_styles.dart';
import 'package:easylygo_app/common/widgets.dart';
import 'package:easylygo_app/constants/routes.dart';
import 'package:easylygo_app/items/journey_item.dart';
import 'package:easylygo_app/models/Journey.dart';
import 'package:easylygo_app/providers/app_provider.dart';
import 'package:easylygo_app/services/jorney_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeActivities extends ConsumerStatefulWidget {
  const HomeActivities({super.key});

  @override
  ConsumerState<HomeActivities> createState() => _HomeActivitiesState();
}

class _HomeActivitiesState extends ConsumerState<HomeActivities> {
  int _journeysCount = 0;

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
            stream: JorneyService.getMyJourneys(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if(snapshot.hasError){
                  print("**********&&&&&&Error in get journeys --======${snapshot.error} ");
              }
              if (snapshot.hasData) {
                List<Journey> journeItems = snapshot.data as List<Journey>;
                // setState(() {
                //   _journeysCount=journeItems.length;
                // });
                return SizedBox(
                  height: screenHeight * .5,
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
        ],
      ),
    );
  }
}
