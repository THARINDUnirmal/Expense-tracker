import 'dart:io';
import 'package:expenzes/utils/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class EdditProfileScreen extends StatefulWidget {
  const EdditProfileScreen({super.key});

  @override
  State<EdditProfileScreen> createState() => _EdditProfileScreenState();
}

class _EdditProfileScreenState extends State<EdditProfileScreen> {
  //TextEditingControllers
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _usePassword = TextEditingController();
  final TextEditingController _userConfirmePssword = TextEditingController();

  late File? userImage;
  bool isLoading = false;

  final ImagePicker pickImager = ImagePicker();

  Future<void> pickImage(ImageSource imagesourse) async {
    try {
      final imageFile = await pickImager.pickImage(source: imagesourse);

      if (imageFile == null) {
        return;
      } else {
        userImage = File(imageFile.path);
      }
    } catch (error) {
      print("Image piker error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppConstants.appPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Edit Profile",
                      style: GoogleFonts.lora(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    isLoading ? CircularProgressIndicator() : SizedBox(),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 1,
                decoration: BoxDecoration(
                  color: Color(0xff73C8D2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Form(
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      GestureDetector(
                        onTap: () async {
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            await pickImage(ImageSource.gallery);
                            Future.delayed(Duration(seconds: 3));
                          } catch (error) {
                            print(error.toString());
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        child: Stack(
                          children: [
                            CircleAvatar(
                              maxRadius: 50,
                              backgroundImage: NetworkImage(
                                "https://cdn.pixabay.com/photo/2023/02/18/11/00/icon-7797704_1280.png",
                              ),
                            ),
                            Positioned(
                              bottom: 1,
                              right: 0,
                              child: GestureDetector(
                                onTap: () async {
                                  try {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    await pickImage(ImageSource.camera);
                                    Future.delayed(Duration(seconds: 3));
                                  } catch (error) {
                                    print(error.toString());
                                  } finally {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                },
                                child: Icon(
                                  Icons.add_a_photo,
                                  size: 30,
                                  color: Color.fromARGB(255, 111, 109, 109),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // CustomTextField(
                      //   controller: controller,
                      //   labaleTexts: labaleTexts,
                      //   icon: icon,
                      //   issecurText: issecurText,
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
