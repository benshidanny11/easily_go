import 'package:easylygo_app/models/PlaceModel.dart';
import 'package:easylygo_app/models/UserModel.dart';

class TripRequest {
  String requestId;
  UserModel customerDetails;
  UserModel driverDetails;
  DateTime createdAt;
  String status;
  String requestOrigin;
  String requestDestination;
  String driverId;
  String requestMessage;
  String customerId;
  PlaceModel pickupDetails;
  PlaceModel dropOfDetails;

  TripRequest(
      {required this.requestId,
      required this.customerDetails,
      required this.status,
      required this.requestOrigin,
      required this.createdAt,
      required this.driverId,
      required this.requestMessage,
      required this.customerId,
      required this.requestDestination,
      required this.driverDetails,
      required this.pickupDetails,
      required this.dropOfDetails
      });

  
  Map<String, dynamic> toJson(){
    return {
      "requestId": requestId,
      "customerDetails": customerDetails.toJson(),
      "status": status,
      "requestOrigin": requestOrigin,
      "createdAt": createdAt,
      "driverId":driverId,
      "requestMessage": requestMessage,
      "customerId":customerId,
      "requestDestination": requestDestination,
      "driverDetails":driverDetails.toJson(),
      "pickupDetails": pickupDetails.toJson(),
      "dropOfDetails": dropOfDetails.toJson(),
    };
  }

    factory TripRequest.fromJosn(Map<String, dynamic> json){
    return TripRequest(
      requestId: json["requestId"],
      customerDetails: UserModel.fromJson(json["customerDetails"]),
      status: json["status"],
      requestOrigin: json["requestOrigin"],
      createdAt: json["createdAt"].toDate(),
      driverId: json["driverId"],
      requestMessage: json["requestMessage"],
      customerId: json["customerId"],
      requestDestination: json['requestDestination'],
      driverDetails: UserModel.fromJson(json['driverDetails']),
      pickupDetails: PlaceModel.fromJson(json['pickupDetails']),
      dropOfDetails: PlaceModel.fromJson(json['dropOfDetails']),

      );
    
  }
}
