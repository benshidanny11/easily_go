import 'package:easylygo_app/common/map_page.dart';
import 'package:easylygo_app/utils/location_util.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class CustomerHomeActivities extends StatefulWidget {
  const CustomerHomeActivities({super.key});

  @override
  State<CustomerHomeActivities> createState() => _CustomerHomeActivitiesState();
}

class _CustomerHomeActivitiesState extends State<CustomerHomeActivities> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LocationUtil.getCurrentLocationData(),
      builder: (context, snapshot) {
        LocationData? _locationData = snapshot.hasData ? snapshot.data : null;
        return snapshot.connectionState == ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : EasylyGoMap(
                locationData: _locationData,
              );
      },
    );
  }
}
