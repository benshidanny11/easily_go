import 'package:easylygo_app/common/colors.dart';
import 'package:easylygo_app/common/input_decorations.dart';
import 'package:easylygo_app/common/text_styles.dart';
import 'package:easylygo_app/common/widgets.dart';
import 'package:easylygo_app/items/journey_customer_item.dart';
import 'package:easylygo_app/models/Journey.dart';
import 'package:easylygo_app/services/journey_service.dart';
import 'package:easylygo_app/utils/filter_util.dart';
import 'package:flutter/material.dart';

class CustomerPostedJourneys extends StatefulWidget {
  const CustomerPostedJourneys({super.key});

  @override
  State<CustomerPostedJourneys> createState() =>
      _CustomerPostedJourneystState();
}

class _CustomerPostedJourneystState extends State<CustomerPostedJourneys> {
  int _journeysCount = 0;
  int _tripRequestCount = 0;
  Stream? joureysStream;
  List<Journey> journeItems = [];
  List<Journey> filteredJourneyItems = [];
  bool isSearching = false;
  @override
  void initState() {
    super.initState();
    joureysStream = JourneyService.getAvailableJourneys();
  }

  final queryController = TextEditingController();

  _filterJourneys(String value) {
    print(joureysStream);
    setState(() {
      filteredJourneyItems =
          FilterUtil.getFiltereredJourneys(journeItems, value);
      isSearching = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Easily Go'),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Posted journeys",
                        style: textStyleTitle(17),
                        textAlign: TextAlign.start,
                      ),
                      isSearching
                          ? Container(
                            width: screenWidth * .95,
                            padding: const EdgeInsets.all(10),
                            child: CommonWidgets.journeySeachingState(onTap: () {
                                setState(() {
                                  joureysStream=JourneyService.getAvailableJourneys();
                                  isSearching = false;
                                });
                              }),
                          )
                          : Card(
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: screenWidth * .845,
                                      child: TextField(
                                        controller: queryController,
                                        decoration: InputDecorations
                                            .searchInputDecoration(
                                                'Search journeys'),
                                        // onChanged: (value) {
                                        //  _filterJourneys(value);
                                        // },
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(right:10),
                                    child: GestureDetector(
                                        onTap: () {
                                          if (queryController.text.isNotEmpty) {
                                            _filterJourneys(queryController.text);
                                          }
                                          queryController.text='';
                                        },
                                        child: const Icon(
                                          Icons.search,
                                          color: AppColors.mainColor,
                                        )),
                                  )
                                ],
                              ),
                            ),
                    ],
                  ),
                ],
              ),
              CommonWidgets.customDivider(),
              const SizedBox(
                height: 10,
              ),
              isSearching
                  ? SizedBox(
                      height: 90.0 * filteredJourneyItems.length,
                      child: ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return JourneyCustomerItem(
                              journey: filteredJourneyItems[index]);
                        },
                        itemCount: filteredJourneyItems.length,
                      ),
                    )
                  : StreamBuilder(
                      stream: joureysStream,
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator()));
                        }
                        if (snapshot.hasError) {
                          print(
                              "**********&&&&&&Error in get trip requests --======${snapshot.error} ");
                          return const Center(
                            child: Text("An error has occured"),
                          );
                        }
                        if (snapshot.hasData) {
                          journeItems = snapshot.data as List<Journey>;
                          _journeysCount = journeItems.length;
                          return SizedBox(
                            height: 90.0 * journeItems.length,
                            child: ListView.builder(
                              itemBuilder: (BuildContext context, int index) {
                                return JourneyCustomerItem(
                                    journey: journeItems[index]);
                              },
                              itemCount: journeItems.length,
                            ),
                          );
                        } else {
                          return const Center(
                            child: Text("An error has occured"),
                          );
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
    ));
  }
}
