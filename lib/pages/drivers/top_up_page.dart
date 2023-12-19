
import 'package:easylygo_app/common/button_blue.dart';
import 'package:easylygo_app/common/input_decorations.dart';
import 'package:easylygo_app/common/text_styles.dart';
import 'package:easylygo_app/providers/app_provider.dart';
import 'package:easylygo_app/services/wallet_service.dart';
import 'package:easylygo_app/utils/alert_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TopUpWalletPage extends ConsumerStatefulWidget {

  const TopUpWalletPage({super.key});

  @override
  ConsumerState<TopUpWalletPage> createState() => _TopUpWalletPageState();
}

class _TopUpWalletPageState extends ConsumerState<TopUpWalletPage> {

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  final phoneNumberControll = TextEditingController();
  final amount = TextEditingController();
  bool validateAmount = false;
  bool validatePhoneNumber = false;
  
  @override
  Widget build(BuildContext context) {
    final sreenWidth = MediaQuery.of(context).size.width;
    final sreenHeight = MediaQuery.of(context).size.height;
    final user = ref.read(userProvider);
   String walletId=  ModalRoute.of(context)!.settings.arguments as String;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title:const Text('Easyly go'), elevation: 1,),
          body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: SizedBox(
            height: sreenHeight * .9,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Image.asset('assets/images/app_logo_blue.png'),
                      Text(
                        'Update your wallet',
                        style: textStyleTitle(17),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: sreenWidth * .9,
                        child: TextField(
                           keyboardType: TextInputType.phone,
                          decoration: InputDecorations.getInputTextDecoration(
                              "Phone number", Icons.phone, validatePhoneNumber),
                          controller: phoneNumberControll,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: sreenWidth * .9,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecorations.getInputTextDecoration(
                              "Amount", FontAwesomeIcons.dollarSign, validateAmount),
                          controller: amount,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ButtonBlue(
                        onPress: () async{
                          try {
                            AlertUtil.showLoadingAlertDialig(context, 'Initiating payment', false);
                            setState(() {
                              validateAmount = amount.text.isEmpty;
                              validatePhoneNumber =
                                  phoneNumberControll.text.isEmpty;
                            });
                            if (!validateAmount &&
                                !validatePhoneNumber) {
                              ref.read(userProvider).phoneNumber =
                                  phoneNumberControll.text;
                             await WalletService.topUpWallet(user.userId.toString(), walletId,phoneNumberControll.text, double.parse(amount.text));
                            //  Navigator.pop(context);
                            //  Navigator.pop(context);
                            }
                          } catch (error) {
                            print(error);
                          }
                        },
                        label: 'Proceed', width: 200,),
                  )
                ]),
          ),
        ),
      )),
    );
  }
}
