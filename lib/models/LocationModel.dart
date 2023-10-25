class LocationModel{

 double? latitude;
 double? longitude;

 LocationModel({this.latitude, this.longitude});

   Map<String, dynamic> toJson() {
    return {
      "latitude": latitude,
      "longitude": longitude
    };
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
        latitude: json['latitude'],
        longitude: json['longitude']);
  }

}