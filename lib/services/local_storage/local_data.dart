import 'package:expenzes/utils/exceptions/app_exceptions.dart';
import 'package:expenzes/utils/messages/app_messages.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalData {
  //set value
  Future<void> setImage({
    required String imageUrl,
    required BuildContext context,
  }) async {
    try {
      SharedPreferences _pref = await SharedPreferences.getInstance();

      await _pref.setString("Image", imageUrl);
      AppMessages().showSnackBarMessage(
        context: context,
        message: "Your image has been updated!",
      );
    } catch (error) {
      print("Image store error=============");
    }
  }

  //get user Image Data
  Future<String> getImageData() async {
    try {
      SharedPreferences _pref = await SharedPreferences.getInstance();

      String? imageUrl = _pref.getString("Image") ?? "";
      return imageUrl;
    } catch (error) {
      print("Get image data error==============");
      throw exceptions(error.toString());
    }
  }

  //delete image
  Future<void> deleteUserImage({required BuildContext context}) async {
    try {
      SharedPreferences _pref = await SharedPreferences.getInstance();
      await _pref.remove("Image");

      AppMessages().showSnackBarMessage(
        context: context,
        message: "Image deleted successfully!",
      );
    } catch (error) {}
  }
}
