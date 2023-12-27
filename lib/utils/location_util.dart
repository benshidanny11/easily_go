import 'dart:convert';
import 'package:easylygo_app/models/PlaceModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:easylygo_app/config/config.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationUtil {
  static Future<LocationData?> getCurrentLocationData() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    LocationData? locationData = await location.getLocation();

    //  location.onLocationChanged.listen((LocationData lData) {
    //    if(lData.latitude!=null && lData.longitude!=null){
    //     _locationData=lData;
    //    }
    //  },);
    return locationData;
  }

  static Future<Map<String, dynamic>> getTripCoordnates(
      PlaceModel picupPlace, PlaceModel dropOffPlace) async {
    final picupPlaceResponse = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=${picupPlace.placeId}&key=$GOOGLE_MAP_API_KEY'));

    final dropOffPlaceResponse = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=${dropOffPlace.placeId}&key=$GOOGLE_MAP_API_KEY'));
    Map<String, dynamic> pickupPlaceData = jsonDecode(picupPlaceResponse.body);
    Map<String, dynamic> dropOffPlaceData =
        jsonDecode(dropOffPlaceResponse.body);
    print(
        '<<<<<<<<<<<<<<<<<<<<Plickup coordninates>>>>>>>>>>>>>>>>: ${pickupPlaceData['result']['geometry']['location']}');

           print(
        '<<<<<<<<<<<<<<<<<<<<Dropoff coordninates>>>>>>>>>>>>>>>>: ${dropOffPlaceData['result']['geometry']['location']}');
    return {
      'pickUpLocation': pickupPlaceData['result']['geometry']['location'],
      'dropOfLocation': dropOffPlaceData['result']['geometry']['location']
    };
  }
}
