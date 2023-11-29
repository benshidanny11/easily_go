import 'package:easylygo_app/models/UserModel.dart';
import 'package:easylygo_app/providers/app_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserUtil{

  static void getUserProvier(UserModel user, WidgetRef ref){
    ref.read(userProvider).email = user.email;
            ref.read(userProvider).fullName = user.fullName;
            ref.read(userProvider).phoneNumber = user.phoneNumber;
            ref.read(userProvider).userId = user.userId;
            ref.read(userProvider).homeAddress = user.homeAddress;
            ref.read(userProvider).regDate=user.regDate;
            ref.read(userProvider).userRole=user.userRole;
            ref.read(userProvider).imageUrl=user.imageUrl;
            ref.read(userProvider).status=user.status;
            ref.read(userProvider).location=user.location;
            ref.read(userProvider).docId=user.docId;
            ref.read(userProvider).deviceToken=user.deviceToken;
  }
}