
import 'package:flutter/cupertino.dart';

class SearchProvider with ChangeNotifier{
  String pharmacySearchText = "";
  String userSearchText = "";
  String noticeSearchText = "";

  String getText(String text){
    if (text == "user") {
      return userSearchText;
    } else if (text == "pharmacy") {
      return pharmacySearchText;
    }else if (text == "notice") {
      return noticeSearchText;
    }
    return "";

  }

  searchUser(String text){
    userSearchText = text;
    notifyListeners();
  }


  searchPharmacy(String text){
    pharmacySearchText = text;
    notifyListeners();
  }


  searchNotice(String text){
    noticeSearchText = text;
    notifyListeners();
  }
}