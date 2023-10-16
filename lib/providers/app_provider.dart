
import 'package:easylygo_app/models/UserModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = Provider<UserModel>((_) => UserModel());