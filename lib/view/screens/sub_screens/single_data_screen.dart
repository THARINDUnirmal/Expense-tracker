import 'package:expenzes/models/data_model.dart';
import 'package:expenzes/routes/app_routes.dart';
import 'package:expenzes/services/firestroe_services/firebase_database_services.dart';
import 'package:expenzes/utils/app_colors.dart';
import 'package:expenzes/utils/app_text_styles.dart';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:expenzes/view/screens/main_screen.dart';
import 'package:expenzes/view/screens/main_screens/add_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SingleDataScreen extends StatelessWidget {
  final DataModel singleData;
  const SingleDataScreen({super.key, required this.singleData});

  @override
  Widget build(BuildContext context) {
    // void deletComfirmation() {
    //   showModalBottomSheet(
    //     context: context,
    //     builder: (context) {
    //       return Container(
    //         height: 400,
    //         width: double.infinity,
    //         padding: EdgeInsets.only(
    //           bottom: AppConstants.appPadding,
    //           left: AppConstants.appPadding,
    //           right: AppConstants.appPadding,
    //           top: 5,
    //         ),
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.only(
    //             topLeft: Radius.circular(30),
    //             topRight: Radius.circular(30),
    //           ),
    //           color: Color.fromARGB(255, 255, 255, 255),
    //         ),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             Center(
    //               child: Container(
    //                 width: 80,
    //                 height: 5,
    //                 decoration: BoxDecoration(
    //                   color: AppColors.appSheetBlueColor,
    //                   borderRadius: BorderRadius.circular(100),
    //                 ),
    //               ),
    //             ),
    //             Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 Lottie.asset(
    //                   repeat: false,
    //                   "assets/lottei/Alert 1.json",
    //                   width: 100,
    //                 ),
    //                 SizedBox(height: 10),
    //                 Text(
    //                   textAlign: TextAlign.center,
    //                   "Delete",
    //                   style: TextStyle(
    //                     fontSize: 30,
    //                     fontWeight: FontWeight.bold,
    //                   ),
    //                 ),
    //                 SizedBox(height: 5),
    //                 Text(
    //                   textAlign: TextAlign.center,
    //                   "Are you sure you want to\nDelete?",
    //                   style: AppTextStyles.mainTopicTextStyle.copyWith(
    //                     fontWeight: FontWeight.normal,
    //                   ),
    //                 ),
    //                 SizedBox(height: 30),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                   children: [
    //                     GestureDetector(
    //                       onTap: () async {
    //                         // await FirebaseAuthServices().logOutAccount();
    //                         Navigator.pop(context);
    //                       },
    //                       child: Container(
    //                         width: 150,
    //                         height: 55,
    //                         decoration: BoxDecoration(
    //                           borderRadius: BorderRadius.circular(20),
    //                           color: AppColors.appSheetBlueColor,
    //                         ),
    //                         child: Center(
    //                           child: Text(
    //                             "Yes",
    //                             style: AppTextStyles.mainTopicTextStyle
    //                                 .copyWith(color: AppColors.appWhiteColor),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                     SizedBox(width: 10),
    //                     GestureDetector(
    //                       onTap: () {
    //                         Navigator.pop(context);
    //                       },
    //                       child: Container(
    //                         width: 150,
    //                         height: 55,
    //                         decoration: BoxDecoration(
    //                           border: Border.all(
    //                             color: AppColors.appSheetRedColor,
    //                             width: 2,
    //                           ),
    //                           borderRadius: BorderRadius.circular(20),
    //                           color: Colors.white,
    //                         ),
    //                         child: Center(
    //                           child: Text(
    //                             "No",
    //                             style: AppTextStyles.mainTopicTextStyle
    //                                 .copyWith(
    //                                   color: AppColors.appSheetRedColor,
    //                                 ),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //                 SizedBox(height: 40),
    //               ],
    //             ),
    //           ],
    //         ),
    //       );
    //     },
    //   );
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Single Data Screen",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.appPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              maxLines: 2,
              "Title : ${singleData.title}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              maxLines: 2,
              "Time : ${singleData.createdTime.format(context)}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              maxLines: 2,
              "Date : ${singleData.createdDate}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              "Amount : Rs.${singleData.amount}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            SizedBox(height: 20),
            Text(
              "Description : ${singleData.description}",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
            ),
            SizedBox(height: 30),
            Divider(),
            SizedBox(height: 10),
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.all(10),
                backgroundColor: const Color.fromARGB(255, 255, 116, 116),
              ),
              onPressed: () async {
                await FirebaseDatabaseServices().deleteDataFromeFirebase(
                  itemId: singleData.id,
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );
              },
              child: Text(
                "Delete Data",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
