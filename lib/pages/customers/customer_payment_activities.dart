import 'package:flutter/material.dart';

class CustomerPaymentPage extends StatefulWidget {
  const CustomerPaymentPage({super.key});

  @override
  State<CustomerPaymentPage> createState() => _CustomerPaymentPageState();
}

class _CustomerPaymentPageState extends State<CustomerPaymentPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Payment'),);
  }
}