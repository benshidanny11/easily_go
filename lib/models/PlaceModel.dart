import 'package:easylygo_app/models/LocationModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceModel {
  String? placeId;
  String? placeDescription;

  PlaceModel(
      { this.placeId,
       this.placeDescription});

  Map<String, dynamic> toJson() {
    return {
      "placeId": placeId,
      "placeDescription": placeDescription,
    };
  }

  factory PlaceModel.fromJson(dynamic json) {
    return PlaceModel(
        placeId: json['placeId'],
        placeDescription: json['placeDescription']);
  }
}
