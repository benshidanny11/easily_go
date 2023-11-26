import 'package:easylygo_app/constants/string_constants.dart';
import 'package:easylygo_app/models/LocationModel.dart';

class UserModel {
  String? fullName;
  String? email;
  String? phoneNumber;
  String? userId;
  String? homeAddress;
  String userRole;
  DateTime? regDate;
  String? imageUrl;
  String? status;
  LocationModel? location;
  String? deviceToken;
  String? docId;

  UserModel(
      { this.fullName,
        this.email,
        this.phoneNumber,
        this.userId,
        this.homeAddress,
        this.userRole=CUSTOMER_ROLE,
        this.regDate,
        this.imageUrl,
        this.status='active',
        this.location,
        this.deviceToken, 
        this.docId});
  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "email": email,
      "phoneNumber": phoneNumber,
      "userId": userId,
      "homeAddress": homeAddress,
      "userRole":userRole,
      "regDate":regDate,
      "imageUrl":imageUrl,
       "status":status,
       "location":location!=null ? location!.toJson(): null,
       "deviceToken":deviceToken,
       "docId":docId
    };
  }

  factory UserModel.fromJson(dynamic json) {
    return UserModel(
        fullName: json['fullName'],
        email: json['email'],
        phoneNumber: json['phoneNumber'],
        userId: json['userId'],
        homeAddress: json['homeAddress'],
        userRole:json['userRole'],
        regDate:json['regDate'].toDate(),
        imageUrl:json['imageUrl'],
        status: json['status'] ?? 'offline',
        location:json['location'] !=null? LocationModel.fromJson(json['location']): null,
        deviceToken:json['deviceToken'],
        docId:json ['docId']); 

  }
}
