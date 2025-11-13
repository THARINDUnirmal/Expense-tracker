import 'package:expenzes/models/data_model.dart';
import 'package:expenzes/services/firestroe_services/firebase_database_services.dart';
import 'package:expenzes/utils/app_colors.dart';
import 'package:expenzes/utils/app_text_styles.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:expenzes/view/screens/main_screen.dart';
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
  //form key
  final _formKey = GlobalKey<FormState>();

  //TextEditing Controller
  final TextEditingController _titleContraller = TextEditingController();
  final TextEditingController _descriptionContraller = TextEditingController();
  final TextEditingController _amountContraller = TextEditingController();

  //Value Notifiers
  final ValueNotifier<DateTime> _dateNotifer = ValueNotifier(DateTime.now());
  final ValueNotifier<TimeOfDay> _timeNotifer = ValueNotifier(TimeOfDay.now());

  @override
  Widget build(BuildContext context) {
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

    Future<void> showtime(BuildContext context) async {
      TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: _timeNotifer.value,
      );

      if (picked != null && picked != _timeNotifer.value) {
        _timeNotifer.value = picked;
      }
    }

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(AppConstants.appPadding),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.17,
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
                        text: widget.isExpense ? "Expences" : "Incomes",
                        style: TextStyle(
                          fontSize: 40,
                          color: widget.isExpense
                              ? Color.fromARGB(255, 237, 89, 81)
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
                  color: AppColors.appCream3Color,
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
                height: MediaQuery.of(context).size.height * 0.92,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isExpense ? "Expenses Details" : "Income Details",
                      style: AppTextStyles.mainTopicTextStyle.copyWith(
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(height: 30),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextForm2(
                            controller: _titleContraller,
                            hintText: "Title",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Enter Title";
                              } else {
                                return null;
                              }
                            },
                          ),
                          CustomTextForm2(
                            controller: _descriptionContraller,
                            hintText: "Description",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Enter Description";
                              } else {
                                return null;
                              }
                            },
                          ),
                          CustomTextForm2(
                            keyboardType: TextInputType.number,
                            controller: _amountContraller,
                            hintText: "Amount",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Enter Amount";
                              } else if (int.parse(value) <= 0) {
                                return "Invalid Input";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Pick Date & Time",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ValueListenableBuilder(
                                valueListenable: _dateNotifer,
                                builder: (context, date, child) => Text(
                                  "Date : ${date.toString().split(" ")[0]}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await showDate(context);
                                },
                                icon: Icon(Icons.date_range_outlined, size: 30),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ValueListenableBuilder(
                                valueListenable: _timeNotifer,
                                builder: (context, time, child) => Text(
                                  "Time : ${time.format(context)}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await showtime(context);
                                },
                                icon: Icon(Icons.alarm_add_outlined, size: 30),
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                          Center(
                            child: GestureDetector(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    DataModel sentData = DataModel(
                                      id: "",
                                      title: _titleContraller.text,
                                      isExpense: widget.isExpense,
                                      description: _descriptionContraller.text,
                                      createdDate: _dateNotifer.value,
                                      createdTime: _timeNotifer.value,
                                      amount: int.parse(_amountContraller.text),
                                    );

                                    await FirebaseDatabaseServices().addData(
                                      data: sentData,
                                    );

                                    _amountContraller.clear();
                                    _titleContraller.clear();
                                    _descriptionContraller.clear();

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MainScreen(),
                                      ),
                                    );
                                  } catch (error) {}
                                }
                              },
                              child: CustomButton(title: "Add"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
