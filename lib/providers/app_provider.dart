
import 'package:easylygo_app/models/PlaceModel.dart';
import 'package:easylygo_app/models/UserModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

final userProvider = Provider<UserModel>((_) => UserModel());
final totalJourenys=StateProvider<int>((ref) => 0);
final placeModelProvider=StateProvider<PlaceModel>((ref) => PlaceModel());
final dropOffPlaceModelProvider=StateProvider<PlaceModel>((ref) => PlaceModel());