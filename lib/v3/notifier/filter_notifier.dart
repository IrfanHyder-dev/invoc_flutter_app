import 'package:flutter/cupertino.dart';

class FilterNotifier extends ChangeNotifier{


  String filterKey = '';

  void setFilterKey(String key){
    filterKey = key;
    notifyListeners();
  }



}