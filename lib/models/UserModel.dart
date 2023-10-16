import 'package:easylygo_app/constants/string_constants.dart';

class UserModel {
  String? fullName;
  String? email;
  String? phoneNumber;
  String? userId;
  String? homeAddress;
  String userRole;
  DateTime? regDate;
  String? imageUrl;



  UserModel(
      { this.fullName,
        this.email,
        this.phoneNumber,
        this.userId,
        this.homeAddress,
        this.userRole=CUSTOMER_ROLE,
        this.regDate,
        this.imageUrl});
  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "email": email,
      "phoneNumber": phoneNumber,
      "userId": userId,
      "homeAddress": homeAddress,
      "userRole":userRole,
      "regDate":regDate,
      "imageUrl":imageUrl
    };
  }

  UserModel fromJson(Map<String, dynamic> json) {
    return UserModel(
        fullName: json['fullName'],
        email: json['email'],
        phoneNumber: json['phoneNumber'],
        userId: json['userId'],
        homeAddress: json['homeAddress'],
        userRole:json['userRole'],
        regDate:json['regDate'],
         imageUrl:json['imageUrl']);   
  }
}
