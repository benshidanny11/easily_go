import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easylygo_app/constants/string_constants.dart';
import 'package:easylygo_app/models/Journey.dart';
import 'package:easylygo_app/models/TripRequest.dart';
import 'package:easylygo_app/models/UserModel.dart';
import 'package:easylygo_app/models/wallet.dart';
import 'package:easylygo_app/services/notification_servcice.dart';
import 'package:easylygo_app/services/wallet_service.dart';
import 'package:easylygo_app/utils/firestore_util.dart';
import 'package:easylygo_app/utils/location_util.dart';
import 'package:easylygo_app/utils/math_util.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class JourneyService {
  static Future<void> createJorney(Journey journey) async {
    await FirebaseUtil.collectionReferene("journeys").add(journey.toJson());
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
    await NotificationService.createNotification(
        tripRequest.driverDetails.docId.toString(),
        tripRequest,
        'Trip request',
        'Yo got a trip request from ${tripRequest.customerDetails.fullName}',
        TRIP_REQUEST_NOTIFICARION);
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

  static Future<bool> approveTrip(TripRequest tripRequest) async {
    Wallet wallet=await WalletService.getFutureDriverWalletInfo(tripRequest.driverId);
    if(wallet.balance>1000){
    QuerySnapshot snapshot =
        await FirebaseUtil.collectionReferene('tripRequests')
            .where('requestId', isEqualTo: tripRequest.requestId)
            .get();
    tripRequest.status = REQUEST_STATUS_APROVED;
    if (snapshot.docs.isNotEmpty) {
      Map<String, dynamic> tripCoordnates =
          await LocationUtil.getTripCoordnates(
              tripRequest.pickupDetails, tripRequest.dropOfDetails);
      final distance = await MathUtil.calculateDistance(
          LatLng(tripCoordnates['pickUpLocation']['lat'],
              tripCoordnates['pickUpLocation']['lng']),
          LatLng(tripCoordnates['dropOfLocation']['lat'],
              tripCoordnates['dropOfLocation']['lng']));
      double dist = double.parse(distance);
      if (dist < 3) {
        await WalletService.applyServiceCostOnWallet(tripRequest.driverId, 500);
      } else {
        await WalletService.applyServiceCostOnWallet(
            tripRequest.driverId, 1000);
      }
      await FirebaseUtil.collectionReferene('tripRequests')
          .doc(snapshot.docs[0].id)
          .update(tripRequest.toJson());
    }
    await NotificationService.createNotification(
        tripRequest.customerDetails.docId.toString(),
        tripRequest,
        'Trip request approved',
        'Your trip request was approved',
        APPROVED_TRIP_NOTIFICARION);
      return true;
    }else{
      return false;
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
    QuerySnapshot snapshot = await FirebaseUtil.collectionReferene('journeys')
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

  static Stream<List<TripRequest>> geCustomerTripRequests(String customerId) {
    StreamController<List<TripRequest>> controller =
        StreamController<List<TripRequest>>();
    FirebaseUtil.initializeFirebase().then((value) {
      FirebaseUtil.collectionReferene("tripRequests")
          .where("customerId", isEqualTo: customerId)
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

  static Stream<List<Journey>> getAvailableJourneys({String? searchQuery}) {
    StreamController<List<Journey>> controller =
        StreamController<List<Journey>>();

    FirebaseUtil.initializeFirebase().then((value) {
      final journeysCollection = FirebaseUtil.collectionReferene("journeys");
      journeysCollection
          .where(Filter.and(
              Filter("jorneyStatus", isEqualTo: JOURNEY_STATUS_PENDING),
              Filter("numberOfSits", isGreaterThan: 0)))
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

  static Future<bool> customerJoinJourney(
      Journey journey, UserModel customer) async {
    //
    QuerySnapshot snapshot = await FirebaseUtil.collectionReferene('journeys')
        .where('jourenyId', isEqualTo: journey.jourenyId)
        .get();
    journey.joinedPassengers.add(customer);
    journey.numberOfSits = journey.numberOfSits - 1;
    if (snapshot.docs.isNotEmpty) {
      await FirebaseUtil.collectionReferene('journeys')
          .doc(snapshot.docs[0].id)
          .update(journey.toJson());
      await NotificationService.createNotification(
          journey.ownerDetails.docId.toString(),
          journey,
          'Journey was joined',
          'You journey was joined by ${customer.fullName}',
          JOIN_JOURNEY_NOTIFICATION);
      return true;
    }
    return false;
  }

  static bool checkCustomerJoinedJourney(
      List<UserModel> joinedCustomers, String customerId) {
    for (var customer in joinedCustomers) {
      if (customer.userId == customerId) {
        return true;
      }
    }
    return false;
  }
}
