import 'dart:io';

import 'package:easylygo_app/utils/firestore_util.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImageUtil {

  static Future<XFile?> pickGalleryImage() async{
      final ImagePicker _picker = ImagePicker();
    return _picker.pickImage(source: ImageSource.gallery);
  }

    static Future<XFile?> pickCameramage() async{
      final ImagePicker _picker = ImagePicker();
    return _picker.pickImage(source: ImageSource.camera);
  }

 static Future<String> uploadImage(String path, XFile xFile ) async {

      Reference firebaseStorageRef =FirebaseUtil.storageReference('userimages/${DateTime.now().microsecondsSinceEpoch}');
      UploadTask uploadTask = firebaseStorageRef.putFile(File(xFile.path));
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
}

}