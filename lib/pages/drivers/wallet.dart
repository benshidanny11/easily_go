import 'package:easylygo_app/common/button_blue.dart';
import 'package:easylygo_app/common/colors.dart';
import 'package:easylygo_app/common/text_styles.dart';
import 'package:easylygo_app/common/widgets.dart';
import 'package:easylygo_app/constants/routes.dart';
import 'package:easylygo_app/models/wallet.dart';
import 'package:easylygo_app/providers/app_provider.dart';
import 'package:easylygo_app/services/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletPage extends ConsumerStatefulWidget {
  const WalletPage({super.key});

  @override
  ConsumerState<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends ConsumerState<WalletPage> {
 
  @override
  Widget build(BuildContext context) {
      String userId = ref.read(userProvider).userId.toString();
    return  Padding(
      padding: const EdgeInsets.all(10),
      child: StreamBuilder(stream: WalletService.getDriverWalletInfo(userId), builder: (xtx, snapshot) {
         if (snapshot.connectionState == ConnectionState.waiting) {
                   return const Center(child: SizedBox(width: 20, height: 20,child: CircularProgressIndicator()));
                  }
                  if(snapshot.hasError){
                      print("**********&&&&&&Error in get journeys --======${snapshot.error} ");
                      return const Center(child: Text('An error has occred'),);
                  }
          if(snapshot.hasData){
             Wallet wallet = snapshot.data as Wallet;

               return  SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your wallet",
                        style: textStyleTitle(17),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        "Balance: ${wallet.balance}",
                        style: textStyleContentSmall(12),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
      
                  ButtonBlue(onPress: (){

                      Navigator.pushNamed(context, TOPUP_WALLET_PAGE, arguments: wallet.id);
                  }, label: 'Top up')
                ],
              ),
                const SizedBox(
                height: 20,
              ),
              Text('Your transactions', style: textStyleBlue(13),),
                const SizedBox(
                height: 5,
              ),
              CommonWidgets.customDivider(),
              const SizedBox(
                height: 10,
              ),
                    //  SizedBox(
                    //   height: 90.0 * journeItems.length,
                    //   child: ListView.builder(
                    //       itemBuilder: (BuildContext context, int index) {
                    //     return JourneyItem(journey: journeItems[index]);
                    //   }, itemCount: journeItems.length,),
                    // )
              
            ],
          ),
        );
          }else{
             return const Center(child: Text('Your wallet has issues'),);
          }
      },),
    );
  }
}