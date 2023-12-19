// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:easylygo_app/constants/string_constants.dart';
import 'package:easylygo_app/models/PlaceModel.dart';
import 'package:easylygo_app/models/UserModel.dart';
import 'package:easylygo_app/pages/customers/customer_create_trip_request.dart';
import 'package:easylygo_app/providers/app_provider.dart';
import 'package:easylygo_app/services/place_service.dart';
import 'package:easylygo_app/services/user_service.dart';
import 'package:easylygo_app/utils/location_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class EasylyGoMap extends ConsumerStatefulWidget {
  final LocationData? locationData;
  const EasylyGoMap({super.key, this.locationData});

  @override
  ConsumerState<EasylyGoMap> createState() => EasylyGoMapState();
}

class EasylyGoMapState extends ConsumerState<EasylyGoMap> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Uint8List? customerMarker;
  Uint8List? driverMarker;
  Uint8List? motoRiderMarker;
  @override
  void initState() {
    super.initState();
    _loadMarkerAssetsAsset();
  }

//carmarker.png,
//motor_bike_marker.png
//mycurrent_location_marker.png

  void _loadMarkerAssetsAsset() {
    rootBundle.load('assets/images/mycurrent_location_marker.png').then((data) {
      setState(() {
        customerMarker = data.buffer.asUint8List();
      });
    });
    rootBundle.load('assets/images/carmarker_light.png').then((data) {
      setState(() {
        driverMarker = data.buffer.asUint8List();
      });
    });
    rootBundle.load('assets/images/motor_bike_marker_light.png').then((data) {
      setState(() {
        motoRiderMarker = data.buffer.asUint8List();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // LocationData myCrrentPostion=await LocationUtil.getCurrentLocationData() as LocationData;
    UserModel currentUser = ref.read(userProvider);
    CameraPosition? currentLocationCameraPosition = widget.locationData != null
        ? CameraPosition(
            target: LatLng(widget.locationData?.latitude as double,
                widget.locationData!.longitude as double),
            zoom: 16.4746,
          )
        : null;

    Set<Marker> markers = {
      Marker(
          markerId: const MarkerId('myCurrentLocation'),
          position: LatLng(widget.locationData?.latitude as double,
              widget.locationData?.longitude as double),
          infoWindow: const InfoWindow(title: 'Me'),
          // icon:  BitmapDescriptor.defaultMarkerWithHue()
          icon: customerMarker == null
              ? BitmapDescriptor.defaultMarker
              : BitmapDescriptor.fromBytes(customerMarker!)),
    };

    return StreamBuilder(
        stream: UserService.getActiveUsers(),
        builder: (BuildContext ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            List<UserModel> activeUsers = snapshot.data as List<UserModel>;
            for (var user in activeUsers) {
              markers.add(Marker(
                  markerId: MarkerId(user.userId.toString()),
                  position: LatLng(user.location!.latitude as double,
                      user.location!.longitude as double),
                  infoWindow: InfoWindow(title: user.fullName),
                  onTap: () async {
                    LocationData? locationData =
                        await LocationUtil.getCurrentLocationData();
                    PlaceModel? placeModel =
                        await PlaceService.getInitlaAddress(locationData!);
                    ref.read(placeModelProvider).placeId = placeModel!.placeId;
                    ref.read(placeModelProvider).placeDescription =
                        placeModel.placeDescription;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomerCreateTripRequest(
                                userModel: user,
                                currentUser: currentUser,
                                locationData: locationData,
                              )),
                    );
                  },
                  icon: (driverMarker != null && motoRiderMarker != null)
                      ? user.userRole == DRIVER_ROLE
                          ? BitmapDescriptor.fromBytes(driverMarker!)
                          : BitmapDescriptor.fromBytes(motoRiderMarker!)
                      : BitmapDescriptor.defaultMarker));
            }
          }
          print('marker lentgth===== ${markers.length}');

          return currentLocationCameraPosition != null
              ? GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: currentLocationCameraPosition,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: markers,
                )
              : const Center(
                  child: Text('Please enable device location'),
                );
        });
  }
}
