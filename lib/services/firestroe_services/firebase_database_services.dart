import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenzes/models/data_model.dart';
import 'package:expenzes/models/user_model.dart';
import 'package:expenzes/services/auth/firebase_auth_services.dart';
import 'package:expenzes/utils/exceptions/app_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseDatabaseServices {
  final CollectionReference _firebaseCollection = FirebaseFirestore.instance
      .collection("users");

  //add user
  Future<void> addUser(UserModel userData) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print("No user logged in");
        return;
      }

      await _firebaseCollection.doc(user.uid).set({
        "userId": user.uid,
        "name": userData.name,
        "email": userData.email,
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      });

      print("User saved successfully!");
    } catch (error) {
      print("USER SAVE ERROR: $error");
    }
  }

  //Save data for each user
  Future<void> addData({
    required DataModel data,
    required String userId,
  }) async {
    try {
      final Map<String, dynamic> firebaseData = data.toJson();
      final DocumentReference docRef = await _firebaseCollection
          .doc(userId)
          .collection("allData")
          .add(firebaseData);

      await docRef.update({"id": docRef.id});
    } on FirebaseAuthException catch (error) {
      print(error.toString());
    } catch (e) {}
  }

  //get data from firebase
  Future<List<DataModel>> getAllData({required String curruntUserId}) async {
    try {
      print(FirebaseAuthServices().curruntUserData.uid);
      QuerySnapshot snapshotData = await _firebaseCollection
          .doc(curruntUserId)
          .collection("allData")
          .get();

      List<DataModel> listData = snapshotData.docs.map((e) {
        return DataModel.fromJson(e.data() as Map<String, dynamic>);
      }).toList();

      return listData;
    } catch (error) {
      print("get data error=============");
      throw exceptions(error.toString());
    }
  }
}
