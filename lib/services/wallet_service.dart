import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easylygo_app/config/config.dart';
import 'package:easylygo_app/constants/string_constants.dart';
import 'package:easylygo_app/models/transaction.dart';
import 'package:easylygo_app/models/wallet.dart';
import 'package:easylygo_app/utils/firestore_util.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class WalletService {
  static Stream<Wallet> getDriverWalletInfo(String driverId) {
    StreamController<Wallet> controller = StreamController<Wallet>();

    FirebaseUtil.initializeFirebase().then((value) {
      FirebaseUtil.collectionReferene("wallets")
          .where("driverId", isEqualTo: driverId)
          .snapshots()
          .listen((querySnapshot) {
        QueryDocumentSnapshot walletDocument = querySnapshot.docs[0];
        Wallet wallet = Wallet.fromJson(walletDocument);
        controller.add(wallet);
      }, onError: (error) {
        controller.addError(error);
      });
    });
    return controller.stream;
  }

  static Future<bool> topUpWallet(String driverId, String walletId,
      String phoneNumber, double amount) async {
    print("+++++++++++++MKSJKSJK++++++");
    const authUrl = '$PAYMENT_API_LINK_RWANDA/auth/agents/authorize';
    const paymentUrl =
        '$PAYMENT_API_LINK_RWANDA/transactions/cashin?Idempotency-Key=OldbBsHAwAdcYalKLXuiMcqRrdEcDGRv';
    print(authUrl);
    var uuid = const Uuid().v4();
    TransactionModel transactionModel = TransactionModel(
        transactionId: uuid,
        transactionAmount: amount,
        transactionStatus: TRANSACTION_INITIATED,
        paymentReference: '',
        paymentType: 'TOPUP',
        transactionDate: DateTime.now(),
        comment: 'TRansaction initiated',
        userId: driverId,
        walletId: walletId);
    await FirebaseUtil.collectionReferene("transactions")
        .add(transactionModel.toJson());
    final authResponse = await http.post(
        Uri.parse(
          authUrl,
        ),
        // headers: {
        //   'Content-Type': 'application/json'
        // },
        body: convert.jsonEncode({
          "client_id": PAYMENT_API_ID_RWANDA,
          "client_secret": PAYMENT_API_SECRET_RWANDA
        }));

    dynamic authData = convert.jsonDecode(authResponse.body);
    if (authData['access'] != null && authData['access'] != '') {
      String accessToken = authData['access'];
      final paymentResponse = await http.post(
          Uri.parse(
            paymentUrl,
          ),
          headers: {'Authorization': 'Bearer '},
          body: convert.jsonEncode({
            {"amount": amount, "number": phoneNumber}
          }));
      //TODO   transactionModel.paymentReference='';
      // Updatate transaction;
      return true;
    }

    return false;
  }
}
