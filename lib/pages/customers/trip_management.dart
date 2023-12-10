import 'package:easylygo_app/common/text_styles.dart';
import 'package:easylygo_app/common/widgets.dart';
import 'package:easylygo_app/items/trip_request_item_customer.dart';
import 'package:easylygo_app/models/TripRequest.dart';
import 'package:easylygo_app/providers/app_provider.dart';
import 'package:easylygo_app/services/journey_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerTripManagement extends ConsumerStatefulWidget {
  const CustomerTripManagement({super.key});

  @override
  ConsumerState<CustomerTripManagement> createState() => _CustomerTripManagementtState();
}

class _CustomerTripManagementtState extends ConsumerState<CustomerTripManagement> {


  @override
  Widget build(BuildContext context) {
    String userId = ref.read(userProvider).userId.toString();
    return SafeArea(child: Scaffold(
      appBar: AppBar(title: const Text('Easily Go'), elevation: 1,),
      body: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Trips you requested",
                style: textStyleTitle(17),
                textAlign: TextAlign.start,
              ),
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
            stream: JourneyService.geCustomerTripRequests(userId),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                 return const Center(child: SizedBox(width: 20, height: 20,child: CircularProgressIndicator()));
              }
              if(snapshot.hasError){
                  print("**********&&&&&&Error in get journeys --======${snapshot.error} ");
                  return const Center(child: Text('An error has occred'),);
              }
              if (snapshot.hasData) {
               
                List<TripRequest> tripRequests = snapshot.data as List<TripRequest>;
                return SizedBox(
                  height: 120.0 * tripRequests.length,
                  child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                    return TripRequestItemCustomer(tripRequest: tripRequests[index]);
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
    ),
    ));
  }
}
