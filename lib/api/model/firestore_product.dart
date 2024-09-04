class FirestoreProduct {
  String? calculatedBrand;
  Images? images;
  String? brands;
  String? code;
  List<String>? ingredientsTags;
  int? additivesN;
  List<String>? labelTags;
  List<String>? allergensTags;
  String? productName;
  String? calculatedName;
  Nutriments? nutriments;
  int? novaGroup;
  List<String>? additivesOriginalTags;
  double? b7;
  int? nutriscoreScore;
  String? nutriscoreGrade;
  String? mainCategory;
  String? pnnsGroups1;
  String? pnnsGroups2;
  NutrientLevels? nutrientLevels;
  double? servingQuantity;
  double? productQuantity;
  bool? activeEanNumber;
  bool? b7Calculus;

  FirestoreProduct(
      {
        this.calculatedBrand,
        this.images,
        this.brands,
        this.code,
        this.ingredientsTags,
        this.additivesN,
        this.labelTags,
        this.allergensTags,
        this.productName,
        this.calculatedName,
        this.nutriments,
        this.novaGroup,
        this.additivesOriginalTags,
        this.b7,
        this.nutriscoreScore,
        this.nutriscoreGrade,
        this.mainCategory,
        this.pnnsGroups1,
        this.pnnsGroups2,
        this.nutrientLevels,
        this.servingQuantity,
        this.productQuantity,
        this.activeEanNumber,
        this.b7Calculus,});

  FirestoreProduct.fromJson(dynamic json) {
    calculatedBrand = json['calculated_brand'];
    images = json['images'] != null && json['images'].toString() != '[]'
        ? new Images.fromJson(json['images'])
        : null;
    brands = json['brands'];
    code = json['code'];
    ingredientsTags = json['ingredients_tags'].cast<String>();
    additivesN =
    json['additives_n'] == null || json['additives_n'].toString().isEmpty
        ? null
        : int.parse(json['additives_n'].toString());
    labelTags =
    json['label_tags'] == null || json['label_tags'].toString().isEmpty
        ? null
        : json['label_tags'].cast<String>();
    allergensTags = json['allergens_tags'] == null ||
        json['allergens_tags'].toString().isEmpty
        ? null
        : json['allergens_tags'].cast<String>();
    productName = json['product_name'];
    calculatedName = json['calculated_name'];
    nutriments =
    json['nutriments'] != null && json['nutriments'].toString() != '[]'
        ? new Nutriments.fromJson(json['nutriments'])
        : null;
    novaGroup =
    json['nova_group'] == null || json['nova_group'].toString().isEmpty
        ? null
        : int.parse(json['nova_group'].toString());
    additivesOriginalTags = json['additives_original_tags'] == null ||
        json['additives_original_tags'].toString().isEmpty
        ? null
        : json['additives_original_tags'].cast<String>();
    activeEanNumber = json['active_ean']!=null?json['active_ean']:false;
    b7Calculus = json['b7_calculus_required']!=null?json['b7_calculus_required']:false;
//    if (json['additives_original_tags'] != null) {
//      additivesOriginalTags = new List<Null>();
//      json['additives_original_tags'].forEach((v) {
//        additivesOriginalTags.add(new Null.fromJson(v));
//      });
//    }
    if (json['b7'] != null) {
      try {
        b7 = json['b7'];
      } catch (e) {
        try {
          int value = json['b7'];
          b7 = value.toDouble();
        } catch (e) {
          String value = json['b7'];
          if (value != null && value.isNotEmpty) {
            b7 = double.parse(value);
          }
        }
      }
    }
    //b7 = json['b7'] != null ? double.parse(json['b7']): null;
    nutriscoreScore = json['nutriscore_score'].toString().isEmpty ||
        json['nutriscore_score'] == null
        ? null
        :int.parse(json['nutriscore_score'].toString()) ;
    nutriscoreGrade = json['nutriscore_grade'].toString().isEmpty ||
        json['nutriscore_grade'] == null
        ? null
        : json['nutriscore_grade'];
    mainCategory = json['main_category'];
    pnnsGroups1 = json['pnns_groups_1'];
    pnnsGroups2 = json['pnns_groups_2'];
    nutrientLevels = json['nutrient_levels'] != null &&
        json['nutrient_levels'].toString() != '[]'
        ? new NutrientLevels.fromJson(json['nutrient_levels'])
        : null;

    if (json['product_quantity'] != null) {
      try {
        productQuantity = json['product_quantity'];
      } catch (e) {
        try {
          int value = json['product_quantity'];
          productQuantity = value.toDouble();
        } catch (e) {
          String value = json['product_quantity'];
          if (value != null && value.isNotEmpty) {
            productQuantity = double.parse(value);
          }
        }
      }
    }

    if (json['serving_quantity'] != null) {
      try {
        servingQuantity = json['serving_quantity'];
      } catch (e) {
        try {
          int value = json['serving_quantity'];
          servingQuantity = value.toDouble();
        } catch (e) {
          String value = json['serving_quantity'];
          if (value != null && value.isNotEmpty) {
            servingQuantity = double.parse(value);
          }
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['calculated_brand'] = this.calculatedBrand;
    if (this.images != null) {
      data['images'] = this.images!.toJson();
    }
    data['brands'] = this.brands;
    data['code'] = this.code;
    data['ingredients_tags'] = this.ingredientsTags;
    data['additives_n'] = this.additivesN;
    data['label_tags'] = this.labelTags;
    data['allergens_tags'] = this.allergensTags;
    data['product_name'] = this.productName;
    data['calculated_name'] = this.calculatedName;
    data['active_ean'] = this.activeEanNumber;
    data['b7_calculus_required'] = this.b7Calculus;
    if (this.nutriments != null) {
      data['nutriments'] = this.nutriments!.toJson();
    }
    data['nova_group'] = this.novaGroup;
    data['additives_original_tags'] = this.additivesOriginalTags;
//    if (this.additivesOriginalTags != null) {
//
//          this.additivesOriginalTags.map((v) => v.toJson()).toList();
//    }
    data['b7'] = this.b7;
    data['nutriscore_score'] = this.nutriscoreScore;
    data['nutriscore_grade'] = this.nutriscoreGrade;
    data['main_category'] = this.mainCategory;
    data['pnns_groups_1'] = this.pnnsGroups1;
    data['pnns_groups_2'] = this.pnnsGroups2;
    if (this.nutrientLevels != null) {
      data['nutrient_levels'] = this.nutrientLevels!.toJson();
    }
    data['product_quantity'] = this.productQuantity;
    data['serving_quantity'] = this.servingQuantity;

    return data;
  }
}

class Images {
  String? large;
  String? thumb;

  Images({required this.large, required this.thumb});

  Images.fromJson(Map<String, dynamic> json) {
    large = json['large'];
    thumb = json['thumb'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['large'] = this.large;
    data['thumb'] = this.thumb;
    return data;
  }
}

class Nutriments {
  int? energy100g;
  double? fiber;
  double? salt;
  double? proteins;
  int? energyKcalValue;
  double? fat;
  double? saturatedFat;
  double? sugars;

  Nutriments({
    this.energy100g,
    this.fiber,
    this.salt,
    this.proteins,
    this.energyKcalValue,
    this.fat,
    this.saturatedFat,
    this.sugars,
  });


  Nutriments.fromJson(Map<String, dynamic> json) {
    energy100g = json['energy_100g'];

    try {
      fiber = json['fiber'].toDouble();
    } catch (e) {}

    try {
      salt = json['salt'].toDouble();
    } catch (e) {}

    try {
      proteins = json['proteins'].toDouble();
    } catch (e) {}

    try {
      energyKcalValue =
      json['energy-kcal_value'] == null ? "0" : json['energy-kcal_value'];
    } catch (e) {}

    try {
      fat = json['fat'].toDouble();
    } catch (e) {}
    try {
      saturatedFat = json['saturated-fat'].toDouble();
    } catch (e) {}
    try {
      sugars = json['sugars_100g'].toDouble();
    } catch (e) {}
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['energy_100g'] = this.energy100g;
    data['fiber'] = this.fiber;
    data['salt'] = this.salt;
    data['proteins'] = this.proteins;
    data['energy-kcal_value'] = this.energyKcalValue;
    data['fat'] = this.fat;
    data['saturated-fat'] = this.saturatedFat;
    data['sugars'] = this.sugars;
    return data;
  }
}

class NutrientLevels {
  String? salt;
  String? sugars;
  String? fat;
  String? saturatedFat;

  NutrientLevels({this.salt, this.sugars, this.fat, this.saturatedFat});

  NutrientLevels.fromJson(Map<String, dynamic> json) {
    salt = json['salt'];
    sugars = json['sugars'];
    fat = json['fat'];
    saturatedFat = json['saturated-fat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['salt'] = this.salt;
    data['sugars'] = this.sugars;
    data['fat'] = this.fat;
    data['saturated-fat'] = this.saturatedFat;
    return data;
  }
}
