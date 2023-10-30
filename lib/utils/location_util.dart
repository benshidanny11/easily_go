import 'package:location/location.dart';

class LocationUtil {
  static Future<LocationData?> getCurrentLocationData() async {
   Location location=Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    LocationData? _locationData=await location.getLocation();

  //  location.onLocationChanged.listen((LocationData lData) {
  //    if(lData.latitude!=null && lData.longitude!=null){
  //     _locationData=lData;
  //    }
  //  },);
    return _locationData;
  }
}
