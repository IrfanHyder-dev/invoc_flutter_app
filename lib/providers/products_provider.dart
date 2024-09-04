import 'package:flutter/material.dart';
import 'package:invoc/api/InvocAPIClient.dart';
import 'package:invoc/api/utils/ProductQueryConfigurations.dart';

class ProductsProvider extends ChangeNotifier {
  List<String> _scannedBarcodes = [];
  List<Product> _products = [];
  List<Product> get products => _products;

  Future findProductFromBarcode(String barcode) async {
    if (_scannedBarcodes.contains(barcode)) return;
    _scannedBarcodes.add(barcode);
    final Product result =
        await InvocAPIClient.getProduct(ProductQueryConfiguration(barcode));
    if (result != null) return;
    _products.insert(0, result);
    notifyListeners();
  }
}
