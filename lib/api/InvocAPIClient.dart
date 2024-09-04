import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart';
import 'model/Insight.dart';
import 'model/SpellingCorrections.dart';
import 'utils/LanguageHelper.dart';
import 'utils/ProductQueryConfigurations.dart';
import 'utils/ProductSearchQueryConfiguration.dart';
import 'model/RobotoffQuestion.dart';
import 'model/SendImage.dart';
import 'model/Product.dart';
import 'model/ProductResult.dart';
import 'model/SearchResult.dart';
import 'model/Status.dart';
import 'model/User.dart';
import 'utils/HttpHelper.dart';
import 'utils/ProductHelper.dart';
export 'interface/Parameter.dart';
export 'model/Additives.dart';
export 'model/Ingredient.dart';
export 'model/Insight.dart';
export 'model/Product.dart';
export 'model/ProductImage.dart';
export 'model/ProductResult.dart';
export 'model/RobotoffQuestion.dart';
export 'model/SearchResult.dart';
export 'model/SendImage.dart';
export 'model/SpellingCorrections.dart';
export 'model/Status.dart';
export 'model/TagI18N.dart';
export 'model/User.dart';
export 'model/parameter/OutputFormat.dart';
export 'utils/HttpHelper.dart';
export 'utils/ImageHelper.dart';
export 'utils/JsonHelper.dart';
export 'utils/ProductHelper.dart';

/// Client calls of the Open Food Facts API
class InvocAPIClient {
  static const String URI_SCHEME = "https";
  static const String URI_HOST = "invoc.me:5000";

  static const String URI_HOST_ROBOTOFF = "robotoff.openfoodfacts.org";

  /// Add the given product to the database.
  /// Returns a Status object as result.
  static Future<Status> saveProduct(User user, Product product) async {
    var parameterMap = new Map<String, String>();
    parameterMap.addAll(user.toData());
    parameterMap.addAll(product.toData());

    var productUri =
        Uri(scheme: URI_SCHEME, host: URI_HOST, path: '/cgi/product_jqm2.pl');

    Response response =
        await HttpHelper().doPostRequest(productUri, parameterMap, user);
    print(response);
    var status = Status.fromJson(json.decode(response.body));
    return status;
  }

  /// Send one image to the server.
  /// The image will be added to the product specified in the SendImage
  /// Returns a Status object as result.
  static Future<Status> addProductImage(User user, SendImage image) async {
    var dataMap = new Map<String, String>();
    var fileMap = new Map<String, Uri>();

    dataMap.addAll(user.toData());
    dataMap.addAll(image.toData());
    fileMap.putIfAbsent(image.getImageDataKey()!, () => image.imageUrl!);

    var imageUri = Uri(
        scheme: URI_SCHEME,
        host: URI_HOST,
        path: '/cgi/product_image_upload.pl');

    return await HttpHelper()
        .doMultipartRequest(imageUri, dataMap, fileMap, user);
  }

  /// Returns the product for the given barcode.
  /// The ProductResult does not contain a product, if the product is not available.
  /// No parsing of ingredients.
  /// No adjustment by language.
  static Future<ProductResult> getProductRaw(
      String barcode, OpenFoodFactsLanguage language,
      {required User user}) async {
    if (barcode == null || barcode.isEmpty) {
      return new ProductResult();
    }

    var productUri = Uri(
        scheme: URI_SCHEME,
        host: URI_HOST,
        path: 'api/v0/product/' + barcode + '.json',
        queryParameters: {"lc": language.code});

    Response response = await HttpHelper().doGetRequest(productUri, user: user);
    var result = ProductResult.fromJson(json.decode(response.body));
    return result;
  }

  /// Returns the product for the given barcode.
  /// The ProductResult does not contain a product, if the product is not available.
  /// ingredients, images and product name will be prepared for the given language.
  static Future<Product> getProduct(ProductQueryConfiguration config) async {
    if (config.barcode == null || config.barcode!.isEmpty) {
      return new Product();
    }

//    var productUri = Uri(
//        scheme: URI_SCHEME,
//        host: URI_HOST,
//        path: 'product/${config.barcode}',
//        queryParameters: config.getParametersMap());
    var uri = Uri.https(URI_HOST, 'productfull/${config.barcode}');

    //print(uri.toString());

    Response response = await HttpHelper().doGetNormalRequest(uri);
    Product result = Product.fromJson(json.decode(response.body));

    if (result != null) {
      ProductHelper.parseIngredients(result);
      ProductHelper.removeImages(result, config.language!);
      ProductHelper.createImageUrls(result);
      ProductHelper.parseNutirentLevel(result);
    }

    return result;
  }

  static Map<String, String> getShortParametersMap() {
    Map<String, String> result = Map<String, String>();
    result.putIfAbsent(
        'fields',
        () =>
            'images,nutriscore_data,selected_images,image_small_url,product_name,brands,quantity,code,nutrition_grade_fr,product_name_fr,environment_impact_level_tags');
    return result;
  }

  static Map<String, String> getWeeklyBasketParameters(String basketId) {
    Map<String, String> result = Map<String, String>();
    result.putIfAbsent('week', () => basketId);
    result.putIfAbsent(
        'fields',
        () =>
            'images,nutriscore_data,selected_images,image_small_url,product_name,brands,quantity,code,nutrition_grade_fr,product_name_fr');
    return result;
  }

  static Future<List<Product>> getBasketProducts(String basketId) async {
    var uri = Uri.https(
        URI_HOST, 'ProductsWeeklyCart', getWeeklyBasketParameters(basketId));

    print(uri.toString());

    Response response = await HttpHelper().doGetNormalRequest(uri);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      List<Product> fromJson = jsonResponse
          .map((productObject) => Product.fromJson(productObject))
          .toList();
      for (Product product in fromJson) {
        ProductHelper.createImageUrls(product);
      }
      return fromJson;
      //return jsonResponse.map((productObject) => Product.fromJson(productObject)).toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  static Future<List<Product>> getAlternativeProducts(
      String productCode) async {
    print("Running");
    if (productCode == null || productCode.isEmpty) {
      return [];
    }

//    var productUri = Uri(
//        scheme: URI_SCHEME,
//        host: URI_HOST,
//        path: 'product/${config.barcode}',
//        queryParameters: config.getParametersMap());
    var uri = Uri.https(
        URI_HOST, 'product/recommend/${productCode}', getShortParametersMap());

    print(uri.toString());

    Response response = await HttpHelper().doGetNormalRequest(uri);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      List<Product> fromJson = jsonResponse
          .map((productObject) => Product.fromJson(productObject))
          .toList();
      for (Product product in fromJson) {
        ProductHelper.createImageUrls(product);
      }
      return fromJson;
      //return jsonResponse.map((productObject) => Product.fromJson(productObject)).toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  static Future<SearchResult> getSearchProductsPagination(
      String searchProduct, int page) async {
    print("Running");
    Map<String, dynamic> body = Map<String, dynamic>();
    body['search_type'] = 'name';
    body['search_string'] = searchProduct;
    body['fields'] =
        'images,nutriscore_data,serving_size,selected_images,image_small_url,product_name,brands,quantity,code,nutrition_grade_fr,product_name_fr';
    body['limit'] = 20;
    body['page'] = page;

//    var productUri = Uri(
//        scheme: URI_SCHEME,
//        host: URI_HOST,
//        path: 'product/${config.barcode}',
//        queryParameters: config.getParametersMap());
    var uri = Uri.https(URI_HOST, 'products/similar');

//    HttpClientResponse httpResponse = await HttpHelper().doPost(uri, body);
//
//    print(" response ${httpResponse.statusCode}");
//
//
//    if(httpResponse.statusCode == 200){
//
//    }

    Response response = await HttpHelper().doPostRequestNormal(uri, body);
    if (response.statusCode == 200) {
      var result = SearchResult.fromJson(json.decode(response.body));

      for (Product product in result.products!) {
        ProductHelper.createImageUrls(product);
      }
      print("Check Length" + result.products!.length.toString());
      return result;
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  static Future<SearchResult> getCategoryProductsPagination(
      String searchString, String category, int page) async {
    Map<String, dynamic> body = Map<String, dynamic>();
    body['search_type'] = category;
    body['search_string'] = searchString;
    body['fields'] =
        'images,nutriscore_data,serving_size,selected_images,image_small_url,product_name,brands,quantity,code,nutrition_grade_fr,product_name_fr';
    body['limit'] = 20;
    body['page'] = page;

//    var productUri = Uri(
//        scheme: URI_SCHEME,
//        host: URI_HOST,
//        path: 'product/${config.barcode}',
//        queryParameters: config.getParametersMap());
    var uri = Uri.https(URI_HOST, 'products/similar');

    Response response = await HttpHelper().doPostRequestNormal(uri, body);
    if (response.statusCode == 200) {
      var result = SearchResult.fromJson(json.decode(response.body));

      for (Product product in result.products!) {
        ProductHelper.createImageUrls(product);
      }
      return result;

      //return jsonResponse.map((productObject) => Product.fromJson(productObject)).toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  static Future<List<Product>> getSearchProducts(String searchProduct) async {
    Map<String, dynamic> body = Map<String, dynamic>();
    body['search_type'] = 'name';
    body['search_string'] = searchProduct;
    body['fields'] =
        'images,nutriscore_data,serving_size,selected_images,image_small_url,product_name,brands,quantity,code,nutrition_grade_fr,product_name_fr';
    body['limit'] = 20;

//    var productUri = Uri(
//        scheme: URI_SCHEME,
//        host: URI_HOST,
//        path: 'product/${config.barcode}',
//        queryParameters: config.getParametersMap());
    var uri = Uri.https(URI_HOST, 'products/similar');

//    HttpClientResponse httpResponse = await HttpHelper().doPost(uri, body);
//
//    print(" response ${httpResponse.statusCode}");
//
//
//    if(httpResponse.statusCode == 200){
//
//    }

    Response response = await HttpHelper().doPostRequestNormal(uri, body);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);

      List<Product> fromJson = jsonResponse
          .map((productObject) => Product.fromJson(productObject))
          .toList();
      for (Product product in fromJson) {
        ProductHelper.createImageUrls(product);
      }
      return fromJson;
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  static Future<List<Product>> getCategoryProducts(
      String searchString, String category) async {
    Map<String, dynamic> body = Map<String, dynamic>();
    body['search_type'] = category;
    body['search_string'] = searchString;
    body['fields'] =
        'images,nutriscore_data,serving_size,selected_images,image_small_url,product_name,brands,quantity,code,nutrition_grade_fr,product_name_fr';
    body['limit'] = 20;

//    var productUri = Uri(
//        scheme: URI_SCHEME,
//        host: URI_HOST,
//        path: 'product/${config.barcode}',
//        queryParameters: config.getParametersMap());
    var uri = Uri.https(URI_HOST, 'products/similar');

    Response response = await HttpHelper().doPostRequestNormal(uri, body);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);

      List<Product> fromJson = jsonResponse
          .map((productObject) => Product.fromJson(productObject))
          .toList();
      for (Product product in fromJson) {
        ProductHelper.createImageUrls(product);
      }
      return fromJson;

      //return jsonResponse.map((productObject) => Product.fromJson(productObject)).toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  /// Search the OpenFoodFacts product database with the given parameters.
  /// Returns the list of products as SearchResult.
  /// Query the language specific host from OpenFoodFacts.
  static Future<SearchResult> searchProducts(
      User user, ProductSearchQueryConfiguration config) async {
    var searchUri = Uri(
        scheme: URI_SCHEME,
        host: URI_HOST,
        path: '/cgi/search.pl',
        queryParameters: config.getParametersMap());

    print("URI: " + searchUri.toString());

    Response response = await HttpHelper().doGetRequest(searchUri, user: user);
    var result = SearchResult.fromJson(json.decode(response.body));

    for (Product product in result.products!) {
      ProductHelper.parseIngredients(product);
      ProductHelper.removeImages(product, config.language!);
    }

    return result;
  }

  static Future<InsightResult> getRandomInsight(User user,
      {required InsightType type,
      required String country,
      required String valueTag,
      required String serverDomain}) async {
    final Map<String, String> parameters = Map<String, String>();

    if (type != null) {
      parameters["type"] = type.value!;
    }
    if (country != null) {
      parameters["country"] = country;
    }
    if (valueTag != null) {
      parameters["value_tag"] = valueTag;
    }
    if (serverDomain != null) {
      parameters["server_domain"] = serverDomain;
    }

    var robotoffInsightUri = Uri(
      scheme: URI_SCHEME,
      host: URI_HOST_ROBOTOFF,
      path: 'api/v1/insights/random/',
      queryParameters: parameters,
    );

    Response response =
        await HttpHelper().doGetRequest(robotoffInsightUri, user: user);
    var result =
        InsightResult.fromJson(json.decode(utf8.decode(response.bodyBytes)));

    return result;
  }

  static Future<MultipleInsightResult> getProductInsights(
      String barcode, User user) async {
    var insightsUri = Uri(
      scheme: URI_SCHEME,
      host: URI_HOST_ROBOTOFF,
      path: 'api/v1/insights/$barcode',
    );

    Response response =
        await HttpHelper().doGetRequest(insightsUri, user: user);

    return MultipleInsightResult.fromJson(
        json.decode(utf8.decode(response.bodyBytes)));
  }

  static Future<RobotoffQuestionResult> getRobotoffQuestionsForProduct(
      String barcode, String lang, User user,
      {required int count}) async {
    if (barcode == null || barcode.isEmpty) {
      return RobotoffQuestionResult();
    }

    if (count == null || count <= 0) {
      count = 1;
    }

    final Map<String, String> parameters = <String, String>{
      'lang': lang,
      'count': count.toString()
    };

    var robotoffQuestionUri = Uri(
      scheme: URI_SCHEME,
      host: URI_HOST_ROBOTOFF,
      path: 'api/v1/questions/$barcode',
      queryParameters: parameters,
    );

    Response response =
        await HttpHelper().doGetRequest(robotoffQuestionUri, user: user);
    var result = RobotoffQuestionResult.fromJson(
        json.decode(utf8.decode(response.bodyBytes)));

    return result;
  }

  static Future<RobotoffQuestionResult> getRandomRobotoffQuestion(
      String lang, User user,
      {required int count, required List<InsightType> types}) async {
    if (count == null || count <= 0) {
      count = 1;
    }

    List<String> typesValues = <String>[];
    types.forEach((t) {
      typesValues.add(t.value!);
    });

    String parsedTypes = typesValues.join(',');

    final Map<String, String> parameters = <String, String>{
      'lang': lang,
      'count': count.toString(),
      'insight_types': parsedTypes.toString()
    };

    var robotoffQuestionUri = Uri(
      scheme: URI_SCHEME,
      host: URI_HOST_ROBOTOFF,
      path: 'api/v1/questions/random',
      queryParameters: parameters,
    );

    print(robotoffQuestionUri);

    Response response =
        await HttpHelper().doGetRequest(robotoffQuestionUri, user: user);
    var result = RobotoffQuestionResult.fromJson(
        json.decode(utf8.decode(response.bodyBytes)));

    return result;
  }

  static Future<Status> postInsightAnnotation(
      String insightId, InsightAnnotation annotation, User user,
      {bool update = false}) async {
    var insightUri = Uri(
        scheme: URI_SCHEME,
        host: URI_HOST_ROBOTOFF,
        path: 'api/v1/insights/annotate');

    Map<String, String> annotationData = {
      "insight_id": insightId,
      "annotation": annotation.value.toString(),
      "update": update ? "1" : "0"
    };

    Response response =
        await HttpHelper().doPostRequest(insightUri, annotationData, user);
    var status = Status.fromJson(json.decode(response.body));
    return status;
  }

  static Future<SpellingCorrection?> getIngredientSpellingCorrection(
      {required String ingredientName,
      required Product product,
      required User user}) async {
    Map<String, String> spellingCorrectionParam;

    if (ingredientName != null) {
      spellingCorrectionParam = {
        "text": ingredientName,
      };
    } else if (product != null) {
      spellingCorrectionParam = {
        "barcode": product.barcode!,
      };
    } else {
      return null;
    }

    var spellingCorrectionUri = Uri(
        scheme: URI_SCHEME,
        host: URI_HOST_ROBOTOFF,
        path: 'api/v1/predict/ingredients/spellcheck',
        queryParameters: spellingCorrectionParam);

    Response response =
        await HttpHelper().doGetRequest(spellingCorrectionUri, user: user);
    SpellingCorrection result = SpellingCorrection.fromJson(
        json.decode(utf8.decode(response.bodyBytes)));

    return result;
  }
}
