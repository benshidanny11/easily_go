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
      required this.ownerId});

  Map<String, dynamic> toJson(Journey jrn) {
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
      "ownerId": ownerId
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
      jorneyDistance: json["jorneyDistance"],
      joinedPassengers:  passengers,
      createdAt: json["createdAt"].toDate(),
      jorneyStatus: json["jorneyStatus"],
      jorneyType: json["jorneyType"],
      ownerId: json["ownerId"]
    );
  }
}
