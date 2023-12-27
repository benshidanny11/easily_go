import 'dart:convert';
import 'package:easylygo_app/common/colors.dart';
import 'package:easylygo_app/common/input_decorations.dart';
import 'package:easylygo_app/config/config.dart';
import 'package:easylygo_app/models/PlaceModel.dart';
import 'package:easylygo_app/providers/app_provider.dart';
import 'package:easylygo_app/strings/extracted.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class SearchPlases extends ConsumerStatefulWidget {
  const SearchPlases({super.key});

  @override
  ConsumerState<SearchPlases> createState() => _SearchPlasesState();
}

class _SearchPlasesState extends ConsumerState<SearchPlases> {
  List<PlaceModel> places = [];
  final queryController = TextEditingController();

  Future<void> _findPlaces(String query) async {
    places = [];
    final placeResponse = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&types=geocode&key=$GOOGLE_MAP_API_KEY'));

    Map<String, dynamic> placeData = jsonDecode(placeResponse.body);
    placeData['predictions'].forEach((place) => places.add(PlaceModel(
        placeId: place['place_id'], placeDescription: place['description'])));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: Row(
                  children: [
                    SizedBox(
                        width: screenWidth * .85,
                        child: TextField(
                          controller: queryController,
                          onChanged: (value) async {
                            await _findPlaces(value);
                          },
                          decoration:  InputDecorations.searchInputDecoration('Type place or street number'),
                        )),
                   const Icon(Icons.search,color: AppColors.mainColor,)
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              places.isEmpty
                  ? const Center(
                      child: Text('Please type to search places'),
                    )
                  : SizedBox(
                      height: 35.0 * places.length,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {
                                if (FIND_PLACE_PLACE_MODE == 'PICK_UP_MODE') {
                                  ref.read(placeModelProvider).placeId =
                                      places[index].placeId;
                                  ref.read(placeModelProvider).placeDescription =
                                      places[index].placeDescription;
                                } else {
                                  ref.read(dropOffPlaceModelProvider).placeId =
                                      places[index].placeId;
                                  ref
                                          .read(dropOffPlaceModelProvider)
                                          .placeDescription =
                                      places[index].placeDescription;
                                }
                  
                                Navigator.of(context).pop();
                              },
                              child: ListTile(
                                leading: const Icon(Icons.location_on),
                                title: Text(
                                    places[index].placeDescription.toString()),
                              ));
                        },
                        itemCount: places.length,
                      ),
                    )
            ],
          ),
        ),
      ),
    ));
  }
}
