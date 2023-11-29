import 'package:location/location.dart';

class LocationUtil {
  static Future<LocationData?> getCurrentLocationData() async {
   Location location=Location();

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
    LocationData? locationData=await location.getLocation();

  //  location.onLocationChanged.listen((LocationData lData) {
  //    if(lData.latitude!=null && lData.longitude!=null){
  //     _locationData=lData;
  //    }
  //  },);
    return locationData;
  }
}
