import 'package:easylygo_app/common/button_blue.dart';
import 'package:easylygo_app/common/colors.dart';
import 'package:easylygo_app/common/input_decorations.dart';
import 'package:easylygo_app/common/text_styles.dart';
import 'package:easylygo_app/common/widgets.dart';
import 'package:easylygo_app/constants/routes.dart';
import 'package:easylygo_app/constants/string_constants.dart';
import 'package:easylygo_app/models/Journey.dart';
import 'package:easylygo_app/models/PlaceModel.dart';
import 'package:easylygo_app/models/UserModel.dart';
import 'package:easylygo_app/providers/app_provider.dart';
import 'package:easylygo_app/services/journey_service.dart';
import 'package:easylygo_app/strings/extracted.dart';
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
  final sitsController = TextEditingController();
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
    PlaceModel? foundPicupPlace;
    PlaceModel? foundDropOfPlace;

    foundPicupPlace = ref.watch(placeModelProvider);
    foundDropOfPlace = ref.watch(dropOffPlaceModelProvider);
    originController.text =
        foundPicupPlace!.placeDescription.toString();
    destinationController.text = foundDropOfPlace!.placeDescription != null
        ? foundDropOfPlace.placeDescription.toString()
        : '';
    final scrrenWidth = MediaQuery.of(context).size.width;
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
             Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: scrrenWidth * .8,
                      child: TextFormField(
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        readOnly: true,
                        decoration: const InputDecoration(
                            labelText: 'Journey origin'),
                        controller: originController,
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          FIND_PLACE_PLACE_MODE= "PICK_UP_MODE";
                          Navigator.pushNamed(context, SEARCH_PLACES);
                        },
                        child: const Icon(
                          Icons.edit,
                          color: AppColors.mainColor,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: scrrenWidth * .8,
                      child: TextFormField(
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        readOnly: true,
                        decoration: const InputDecoration(
                            labelText: 'Journey destination'),
                        controller: destinationController,
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          FIND_PLACE_PLACE_MODE = "DROP_OFF_MODE";
                          Navigator.pushNamed(context, SEARCH_PLACES);
                        },
                        child: const Icon(
                          Icons.search,
                          color: AppColors.mainColor,
                        ))
                  ],
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
                      "Journey price", Icons.monetization_on, validatePrice),
                  controller: priceController,
                ),
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
                      "Number of sits", Icons.monetization_on, validatePrice),
                  controller: sitsController,
                ),
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
                  onPress: () async {
                    AlertUtil.showLoadingAlertDialig(
                        context, "Creating journey", false);
                    var uuid = const Uuid().v4();
                    UserModel ownerDetails = ref.read(userProvider);
                    Journey journey = Journey(
                        jourenyId: uuid,
                        origin: originController.text,
                        destination: destinationController.text,
                        startTime: DateUtil.getDateFromString(
                            '$choosenDate $choosenTime') as DateTime,
                        ownerDetails: ownerDetails,
                        journeyPricePerKM: double.parse(priceController.text),
                        jorneyDistance: 0,
                        createdAt: DateTime.now(),
                        jorneyStatus: JOURNEY_STATUS_PENDING,
                        joinedPassengers: [],
                        jorneyType: jorneyType,
                        ownerId: ownerDetails.userId.toString(),
                        numberOfSits: int.parse(sitsController.text ?? '0' ),
                        originDetails: foundPicupPlace!,
                        destinationDetails: foundDropOfPlace!);

                    await JourneyService.createJorney(journey);
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
