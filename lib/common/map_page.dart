import 'dart:async';

import 'package:easylygo_app/constants/string_constants.dart';
import 'package:easylygo_app/models/TripRequest.dart';
import 'package:easylygo_app/models/UserModel.dart';
import 'package:easylygo_app/providers/app_provider.dart';
import 'package:easylygo_app/services/journey_service.dart';
import 'package:easylygo_app/services/user_service.dart';
import 'package:easylygo_app/utils/alert_util.dart';
import 'package:easylygo_app/utils/math_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';

class EasylyGoMap extends ConsumerStatefulWidget {
  final LocationData? locationData;
  EasylyGoMap({super.key, this.locationData});

  @override
  ConsumerState<EasylyGoMap> createState() => EasylyGoMapState();
}

class EasylyGoMapState extends ConsumerState<EasylyGoMap> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

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
        markerId: MarkerId('myCurrentLocation'),
        position: LatLng(widget.locationData?.latitude as double,
            widget.locationData?.longitude as double),
        infoWindow: InfoWindow(title: 'Me'),
        // icon:  BitmapDescriptor.defaultMarkerWithHue()
      ),
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
            activeUsers.forEach((user) {
              markers.add(Marker(
                markerId: MarkerId(user.userId.toString()),
                position: LatLng(user.location!.latitude as double,
                    user.location!.longitude as double),
                infoWindow: InfoWindow(title: user.fullName),
                onTap: () {
                  _createJourneyRequest(
                      context, user, widget.locationData!, currentUser);
                },
              ));
            });
          }
          print('marker lentgth===== ${markers.length}');

          return currentLocationCameraPosition != null
              ? GoogleMap(
                  mapType: MapType.hybrid,
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

  static void _createJourneyRequest(BuildContext context, UserModel userModel,
      LocationData locationData, UserModel currentUser) async {
    final messageController = TextEditingController();
    final locationController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return FutureBuilder(
            future: MathUtil.calculateDistance(
                LatLng(locationData.latitude!, locationData.longitude!),
                LatLng(userModel.location!.latitude!,
                    userModel.location!.longitude!)),
            builder: (contex, snapshot) {
              String distance = snapshot.hasData ? snapshot.data! : '';
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(5), // Adjust the value as needed
                ),
                title: const Text('Send request'),
                content: Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                          'Send request to ${userModel.fullName.toString()} Located in $distance KM'),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Enter your current location'),
                        controller: locationController,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Enter your message'),
                        controller: messageController,
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close'),
                  ),
                  TextButton(
                    onPressed: () async {
                      AlertUtil.showLoadingAlertDialig(
                          context, "Sending request", false);
                      var uuid = const Uuid().v4();
                      TripRequest request = TripRequest(
                          requestId: uuid,
                          customerDetails: currentUser,
                          status: REQUEST_STATUS_PENDING,
                          requestOrigin: locationController.text,
                          createdAt: DateTime.now(),
                          driverId: userModel.userId!,
                          requestMessage: messageController.text,
                          customerId: currentUser.userId!);
                      await JourneyService.createTripRequest(request);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Request has been submitted!"),
                      ));
                    },
                    child: Text('Submit'),
                  ),
                ],
              );
            },
          );
        });
  }
}
