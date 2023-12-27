import 'package:easylygo_app/common/colors.dart';
import 'package:easylygo_app/common/text_styles.dart';
import 'package:easylygo_app/common/widgets.dart';
import 'package:easylygo_app/constants/string_constants.dart';
import 'package:easylygo_app/models/transaction.dart';
import 'package:easylygo_app/services/wallet_service.dart';
import 'package:easylygo_app/utils/alert_util.dart';
import 'package:easylygo_app/utils/date_util.dart';
import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel transactionModel;
  const TransactionItem({super.key, required this.transactionModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(
              width: 1, color: const Color.fromARGB(255, 232, 232, 232)),
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.payment,
                  color: AppColors.mainColor),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateUtil.getDateTimeString(transactionModel.transactionDate),
                    style: textStyleTitle(16),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    transactionModel.transactionAmount.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textStyleContentSmall(13),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                 CommonWidgets.tag(
                          transactionModel.transactionStatus == TRANSACTION_PENDING || transactionModel.transactionStatus == TRANSACTION_INITIATED
                              ? AppColors.colorWarning
                              : transactionModel.transactionStatus == TRANSACTION_SUCEEDED
                                  ? AppColors.colorSuccess
                                  : AppColors.colorError,
                          transactionModel.transactionStatus)
                ],
              ),
            ],
          ),
         transactionModel.transactionStatus==TRANSACTION_PENDING?  GestureDetector(
            onTap: () async{
               AlertUtil.showLoadingAlertDialig(context, 'Updating wallet', false);
               await WalletService.updateWallet(transactionModel);
               Navigator.of(context).pop();
            },
            child: const  Padding(
              padding: EdgeInsets.all(10),
              child: Icon(
                Icons.refresh,
                color: AppColors.mainColor,
              ),
            ),
          ):Container()
        ],
      ),
    );
  }
}
