

import 'package:invoc/api/model/NutrientLevelItem.dart';
import 'package:invoc/api/model/NutrientLevels.dart';
import 'package:invoc/api/model/Nutriments.dart';
import 'package:invoc/utils/ean_check_digit.dart';

import '../model/Product.dart';
import '../model/ProductImage.dart';
import '../model/Ingredient.dart';
import 'ImageHelper.dart';
import 'LanguageHelper.dart';



class ProductHelper {
  /// reduce the set of images of the product depending on the given language.
  static void removeImages(Product product, OpenFoodFactsLanguage language) {
    if (product.selectedImages == null) {
      return;
    }

    for (var field in ImageField.values) {
      if (product.selectedImages!
          .any((i) => i.field == field && i.language == language)) {
        product.selectedImages!
            .removeWhere((i) => i.field == field && i.language != language);
      }
    }
  }

  // generate a image url for each product image entry
  static void createImageUrls(Product product) {
    if (product.images == null) {
      return;
    }

    for (ProductImage image in product.images!) {
      image.url = ImageHelper.buildUrl(product.barcode!, image);
    }

    //setting the small image here
    var smallImage = product.images!.firstWhere((image)=> image.field == ImageField.FRONT && image.size == ImageSize.SMALL);
    if(smallImage != null){
      product.imgSmallUrl = smallImage.url;
    }
  }

  /// prepare the ingredients for the given product.
  /// parse the language specific ingredient text into ingredient objects.
  static void parseIngredients(Product product) {
    // override the current list of ingredients
    product.ingredients = <Ingredient>[];

    if (product.ingredientsText != null && product.ingredientsText!.isNotEmpty) {
      // find the names of all ingredients within the given string.
      // An item can contain 0-n spaces or hyphens "-"
      // An element may contain 1-n letters
      // An element may contain numbers if there is a letter directly in front of it. (E150d)
      Iterable<Match> matches = new RegExp(
          r"(([\s-_])*([a-zA-ZäöüÄÖÜßàâæçèéêëîïôœùûüÿÀÂÆÇÈÉÊËÎÏÔŒÙÛÜŸ])+([\s0-9%])*)+([\w])*")
          .allMatches(product.ingredientsText!);

      for (var m in matches) {
        String name = m.group(0)!.trim();

        // avoid empty ingredients
        if (name.isNotEmpty) {
          // remove numbers with percent (e.g. 12%)
          name = name.replaceAll(new RegExp(r"(([0-9])*%)"), "").trim();

          // main ingredients starts with an underscore "_" (e.g. _Weizenmehl_)
          var bold = name.startsWith("_") && name.endsWith("_");
          if (bold) {
            name = name.replaceAll("_", "");
          }

          // avoid duplicates
          if (!product.ingredients!.any((i) => i.text == name)) {
            product.ingredients!.add(new Ingredient(text: name, bold: bold));
          }
        }
      }
    }
  }

  static void parseNutirentLevel(Product product){
    List<NutrientLevelItem> levelItem = <NutrientLevelItem>[];

    Nutriments nutriments = product.nutriments!;

    NutrientLevels nutrientLevels = product.nutrientLevels!;
    Level? fat;
    Level? saturatedFat ;
    Level? sugars ;
    Level? salt ;
    if (nutrientLevels != null) {
      fat = nutrientLevels.levels[NutrientLevels.NUTRIENT_FAT];
      saturatedFat = nutrientLevels.levels[NutrientLevels.NUTRIENT_SATURATED_FAT];
      sugars = nutrientLevels.levels[NutrientLevels.NUTRIENT_SUGARS];
      salt = nutrientLevels.levels[NutrientLevels.NUTRIENT_SALT];
    }

    if (!(fat == null && salt == null && saturatedFat == null && sugars == null)) {


      if (nutriments != null) {
        double? fatNutriment = nutriments.fat;
        if (fat != null && fatNutriment != null) {
          String fatNutrimentLevel = fat.toString();
          levelItem.add(new NutrientLevelItem("Fat",
              fatNutriment.toStringAsFixed(2),
              fatNutrimentLevel,
              colorCode(fat),
              barDivider(fat),levelReading(fat)));
        }

        double? saturatedFatNutriment = nutriments.saturatedFat;
        if (saturatedFat != null && saturatedFatNutriment != null) {
          String saturatedFatLocalize = saturatedFat.toString();
          levelItem.add(new NutrientLevelItem("Sat.Fat", saturatedFatNutriment.toStringAsFixed(2),
              saturatedFatLocalize,
              colorCode(saturatedFat),
              barDivider(saturatedFat),levelReading(saturatedFat)));
        }

        double? sugarsNutriment = nutriments.sugars;
        if (sugars != null && sugarsNutriment != null) {
          String sugarsLocalize = sugars.toString();
          levelItem.add(new NutrientLevelItem("Sugar",
              sugarsNutriment.toStringAsFixed(2),
              sugarsLocalize,
              colorCode(sugars),
              barDivider(sugars),levelReading(sugars)));
        }

        double? saltNutriment = nutriments.salt;
        if (salt != null && saltNutriment != null) {
          String saltLocalize = salt.toString();
          levelItem.add(new NutrientLevelItem("Salt",
              saltNutriment.toStringAsFixed(2),
              saltLocalize,
              colorCode(salt),
              barDivider(salt),levelReading(salt)));
        }
      }

      product.nutrientList = levelItem;
    }
  }

  static double barDivider(Level level){
    double code = 0.0;
    switch(level){
      case Level.LOW:
        code = 3.0;
        break;
      case Level.MODERATE:
        code = 1.5;
        break;
      case Level.HIGH:
        code = 1.2;
        break;
      default:
        code = 1.0;
        break;
    }
    return code;
  }


  static String colorCode(Level level){
    String code = "";
    switch(level){
      case Level.LOW:
        code = "#87A0E5";
        break;
      case Level.MODERATE:
        code = "#F1B440";
        break;
      case Level.HIGH:
        code = "#F56E98";
        break;
      default:
        code = "#F2F3F8";
        break;
    }
    return code;
  }


  static String levelReading(Level level){
    String code = "";
    switch(level){
      case Level.LOW:
        code = "LOW";
        break;
      case Level.MODERATE:
        code = "MEDIUM";
        break;
      case Level.HIGH:
        code = "HIGH";
        break;
      default:
        code = "NORMAL";
        break;
    }
    return code;
  }

  static bool isBarcodeValid(String barcode){
    return  barcode!=null && (ean13.validate(barcode) && (!barcode.substring(0, 3).contains("977") || !barcode.substring(0, 3)
        .contains("978") || !barcode.substring(0, 3).contains("979")));
  }

}


