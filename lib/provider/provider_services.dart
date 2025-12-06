import 'package:expenzes/services/local_storage/local_data.dart';
import 'package:flutter/material.dart';

class ProviderServices extends ChangeNotifier {
  String _userImage = "";

  ProviderServices() {
    getUserImageFromLocal();
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
