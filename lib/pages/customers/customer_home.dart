import 'package:flutter/material.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _HomePageState();
}

class _HomePageState extends State<CustomerHomePage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        child: Center(child: Text("Customer dashboard"),),
      ),
    );
  }
}