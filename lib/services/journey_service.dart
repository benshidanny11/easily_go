import 'dart:async';

import 'package:easylygo_app/models/Journey.dart';
import 'package:easylygo_app/models/TripRequest.dart';
import 'package:easylygo_app/utils/firestore_util.dart';

class JourneyService {
  static Future<void> createJorney(Journey journey) async {
    await FirebaseUtil.collectionReferene("journeys")
        .add(journey.toJson(journey));
  }

  static Stream<List<Journey>> getMyJourneys(String userid) {
    StreamController<List<Journey>> controller =
        StreamController<List<Journey>>();
    FirebaseUtil.initializeFirebase().then((value) {
      FirebaseUtil.collectionReferene("journeys")
          .where("ownerId", isEqualTo: userid)
          .snapshots()
          .listen((querySnapshot) {
        List<Journey> journeys = querySnapshot.docs
            .map((doc) => Journey.fromJson(doc.data()))
            .toList();
        controller.add(journeys);
      }, onError: (error) {
        controller.addError(error);
      });
    });
    return controller.stream;
  }

   static Future<void> createTripRequest(TripRequest tripRequest) async {
    await FirebaseUtil.collectionReferene("tripRequests")
        .add(tripRequest.toJson(tripRequest));
  }
}
