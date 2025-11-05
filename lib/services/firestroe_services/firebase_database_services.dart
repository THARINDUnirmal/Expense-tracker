import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenzes/models/data_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseDatabaseServices {
  final CollectionReference _firebaseCollection = FirebaseFirestore.instance
      .collection("Data");

  Future<void> addData({required DataModel data}) async {
    try {
      await _firebaseCollection.add(data);
    } on FirebaseAuthException catch (error) {
      print(error.toString());
    } catch (e) {}
  }
}
