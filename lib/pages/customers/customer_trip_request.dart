import 'package:flutter/material.dart';

class CustomerTripRequest extends StatefulWidget {
  const CustomerTripRequest({super.key});

  @override
  State<CustomerTripRequest> createState() => _CustomerTripRequestState();
}

class _CustomerTripRequestState extends State<CustomerTripRequest> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Center(child: Text('My trips'),),
    ));
  }
}
