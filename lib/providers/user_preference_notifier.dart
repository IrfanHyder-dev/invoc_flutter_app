import 'package:flutter/cupertino.dart';
import 'package:invoc/database/UserDatabase.dart';
import 'package:invoc/models/user_preferences.dart';

class UserPreferencesModel extends ChangeNotifier {
  UserPreferencesModel() {
    userDatabase = UserDatabase();
    _loadData();
  }

  Future<bool> _loadData() async {
    // try {
      userPreferences = await userDatabase!.getUserPreferences();
      dataLoaded = true;
      notifyListeners();
      return true;
    // } catch (e) {
    //   print('An error occurred while loading user preferences : $e');
    //   dataLoaded = false;
    //   return false;
    // }
  }

  UserDatabase? userDatabase;
  UserPreferences? userPreferences;
  bool dataLoaded = false;

  bool getVariable(UserPreferencesVariable variable) {
    return userPreferences!.getVariable(variable);
  }

  void setVariable(UserPreferencesVariable variable, bool value) {
    userPreferences!.setVariable(variable, value);
    notifyListeners();
    saveUserPreferences();
  }

  void saveUserPreferences() {
    userDatabase!.saveUserPreferences(userPreferences!);
  }
}
