import 'package:easylygo_app/models/PlaceModel.dart';
import 'package:easylygo_app/models/UserModel.dart';

class Journey {
  String jourenyId;
  String origin;
  String destination;
  DateTime startTime;
  UserModel ownerDetails;
  double journeyPricePerKM;
  List<UserModel> joinedPassengers;
  double jorneyDistance;
  DateTime createdAt;
  String jorneyStatus;
  String jorneyType;
  String ownerId;
  int numberOfSits;
  PlaceModel originDetails;
  PlaceModel destinationDetails;

  Journey(
      {required this.jourenyId,
      required this.origin,
      required this.destination,
      required this.startTime,
      required this.ownerDetails,
      required this.journeyPricePerKM,
      required this.jorneyDistance,
      required this.joinedPassengers,
      required this.createdAt,
      required this.jorneyStatus,
      required this.jorneyType,
      required this.ownerId,
      required this.numberOfSits,
      required this.originDetails,
      required this.destinationDetails});

  Map<String, dynamic> toJson() {
    return {
      "jourenyId": jourenyId,
      "origin": origin,
      "destination": destination,
      "startTime": startTime,
      "ownerDetails": ownerDetails.toJson(),
      "journeyPricePerKM": journeyPricePerKM,
      "jorneyDistance": jorneyDistance,
      "joinedPassengers": joinedPassengers.map((passeger) => passeger.toJson()),
      "createdAt": createdAt,
      "jorneyStatus": jorneyStatus,
      "jorneyType": jorneyType,
      "ownerId": ownerId,
      "numberOfSits":numberOfSits,
      "originDetails":originDetails.toJson(),
      "destinationDetails": destinationDetails.toJson()
    };
  }

  factory Journey.fromJson(dynamic json) {
    List<UserModel> passengers=[];
    json["joinedPassengers"].map((passenger)=>passengers.add(UserModel.fromJson(passenger))).toList();
    return Journey(
      jourenyId: json["jourenyId"],
      origin: json["origin"],
      destination: json["destination"],
      startTime: json["startTime"].toDate(),
      ownerDetails: UserModel.fromJson(json["ownerDetails"]),
      journeyPricePerKM: json["journeyPricePerKM"],
      jorneyDistance: json["jorneyDistance"] * 0.0,
      joinedPassengers:  passengers,
      createdAt: json["createdAt"].toDate(),
      jorneyStatus: json["jorneyStatus"],
      jorneyType: json["jorneyType"],
      ownerId: json["ownerId"],
      numberOfSits:json["numberOfSits"],
      originDetails:PlaceModel.fromJson(json["originDetails"]),
      destinationDetails:PlaceModel.fromJson(json["destinationDetails"]),
    );
  }
}
