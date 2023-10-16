import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';


class FirebaseUtil {

   static Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }
  static CollectionReference collectionReferene(String path)  {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return firestore.collection(path);
   
  }

  static Reference storageReference(String path)  {
     return  FirebaseStorage.instance.ref().child(path);
  }
}
