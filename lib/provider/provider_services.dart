import 'package:expenzes/services/local_storage/local_data.dart';
import 'package:flutter/material.dart';

class ProviderServices extends ChangeNotifier {
  String _curruntColor = "1";
  String _userImage = "";

  ProviderServices() {
    getUserImageFromLocal();
    getCurruntColorFromLocal();
  }

  //getter
  String get getCurruntColor => _curruntColor;

  Future<void> setColor(String ColorCode) async {
    _curruntColor = ColorCode;
    await LocalData().saveBackgroundColor(colorName: ColorCode);
    notifyListeners();
  }

  //get and notify currunt color!
  Future<void> getCurruntColorFromLocal() async {
    String color = await LocalData().getBackgroundColor();
    _curruntColor = color;
    notifyListeners();
  }

  //get user image
  String get userImage => _userImage;

  Future<void> getUserImageFromLocal() async {
    String imageData = await LocalData().getImageData();
    _userImage = imageData;
    notifyListeners();
  }

  //set user Image
  Future<void> setUserImage({required String imageUrl}) async {
    await LocalData().setImage(imageUrl: imageUrl);
    await getUserImageFromLocal();
    notifyListeners();
  }

  //delete image
  Future<void> deleteUserImageFromLocal() async {
    await LocalData().deleteUserImage();
    _userImage = "";
    notifyListeners();
  }
}
