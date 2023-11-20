import 'package:easylygo_app/models/Journey.dart';

class FilterUtil {
  static List<Journey> getFiltereredJourneys(
      List<Journey> journeysToFilter, String searchQuery) {
    List<Journey> filteredJorneys = journeysToFilter
        .where((journey) =>
            journey.origin.toLowerCase().contains(searchQuery.toLowerCase()) ||
            journey.destination
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
        .toList();

    return filteredJorneys;
  }
}
