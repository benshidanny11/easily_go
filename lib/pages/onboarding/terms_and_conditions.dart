import 'package:easylygo_app/common/text_styles.dart';
import 'package:easylygo_app/constants/routes.dart';
import 'package:easylygo_app/models/UserModel.dart';
import 'package:easylygo_app/providers/app_provider.dart';
import 'package:easylygo_app/services/user_service.dart';
import 'package:easylygo_app/utils/alert_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TermsAndConditions extends ConsumerStatefulWidget {
  const TermsAndConditions({super.key});

  @override
  ConsumerState<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends ConsumerState<TermsAndConditions> {
  bool _isAgreeChecked = false;
  @override
  Widget build(BuildContext context) {
    final sreenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    Image.asset('assets/images/app_logo_blue.png'),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/images/icon_document_blue.png'),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Accept Easily Go Terms & Conditions',
                              style: textStyleTitle(17),
                            ),
                            Container(
                              width: sreenWidth * .75, // Example width
                              child: Text(
                                'By selecting “I Agree” bellow, you have reviewed  and agree the Terms and acknowledged the privacy notice',
                                style: textStyleBlue(12).copyWith(
                                  decoration: TextDecoration.underline,
                                  overflow: TextOverflow.clip,
                                ),
                                maxLines: 3,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  const Divider(
                    height: 1,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                                value: _isAgreeChecked,
                                onChanged: (checked) {
                                  setState(() {
                                    _isAgreeChecked = checked!;
                                  });
                                }),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(
                              'I agree',
                              style: textStyleContentSmall(12),
                            )
                          ],
                        ),
                        GestureDetector(
                            onTap: _isAgreeChecked
                                ? () async{
                                   AlertUtil.showLoadingAlertDialig(context, "Registering user", false);
                                    UserModel userModel=ref.read(userProvider);
                                    await UserService.registerUser(userModel);
                                    Navigator.pushReplacementNamed(context, HOME_ROUTE);
                                  }
                                : null,
                            child: Image.asset(_isAgreeChecked
                                ? 'assets/images/icon_next.png'
                                : 'assets/images/icon_next_muted.png')),
                      ])
                ],
              )
            ]),
      )),
    );
  }
}
