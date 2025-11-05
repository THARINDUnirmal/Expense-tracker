import 'package:expenzes/utils/app_colors.dart';
import 'package:expenzes/utils/app_text_styles.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:expenzes/widgets/custom_button.dart';
import 'package:expenzes/widgets/reuseble_widgets/custom_text_form2.dart';
import 'package:flutter/material.dart';

class AddDataScreen extends StatelessWidget {
  final bool isExpense;
  AddDataScreen({super.key, required this.isExpense}) {
    _dateNotifer.value = DateTime.now();
    _timeNotifer.value = TimeOfDay.now();
  }

  final TextEditingController _titleContraller = TextEditingController();
  final TextEditingController _descriptionContraller = TextEditingController();
  final TextEditingController _dateContraller = TextEditingController();
  final TextEditingController _amountContraller = TextEditingController();

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
                height: MediaQuery.of(context).size.height * 0.18,
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
                        text: isExpense ? "Expences" : "Incomes",
                        style: TextStyle(
                          fontSize: 40,
                          color: isExpense
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
                height: MediaQuery.of(context).size.height * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isExpense ? "Expenses Details" : "Income Details",
                      style: AppTextStyles.mainTopicTextStyle.copyWith(
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(height: 30),
                    Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextForm2(
                            controller: _titleContraller,
                            hintText: "Title",
                          ),
                          CustomTextForm2(
                            controller: _descriptionContraller,
                            hintText: "Description",
                          ),
                          CustomTextForm2(
                            controller: _amountContraller,
                            hintText: "Amount",
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
                          Center(child: CustomButton(title: "Add")),
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
