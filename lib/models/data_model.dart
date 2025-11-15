import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DataModel {
  final String id;
  final String title;
  final bool isExpense;
  final String description;
  final DateTime createdDate;
  final TimeOfDay createdTime;
  final int amount;

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
    // convert time string to TimeOfDay
    String timeString = json["createdTime"] ?? "0:0";
    List<String> parts = timeString.split(":");

    return DataModel(
      id: json["id"] ?? "",
      title: json["title"] ?? "",
      isExpense: json["isExpense"] ?? false,
      description: json["description"] ?? "",
      createdDate: (json["createdDate"] as Timestamp).toDate(),
      createdTime: TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      ),
      amount: json["amount"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "isExpense": isExpense,
      "description": description,
      "createdDate": createdDate,
      "createdTime": "${createdTime.hour}:${createdTime.minute}",
      "amount": amount,
    };
  }
}
