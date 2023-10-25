import 'package:easylygo_app/models/LocationModel.dart';
import 'package:easylygo_app/models/UserModel.dart';

class TripRequest {
  String requestId;
  UserModel customerDetails;
  DateTime createdAt;
  String status;
  LocationModel requestOrigin;

  TripRequest(
      {required this.requestId,
      required this.customerDetails,
      required this.status,
      required this.requestOrigin,
      required this.createdAt});

  
  Map<String, dynamic> toJson(TripRequest tr){
    return {
      "requestId": requestId,
      "customerDetails": customerDetails.toJson(),
      "status": status,
      "requestOrigin": requestOrigin,
      "createdAt": createdAt,
    };
  }

   TripRequest fromJosn(Map<String, dynamic> json){
    return TripRequest(
      requestId: json["requestId"],
      customerDetails: UserModel.fromJson(json["customerDetails"]),
      status: json["status"],
      requestOrigin: json["requestOrigin"],
      createdAt: json["createdAt"],
    );
  }
}
