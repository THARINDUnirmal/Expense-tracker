import 'dart:async';
import 'package:expenzes/models/data_model.dart';
import 'package:expenzes/services/auth/firebase_auth_services.dart';
import 'package:expenzes/services/connection/connection_service.dart';
import 'package:expenzes/services/firestroe_services/firebase_database_services.dart';
import 'package:expenzes/utils/app_colors.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:expenzes/utils/messages/app_messages.dart';
import 'package:expenzes/widgets/custom_button.dart';
import 'package:expenzes/widgets/reuseble_widgets/custom_text_form2.dart';
import 'package:flutter/material.dart';

class AddDataScreen extends StatefulWidget {
  final bool isExpense;
  const AddDataScreen({super.key, required this.isExpense});

  @override
  State<AddDataScreen> createState() => _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {
  late StreamSubscription<bool> _subscription;
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    listUpdate();
    _subscription = ConnectionService().connectionStream.listen((status) {
      setState(() {
        isConnected = status;
      });

      // Show snackbar on change
      isConnected
          ? null
          : AppMessages().appAlertMessage(
              "Please check your internet connection",
              context,
            );
    });
  }

  //form key
  final _formKey = GlobalKey<FormState>();
  final _sheetFormKey = GlobalKey<FormState>();

  //controllers
  final TextEditingController _titleContraller = TextEditingController();
  final TextEditingController _descriptionContraller = TextEditingController();
  final TextEditingController _amountContraller = TextEditingController();
  final TextEditingController _categeoryContraller = TextEditingController();

  //dropdown list
  List<String> dropDownDataList = ["Food", "Travel", "Bills"];
  String? selectedCategory;

  Future<void> listUpdate() async {
    List<DataModel> allData = await FirebaseDatabaseServices().getAllData(
      context: context,
      curruntUserId: FirebaseAuthServices().curruntUserData.uid,
    );
    for (DataModel i in allData) {
      if (!dropDownDataList.contains(i.category)) {
        dropDownDataList.add(i.category!);
      }
    }
    setState(() {});
  }

  //Value Notifiers
  final ValueNotifier<DateTime> _dateNotifer = ValueNotifier(DateTime.now());
  final ValueNotifier<TimeOfDay> _timeNotifer = ValueNotifier(TimeOfDay.now());

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Show date picker
    Future<void> showDate(BuildContext conetext) async {
      DateTime? pick = await showDatePicker(
        initialDate: _dateNotifer.value,
        context: context,
        firstDate: DateTime(2020),
        lastDate: DateTime(2050),
      );

      if (pick != null && pick != _dateNotifer.value) {
        _dateNotifer.value = pick;
      }
    }

    //Show time picker
    Future<void> showtime(BuildContext context) async {
      TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: _timeNotifer.value,
      );

      if (picked != null && picked != _timeNotifer.value) {
        _timeNotifer.value = picked;
      }
    }

    //add category bottom sheet
    void categeoryAddSheet() {
      showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        context: context,
        builder: (context) {
          return Container(
            height: 400,
            padding: EdgeInsets.all(AppConstants.appPadding),
            child: Form(
              key: _sheetFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add New\nCategory",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  CustomTextForm2(
                    controller: _categeoryContraller,
                    hintText: "Enter Category Name",
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter category name!";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      if (_sheetFormKey.currentState!.validate()) {
                        setState(() {
                          dropDownDataList.add(
                            _categeoryContraller.text.trim(),
                          );
                        });

                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Category Added")),
                        );
                      }
                    },
                    child: Container(
                      height: 55,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.appBlueColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          "Add",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 1,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB3E5FC), Color(0xFFFFF59D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(AppConstants.appPadding),
                  width: double.infinity,
                  child: RichText(
                    text: TextSpan(
                      text: "Add Your\n",
                      style: TextStyle(
                        fontSize: 40,
                        color: AppColors.appBlackColor,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: widget.isExpense ? "Expenses" : "Incomes",
                          style: TextStyle(
                            fontSize: 40,
                            color: widget.isExpense
                                ? Colors.red
                                : AppColors.appGreenColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.appPadding + 5,
                    vertical: AppConstants.appPadding * 2,
                  ),
                  width: double.infinity,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.isExpense
                              ? "Expenses Details"
                              : "Income Details",
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 30),

                        //TITLE
                        CustomTextForm2(
                          controller: _titleContraller,
                          hintText: "Title",
                          validator: (value) =>
                              value!.isEmpty ? "Please Enter Title" : null,
                        ),

                        //DESCRIPTION
                        CustomTextForm2(
                          controller: _descriptionContraller,
                          hintText: "Description",
                        ),

                        // CATEGORY DROPDOWN
                        DropdownButtonFormField(
                          value: selectedCategory,
                          decoration: InputDecoration(
                            hintText: "Select Category",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          items: [
                            ...dropDownDataList.map(
                              (data) => DropdownMenuItem(
                                value: data,
                                child: Text(data),
                              ),
                            ),
                            DropdownMenuItem(
                              value: "add_new",
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Add New Category",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(Icons.add),
                                ],
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            if (value == "add_new") {
                              categeoryAddSheet();
                            } else {
                              selectedCategory = value;
                            }
                          },
                          validator: (value) {
                            if (value == null) {
                              return "Please select a category";
                            } else if (value == "add_new") {
                              return "Now select the newly added category";
                            } else {
                              return null;
                            }
                          },
                        ),

                        SizedBox(height: 20),

                        // AMOUNT
                        CustomTextForm2(
                          keyboardType: TextInputType.number,
                          controller: _amountContraller,
                          hintText: "Amount",
                          validator: (value) {
                            if (value!.isEmpty) return "Please Enter Amount";
                            final n = int.tryParse(value);
                            if (n == null || n <= 0) return "Invalid Amount";
                            return null;
                          },
                        ),

                        SizedBox(height: 25),

                        Text(
                          "Pick Date & Time",
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 15),

                        // DATE
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ValueListenableBuilder(
                              valueListenable: _dateNotifer,
                              builder: (context, date, child) => Text(
                                "Date : ${date.toString().split(" ")[0]}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => showDate(context),
                              icon: Icon(Icons.date_range_outlined, size: 30),
                            ),
                          ],
                        ),

                        SizedBox(height: 20),

                        // TIME
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ValueListenableBuilder(
                              valueListenable: _timeNotifer,
                              builder: (context, time, child) => Text(
                                "Time : ${time.format(context)}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => showtime(context),
                              icon: Icon(Icons.alarm_add_outlined, size: 30),
                            ),
                          ],
                        ),

                        SizedBox(height: 30),

                        //ADD BUTTON
                        Center(
                          child: GestureDetector(
                            onTap: () async {
                              if (isConnected) {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    DataModel sentData = DataModel(
                                      id: "",
                                      title: _titleContraller.text.trim(),
                                      isExpense: widget.isExpense,
                                      description:
                                          _descriptionContraller.text.isEmpty
                                          ? "No Description!"
                                          : _descriptionContraller.text.trim(),
                                      createdDate: _dateNotifer.value,
                                      createdTime: _timeNotifer.value,
                                      amount: double.parse(
                                        _amountContraller.text.trim(),
                                      ),
                                      category: selectedCategory,
                                    );
                                    Navigator.of(context).pop();

                                    await FirebaseDatabaseServices().addData(
                                      context: context,
                                      userId: FirebaseAuthServices()
                                          .curruntUserData
                                          .uid,
                                      data: sentData,
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "${widget.isExpense ? "Expense" : "Income"} Added",
                                        ),
                                      ),
                                    );

                                    //AppRoutes.route.go("/MainScreen");

                                    _categeoryContraller.clear();
                                    _amountContraller.clear();
                                    _titleContraller.clear();
                                    _descriptionContraller.clear();
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Error: $e")),
                                    );
                                  }
                                }
                              } else {
                                AppMessages().appAlertMessage(
                                  "Please check your internet connection",
                                  context,
                                );
                              }
                            },
                            child: CustomButton(title: "Add"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
