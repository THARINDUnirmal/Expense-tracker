import 'package:expenzes/models/data_model.dart';
import 'package:expenzes/services/firestroe_services/firebase_database_services.dart';
import 'package:expenzes/widgets/reuseble_widgets/single_data_card.dart';
import 'package:flutter/material.dart';

class SingleCategeoryScreen extends StatefulWidget {
  final String categeoryName;
  const SingleCategeoryScreen({super.key, required this.categeoryName});

  @override
  State<SingleCategeoryScreen> createState() => _SingleCategeoryScreenState();
}

class _SingleCategeoryScreenState extends State<SingleCategeoryScreen> {
  List<DataModel> allData = [];

  Future<void> getCategeoryData() async {
    List<DataModel> data = await FirebaseDatabaseServices()
        .directGetCatgeoryData(categeoryName: widget.categeoryName);

    setState(() {
      allData = data;
    });
  }

  @override
  void initState() {
    super.initState();
    getCategeoryData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categeoryName)),
      body: ListView.builder(
        itemCount: allData.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          DataModel indexData = allData[index];
          return SingleDataCard(
            title: indexData.title,
            isExpense: indexData.isExpense,
            cardAmount: indexData.amount,
          );
        },
      ),
    );
  }
}
