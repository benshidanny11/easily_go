import 'package:easylygo_app/common/button_blue.dart';
import 'package:easylygo_app/common/text_styles.dart';
import 'package:easylygo_app/items/item_pricing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PricingPage extends ConsumerWidget {
  const PricingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title:const Text('Easyly Go'),),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Image.asset('assets/images/app_logo_blue.png'),
              Text(
                'Easily Go',
                style: textStyleBlue(17),
              )
            ],
          ),
          const ItemPricing(title: 'Journey posting:', description: 'In order to post jorney you should have atleast 8% of the journey price on your wallet balance. 8% of the journey price will be deducted from your wallet as service cost.',),
          const SizedBox(height: 10,),
            const ItemPricing(title: 'Trip requests acceptance:', description: 'In order to post jorney you should have atlease 1000 on your wallet balance. If the trip is below or equal 3km 500 will be deducted from your wallet as service cost. Other wise 1000 will be deducted from your wallet',),
           const SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ButtonBlue(
              onPress: () {
                 Navigator.pop(context);
              },
              label: "Back",
              width: 320,
            ),
          )
        ],
      ),
    );
  }
}
