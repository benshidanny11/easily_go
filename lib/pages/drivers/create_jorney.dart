import 'package:easylygo_app/common/button_blue.dart';
import 'package:easylygo_app/common/colors.dart';
import 'package:easylygo_app/common/input_decorations.dart';
import 'package:easylygo_app/common/text_styles.dart';
import 'package:easylygo_app/common/widgets.dart';
import 'package:easylygo_app/constants/routes.dart';
import 'package:easylygo_app/models/Journey.dart';
import 'package:easylygo_app/models/UserModel.dart';
import 'package:easylygo_app/providers/app_provider.dart';
import 'package:easylygo_app/services/jorney_service.dart';
import 'package:easylygo_app/services/user_service.dart';
import 'package:easylygo_app/utils/alert_util.dart';
import 'package:easylygo_app/utils/date_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';

class CreateJourney extends ConsumerStatefulWidget {
  const CreateJourney({super.key});

  @override
  ConsumerState<CreateJourney> createState() => _CreateJourneyState();
}

class _CreateJourneyState extends ConsumerState<CreateJourney> {
  final originController = TextEditingController();
  final destinationController = TextEditingController();
  final priceController = TextEditingController();
  DateTime? startTime;
  bool validateOrign = false;
  bool validateDestination = false;
  bool validatePrice = false;
  String jorneyType = "Trip";

  String choosenDate = DateUtil.getDateString(DateTime.now());
  String choosenTime = DateUtil.getTimeString(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final sreenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidgets.customAppBar("Easily Go"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      FontAwesomeIcons.road,
                      color: AppColors.mainColor,
                      size: 50,
                    ),
                    Text(
                      'Create journey',
                      style: textStyleTitle(17),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Provide jorney information below',
                      style: textStyleContentSmall(12),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CommonWidgets.customDivider(),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: sreenWidth * .9,
                child: TextField(
                  decoration: InputDecorations.getInputTextDecoration(
                      "Journey origin", Icons.location_on, validateOrign),
                  controller: originController,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: sreenWidth * .9,
                child: TextField(
                  decoration: InputDecorations.getInputTextDecoration(
                      "Journey destination",
                      Icons.location_on,
                      validateDestination),
                  controller: destinationController,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecorations.getInputTextDecoration(
                    "Jorney type", Icons.cases, false),
                value: jorneyType,
                items: <String>['Trip', 'Cargo']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: textStyleContentSmall(12),
                    ),
                  );
                }).toList(),
                // Step 5.
                onChanged: (String? newValue) {
                  setState(() {
                    jorneyType = newValue!;
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: sreenWidth * .9,
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecorations.getInputTextDecoration(
                      "Jorney price", Icons.monetization_on, validatePrice),
                  controller: priceController,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text("Jorney start time"),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: sreenWidth * .9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(choosenDate),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                            onTap: () async {
                              DateTime pickedDate =
                                  await DateUtil.pickDate(context);
                              setState(() {
                                choosenDate =
                                    DateUtil.getDateString(pickedDate);
                              });
                            },
                            child: const Icon(Icons.date_range,
                                size: 20, color: AppColors.mainColor))
                      ],
                    ),
                    CommonWidgets.customVerticalDivider(),
                    Row(
                      children: [
                        Text(choosenTime),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                            onTap: () async {
                              String pickedTime =
                                  await DateUtil.getTimeStringFromTime(context);

                              setState(() {
                                choosenTime = pickedTime;
                              });
                            },
                            child: const Icon(
                              FontAwesomeIcons.clock,
                              color: AppColors.mainColor,
                              size: 20,
                            ))
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ButtonBlue(
                  onPress: () async{

                    AlertUtil.showLoadingAlertDialig(context, "Creating journey", false);
                    var uuid =const Uuid().v4();
                    UserModel ownerDetails=ref.read(userProvider);
                    Journey journey = Journey(
                        jourenyId: uuid,
                        origin: originController.text,
                        destination: destinationController.text,
                        startTime: DateUtil.getDateFromString('$choosenDate $choosenTime') as DateTime,
                        ownerDetails: ownerDetails,
                        journeyPricePerKM: double.parse(priceController.text),
                        jorneyDistance: 0,
                        createdAt: DateTime.now(),
                        jorneyStatus: "Pending",
                        joinedPassengers: [],
                        jorneyType: jorneyType,
                        ownerId: ownerDetails.userId.toString());

                    await  JorneyService.createJorney(journey);
                    Navigator.pushReplacementNamed(context, HOME_ROUTE);
                  },
                  label: "Create jorney",
                  width: 200,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
