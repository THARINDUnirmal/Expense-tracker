import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DataModel {
  final String id;
  final String title;
  final bool isExpense;
  final String description;
  final DateTime createdDate;
  final TimeOfDay createdTime;
  final num amount;

  DataModel({
    required this.createdTime,
    required this.id,
    required this.title,
    required this.isExpense,
    required this.description,
    required this.createdDate,
    required this.amount,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      id: json["Id"] ?? "",
      title: json["title"] ?? "",
      isExpense: json["isExpense"] ?? "",
      description: json["description"] ?? "",
      createdDate: (json["createdDate"] as Timestamp).toDate(),
      createdTime: (json["createdTime"] as TimeOfDay),
      amount: json["amount"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Id": id,
      "title": title,
      "isExpense": isExpense,
      "description": description,
      "createdDate": createdDate,
      "amount": amount,
    };
  }
}
