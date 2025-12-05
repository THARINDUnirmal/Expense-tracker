import 'package:expenzes/utils/exceptions/app_exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalData {
  //set value
  Future<void> setImage({required String imageUrl}) async {
    try {
      SharedPreferences _pref = await SharedPreferences.getInstance();

      await _pref.setString("Image", imageUrl);
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
  Future<void> deleteUserImage() async {
    try {
      SharedPreferences _pref = await SharedPreferences.getInstance();
      await _pref.remove("Image");
    } catch (error) {}
  }

  //save color
  Future<void> saveBackgroundColor({required String colorName}) async {
    try {
      SharedPreferences _prif = await SharedPreferences.getInstance();
      _prif.setString("Color", colorName);
    } catch (error) {}
  }

  //get color
  Future<String> getBackgroundColor() async {
    try {
      SharedPreferences _prif = await SharedPreferences.getInstance();
      String colorName = _prif.getString("Color") ?? "";
      return colorName;
    } catch (error) {
      throw exceptions(error.toString());
    }
  }
}
