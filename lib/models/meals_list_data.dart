import 'package:get/get.dart';
import 'package:invoc/main.dart';
import 'package:invoc/src/language/language_keys.dart';
import 'package:invoc/v3/auth/constants/enums.dart';


class MealsListData {
  MealsListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.startColor = '',
    this.endColor = '',
    this.meals,
    this.kacl = 0,
    this.categoryString = '',
  });

  String imagePath;
  String titleTxt;
  String startColor;
  String endColor;
  List<String>? meals;
  int kacl;
  String categoryString;

  static List<MealsListData> tabIconsList = <MealsListData>[
    MealsListData(
        imagePath: 'assets/fitness_app/breakfast.png',
        titleTxt: 'Breakfast',
        kacl: 525,
        meals: <String>['Bread,', 'Peanut butter,', 'Apple'],
        startColor: '#FA7D82',
        endColor: '#FFB295',
        categoryString: 'fromage'),
    MealsListData(
        imagePath: 'assets/fitness_app/lunch.png',
        titleTxt: 'Juices     ',
        kacl: 602,
        meals: <String>['Salmon,', 'Mixed veggies,', 'Avocado'],
        startColor: '#738AE6',
        endColor: '#5C5EDD',
        categoryString: 'Lait'),
    MealsListData(
        imagePath: 'assets/fitness_app/snack.png',
        titleTxt: 'Snack     ',
        kacl: 0,
        meals: <String>['Recommend:', '800 kcal'],
        startColor: '#FE95B6',
        endColor: '#FF5287',
        categoryString: 'Fruits'),
    MealsListData(
        imagePath: 'assets/fitness_app/dinner.png',
        titleTxt: 'Meat     ',
        kacl: 0,
        meals: <String>['Recommend:', '703 kcal'],
        startColor: '#6F72CA',
        endColor: '#1E1466',
        categoryString: 'Boucherie'),
    MealsListData(
        imagePath: 'assets/images/cold_drinks.png',
        titleTxt: 'Drinks     ',
        kacl: 0,
        meals: <String>['Recommend:', '703 kcal'],
        startColor: '#738AE6',
        endColor: '#5C5EDD',
        categoryString: 'Boissons'),
    MealsListData(
        imagePath: 'assets/images/everything_cooked.png',
        titleTxt: 'Grocery',
        kacl: 0,
        meals: <String>['Recommend:', '703 kcal'],
        startColor: '#FA7D82',
        endColor: '#FFB295',
        categoryString: 'Entretien')
  ];
}

class TagsData {
  String? imagePath;
  String? titleTxt;

  TagsData({this.imagePath, this.titleTxt});

  static List<TagsData> getTagsList() {
    if (GlobalVariables.userRole == UserRole.user) {
      List<TagsData> tagsList = [
        TagsData(imagePath: 'assets/images/location.svg', titleTxt: OSAKey.tr),
        TagsData(imagePath: 'assets/images/bar_code.svg', titleTxt: reportKey.tr),
      ];
      return tagsList;
    } else {
      List<TagsData> tagsList = [
        TagsData(imagePath: 'assets/images/bar_code.svg', titleTxt: reStockKey.tr),
      ];
      return tagsList;
    }
  }
}
