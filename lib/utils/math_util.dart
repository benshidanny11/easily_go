import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';


class MathUtil{

 static Future<String> calculateDistance(LatLng point1, LatLng point2) async{
 double distanceInMeters = await Geolocator.distanceBetween(
      point1.latitude,
      point1.longitude,
      point2.latitude,
      point2.longitude,
    );
    return (distanceInMeters/1000).toStringAsFixed(2);
}

static double _toRadians(double degree) {
  return degree * pi / 180;
}
}