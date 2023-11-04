import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easylygo_app/constants/string_constants.dart';
import 'package:easylygo_app/models/Journey.dart';
import 'package:easylygo_app/models/TripRequest.dart';
import 'package:easylygo_app/utils/firestore_util.dart';

class JourneyService {
  static Future<void> createJorney(Journey journey) async {
    await FirebaseUtil.collectionReferene("journeys")
        .add(journey.toJson());
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
        .add(tripRequest.toJson());
  }

  static Stream<List<TripRequest>> getDriverTripRequest(String driverId) {
    StreamController<List<TripRequest>> controller =
        StreamController<List<TripRequest>>();
    FirebaseUtil.initializeFirebase().then((value) {
      FirebaseUtil.collectionReferene("tripRequests")
          .where("driverId", isEqualTo: driverId)
          .snapshots()
          .listen((querySnapshot) {
        List<TripRequest> requests = querySnapshot.docs
            .map((doc) =>
                TripRequest.fromJosn(doc.data() as Map<String, dynamic>))
            .toList();
        controller.add(requests);
      }, onError: (error) {
        controller.addError(error);
      });
    });
    return controller.stream;
  }

  static Future<void> approveTrip(TripRequest tripRequest) async {
    //
    QuerySnapshot snapshot =
        await FirebaseUtil.collectionReferene('tripRequests')
            .where('requestId', isEqualTo: tripRequest.requestId)
            .get();
    tripRequest.status = REQUEST_STATUS_APROVED;
    if (snapshot.docs.isNotEmpty) {
      await FirebaseUtil.collectionReferene('tripRequests')
          .doc(snapshot.docs[0].id)
          .update(tripRequest.toJson());
    }
  }

  static Future<bool> rejectTrip(TripRequest tripRequest) async {
    //
    QuerySnapshot snapshot =
        await FirebaseUtil.collectionReferene('tripRequests')
            .where('requestId', isEqualTo: tripRequest.requestId)
            .get();
    tripRequest.status = REQUEST_STATUS_REJECTED;
    if (snapshot.docs.isNotEmpty) {
      await FirebaseUtil.collectionReferene('tripRequests')
          .doc(snapshot.docs[0].id)
          .update(tripRequest.toJson());
          return true;
    }
    return false;
  }

    static Future<bool> cancelJourney(Journey journey) async {
    //
    QuerySnapshot snapshot =
        await FirebaseUtil.collectionReferene('journeys')
            .where('ownerId', isEqualTo: journey.ownerId)
            .get();
    journey.jorneyStatus = JOURNEY_STATUS_CANCELED;
    if (snapshot.docs.isNotEmpty) {
      await FirebaseUtil.collectionReferene('journeys')
          .doc(snapshot.docs[0].id)
          .update(journey.toJson());
          return true;
    }
    return false;
  }
}
