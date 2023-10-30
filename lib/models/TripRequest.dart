import 'package:easylygo_app/models/LocationModel.dart';
import 'package:easylygo_app/models/UserModel.dart';

class TripRequest {
  String requestId;
  UserModel customerDetails;
  DateTime createdAt;
  String status;
  String requestOrigin;
  String driverId;
  String requestMessage;
  String customerId;

  TripRequest(
      {required this.requestId,
      required this.customerDetails,
      required this.status,
      required this.requestOrigin,
      required this.createdAt,
      required this.driverId,
      required this.requestMessage,
      required this.customerId});

  
  Map<String, dynamic> toJson(TripRequest tr){
    return {
      "requestId": requestId,
      "customerDetails": customerDetails.toJson(),
      "status": status,
      "requestOrigin": requestOrigin,
      "createdAt": createdAt,
      "driverId":driverId,
      "requestMessage": requestMessage,
      "customerId":customerId
    };
  }

   TripRequest fromJosn(Map<String, dynamic> json){
    return TripRequest(
      requestId: json["requestId"],
      customerDetails: UserModel.fromJson(json["customerDetails"]),
      status: json["status"],
      requestOrigin: json["requestOrigin"],
      createdAt: json["createdAt"],
      driverId: json["driverId"],
      requestMessage: json["requestMessage"],
      customerId: json["customerId"]
    );
  }
}
