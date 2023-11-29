
class PlaceModel {
  String? placeId;
  String? placeDescription;

  PlaceModel(
      { this.placeId,
       this.placeDescription});

  Map<String, dynamic> toJson() {
    return {
      "placeId": placeId,
      "placeDescription": placeDescription,
    };
  }

  factory PlaceModel.fromJson(dynamic json) {
    return PlaceModel(
        placeId: json['placeId'],
        placeDescription: json['placeDescription']);
  }
}
