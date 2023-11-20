import 'dart:convert';
import 'package:easylygo_app/models/LocationModel.dart';
import 'package:easylygo_app/models/PlaceModel.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class PlaceService {
  static Future<PlaceModel?> getInitlaAddress(
      LocationData currentLocation) async {
    print("Hello=========<<<<<<>>>>>>>>>>>");
    final placeResponse = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${currentLocation.latitude},${currentLocation.longitude}&key=AIzaSyCpJ4SXuPYA8dKuUqHAqwRnEJB63ThtsuM'));

    Map<String, dynamic> placeData = jsonDecode(placeResponse.body);

    // print(placeData['results'][0]);
    // print(placeData['results'][0]['place_id']);
    PlaceModel placeModel = PlaceModel(
        placeId: placeData['results'][0]['place_id'],
        placeDescription: placeData['results'][0]['formatted_address'],);
    return placeModel;
  }
}
