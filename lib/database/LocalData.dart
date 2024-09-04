import 'dart:io';

import 'package:invoc/api/InvocAPIClient.dart';
import 'package:invoc/api/model/firestore_product.dart';
import 'package:invoc/api/utils/LanguageHelper.dart';
import 'package:invoc/api/utils/ProductFields.dart';
import 'package:invoc/api/utils/ProductQueryConfigurations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class FullProductsDatabase {
  FullProductsDatabase() {
    factory = databaseFactoryIo;
  }

  DatabaseFactory? factory;
  bool useLocalDatabase = false;



  Future<Product?> fetchProduct(String barcode) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = join(directory.path, 'full_products_database.db');
    final Database database = await factory!.openDatabase(path);

    final StoreRef<dynamic, dynamic> store = StoreRef<dynamic, dynamic>.main();

    if (useLocalDatabase && await store.record(barcode).exists(database)) {
      Product? localProduct = await getProduct(barcode);
      return localProduct;
    }

    final ProductQueryConfiguration configuration =
    ProductQueryConfiguration(barcode,
        fields: <ProductField>[
          ProductField.NAME,
          ProductField.BRANDS,
          ProductField.BARCODE,
          ProductField.NUTRISCORE,
          ProductField.FRONT_IMAGE,
          ProductField.QUANTITY,
          ProductField.SERVING_SIZE,
          ProductField.PACKAGING_QUANTITY,
          ProductField.NUTRIMENTS,
          ProductField.NUTRIMENT_ENERGY_UNIT,
          ProductField.LANGUAGE
        ],
        language: OpenFoodFactsLanguage.ENGLISH);

    final Product result =
    await InvocAPIClient.getProduct(configuration);


    if (result != null ) {
      saveProduct(result);
      return result;
    }

    return Product();

//    await InvocAPIClient.getProduct(configuration).then((product){
//      saveProduct(product);
//        return product;
//    }).catchError((Object _error){
//      return Product();
//    });

  }


  Future<bool> checkAndFetchProduct(String barcode) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = join(directory.path, 'full_products_database.db');
    final Database database = await factory!.openDatabase(path);

    final StoreRef<dynamic, dynamic> store = StoreRef<dynamic, dynamic>.main();

    if (useLocalDatabase && await store.record(barcode).exists(database)) {

      return true;
    }

    final ProductQueryConfiguration configuration =
    ProductQueryConfiguration(barcode,
        fields: <ProductField>[
          ProductField.NAME,
          ProductField.BRANDS,
          ProductField.BARCODE,
          ProductField.NUTRISCORE,
          ProductField.FRONT_IMAGE,
          ProductField.QUANTITY,
          ProductField.SERVING_SIZE,
          ProductField.PACKAGING_QUANTITY,
          ProductField.NUTRIMENTS,
          ProductField.NUTRIMENT_ENERGY_UNIT,
          ProductField.LANGUAGE
        ],
        language: OpenFoodFactsLanguage.ENGLISH);

    final Product result =
    await InvocAPIClient.getProduct(configuration);

    if (result != null ) {
      saveProduct(result);
      return true;
    }

    return false;
  }

  Future<bool> saveProduct(Product newProduct) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = join(directory.path, 'full_products_database.db');
    final Database database = await factory!.openDatabase(path);

    try {
      final StoreRef<dynamic, dynamic> store =
      StoreRef<dynamic, dynamic>.main();
      await store.record(newProduct.barcode).put(database, newProduct.toJson());
      return true;
    } catch (e) {
      print('An error occurred while saving product to local database : $e');
      return false;
    }
  }

  Future<bool> saveFirestoreProduct(dynamic newProduct) async {
    print('local saveFirestroeProduct');
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = join(directory.path, 'full_products_database.db');
    final Database database = await factory!.openDatabase(path);

    try {
      final StoreRef<dynamic, dynamic> store =
      StoreRef<dynamic, dynamic>.main();
      await store.record(newProduct['code']).put(database, newProduct);
      return true;
    } catch (e) {
      print('An error occurred while saving product to local database : $e');
      return false;
    }
  }

  Future<FirestoreProduct?> getFirestoreProduct(String barcode) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = join(directory.path, 'full_products_database.db');
    final Database database = await factory!.openDatabase(path);

    final StoreRef<dynamic, dynamic> store = StoreRef<dynamic, dynamic>.main();
    final Map<String, dynamic> jsonProduct =
    await store.record(barcode).get(database) as Map<String, dynamic>;

    if (jsonProduct != null) {
      //print(jsonProduct);
      return FirestoreProduct.fromJson(jsonProduct);
    }

    return null;
  }


  Future<Product?> getProduct(String barcode) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = join(directory.path, 'full_products_database.db');
    final Database database = await factory!.openDatabase(path);

    final StoreRef<dynamic, dynamic> store = StoreRef<dynamic, dynamic>.main();
    final Map<String, dynamic> jsonProduct =
    await store.record(barcode).get(database) as Map<String, dynamic>;

    if (jsonProduct != null) {
      print(jsonProduct);
      return Product.fromJson(jsonProduct);
    }

    return null;
  }

  Future<List<FirestoreProduct>?> getFirestoreProductList() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = join(directory.path, 'full_products_database.db');
    final Database database = await factory!.openDatabase(path);
    List<FirestoreProduct> firestoreProducts = <FirestoreProduct>[];

    try {
      final StoreRef<dynamic, dynamic> store =
      StoreRef<dynamic, dynamic>.main();

      (await store.find(database)).forEach((element) {
        firestoreProducts.add(FirestoreProduct.fromJson(element.value));
      });
      return firestoreProducts;
    } catch (e) {
      print('An error occurred while loading user preferences from localData: $e');
      return null;
    }
  }
}