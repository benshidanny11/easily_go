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

  UserModel(
      { this.fullName,
        this.email,
        this.phoneNumber,
        this.userId,
        this.homeAddress,
        this.userRole=CUSTOMER_ROLE,
        this.regDate,
        this.imageUrl,
        this.status,
        this.location});
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
       "location":location!=null ? location!.toJson(): null
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
        status: json['status'],
        location:json['location'] !=null? LocationModel.fromJson(json['location']): null);  
  }
}
