import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenzes/models/data_model.dart';
import 'package:expenzes/models/user_model.dart';
import 'package:expenzes/services/auth/firebase_auth_services.dart';
import 'package:expenzes/utils/exceptions/app_exceptions.dart';
import 'package:expenzes/utils/messages/app_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      print("get data error");
      throw exceptions(error.toString());
    }
  }

  // get data as stream from firebase
  Stream<List<DataModel>> getAllDataStream({required String curruntUserId}) {
    try {
      return _firebaseCollection
          .doc(curruntUserId)
          .collection("allData")
          .orderBy("createdDate", descending: false)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((e) {
                  return DataModel.fromJson(e.data());
                })
                .toList()
                .reversed
                .toList();
          });
    } catch (error) {
      print("Stream error: $error");
      throw Exception(error.toString());
    }
  }

  //get Total Incomes & Expenses
  Future<Map<String, double>> getTotalValues({
    required String currentUserId,
  }) async {
    try {
      List<DataModel> dataList = await getAllData(curruntUserId: currentUserId);

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

  //get current user details
  Future<UserModel> getCurrentUserData({required String userId}) async {
    try {
      DocumentSnapshot docSnap = await _firebaseCollection.doc(userId).get();

      UserModel userData = UserModel.fromJson(
        docSnap.data() as Map<String, dynamic>,
      );

      return userData;
    } catch (error) {
      throw exceptions(error.toString());
    }
  }

  //delete data form fire base
  Future<void> deleteDataFromeFirebase({
    required String itemId,
    required BuildContext context,
  }) async {
    try {
      await _firebaseCollection
          .doc(FirebaseAuthServices().curruntUserData.uid)
          .collection("allData")
          .doc(itemId)
          .delete();

      AppMessages().showSnackBarMessage(
        context: context,
        message: "Your data has been removed 🗑️",
      );
    } catch (error) {}
  }

  //give data form each categeory
  Future<List<DataModel>> directGetCatgeoryData({
    required String categeoryName,
  }) async {
    try {
      List<DataModel> dataList = await getAllData(
        curruntUserId: FirebaseAuthServices().curruntUserData.uid,
      );

      List<DataModel> categeoryData = [];

      for (DataModel i in dataList) {
        if (i.category == categeoryName) {
          categeoryData.add(i);
        }
      }

      return categeoryData;
    } catch (error) {
      throw exceptions(error.toString());
    }
  }

  //delete data from each categeory
  Future<void> deleteDataUsingCategeory({
    required String categeory,
    required BuildContext context,
  }) async {
    try {
      final userId = FirebaseAuthServices().curruntUserData.uid;

      // get all matching documents
      QuerySnapshot snapshot = await _firebaseCollection
          .doc(userId)
          .collection("allData")
          .where("category", isEqualTo: categeory)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      AppMessages().showSnackBarMessage(
        context: context,
        message: "All your category data has been removed 🗑️",
      );
    } catch (error) {
      print("Delete category error: $error");
    }
  }
}
