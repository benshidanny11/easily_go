import 'package:easylygo_app/common/button_blue.dart';
import 'package:easylygo_app/common/colors.dart';
import 'package:easylygo_app/constants/routes.dart';
import 'package:easylygo_app/constants/string_constants.dart';
import 'package:easylygo_app/models/PlaceModel.dart';
import 'package:easylygo_app/models/TripRequest.dart';
import 'package:easylygo_app/models/UserModel.dart';
import 'package:easylygo_app/providers/app_provider.dart';
import 'package:easylygo_app/services/journey_service.dart';
import 'package:easylygo_app/strings/extracted.dart';
import 'package:easylygo_app/utils/alert_util.dart';
import 'package:easylygo_app/utils/math_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';

class CustomerCreateTripRequest extends ConsumerStatefulWidget {
  final UserModel userModel;
  final LocationData locationData;
  final UserModel currentUser;
  const CustomerCreateTripRequest(
      {super.key,
      required this.userModel,
      required this.locationData,
      required this.currentUser});

  @override
  ConsumerState<CustomerCreateTripRequest> createState() =>
      _CustomerCreateTripRequestState();
}

class _CustomerCreateTripRequestState
    extends ConsumerState<CustomerCreateTripRequest> {
  PlaceModel? foundPicupPlace;
  PlaceModel? foundDropOfPlace;

  final messageController = TextEditingController();
  final pickUpLocationController = TextEditingController();
  final dropOffLocationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    foundPicupPlace = ref.watch(placeModelProvider);
    foundDropOfPlace = ref.watch(dropOffPlaceModelProvider);
    pickUpLocationController.text =
        foundPicupPlace!.placeDescription.toString();
    dropOffLocationController.text = foundDropOfPlace!.placeDescription != null
        ? foundDropOfPlace!.placeDescription.toString()
        : '';
    final scrrenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easily go'),
        elevation: 1,
      ),
      body: FutureBuilder(
        future: MathUtil.calculateDistance(
            LatLng(
                widget.locationData.latitude!, widget.locationData.longitude!),
            LatLng(widget.userModel.location!.latitude!,
                widget.userModel.location!.longitude!)),
        builder: (contex, snapshot) {
          String distance = snapshot.hasData ? snapshot.data! : '';
          // Text('Send request');
          return Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                    'Send request to ${widget.userModel.fullName.toString()} Located in $distance KM'),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: scrrenWidth * .8,
                      child: TextFormField(
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        readOnly: true,
                        decoration: const InputDecoration(
                            labelText: 'Pick-up location'),
                        controller: pickUpLocationController,
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          FIND_PLACE_PLACE_MODE = "PICK_UP_MODE";
                          Navigator.pushNamed(context, SEARCH_PLACES);
                        },
                        child: const Icon(
                          Icons.edit,
                          color: AppColors.mainColor,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: scrrenWidth * .8,
                      child: TextFormField(
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        readOnly: true,
                        decoration: const InputDecoration(
                            labelText: 'Drop off location',),
                        controller: dropOffLocationController,
                        
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          FIND_PLACE_PLACE_MODE = "DROP_OFF_MODE";
                          Navigator.pushNamed(context, SEARCH_PLACES);
                        },
                        child: const Icon(
                          Icons.search,
                          color: AppColors.mainColor,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: SizedBox(
                    width: scrrenWidth * .85,
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                          labelText: 'Enter your message'),
                      controller: messageController,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'),
                    ),
                    ButtonBlue(
                      onPress: () async {
                        AlertUtil.showLoadingAlertDialig(
                            context, "Sending request", false);
                        var uuid = const Uuid().v4();
                        TripRequest request = TripRequest(
                            requestId: uuid,
                            customerDetails: widget.currentUser,
                            status: REQUEST_STATUS_PENDING,
                            requestOrigin: pickUpLocationController.text,
                            requestDestination: dropOffLocationController.text,
                            createdAt: DateTime.now(),
                            driverId: widget.userModel.userId!,
                            requestMessage: messageController.text,
                            customerId: widget.currentUser.userId!,
                            driverDetails: widget.userModel,
                            pickupDetails: foundPicupPlace!,
                            dropOfDetails: foundDropOfPlace!);
                        await JourneyService.createTripRequest(request);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Request has been submitted!"),
                        ));
                      },
                      label: 'Submit',
                      width: 150,
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
