import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenzes/models/data_model.dart';
import 'package:expenzes/models/user_model.dart';
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

  //get Total Incomes & Expenses
  Future<Map<String, double>> getTotalValues({
    required String currentUserId,
  }) async {
    try {
      QuerySnapshot snapData = await _firebaseCollection
          .doc(currentUserId)
          .collection("allData")
          .get();

      List<DataModel> dataList = snapData.docs.map((e) {
        return DataModel.fromJson(e.data() as Map<String, dynamic>);
      }).toList();

      double allIncomes = 0;
      double allExpenses = 0;
      Map<String, double> allTotalValues = {};
      for (DataModel i in dataList) {
        if (i.isExpense) {
          allExpenses += i.amount.toDouble();
        } else {
          allIncomes += i.amount.toDouble();
        }
      }
      allTotalValues["TotalIncomes"] = allIncomes;
      allTotalValues["TotalExpenses"] = allExpenses;

      return allTotalValues;
    } catch (error) {
      throw exceptions(error.toString());
    }
  }
}
