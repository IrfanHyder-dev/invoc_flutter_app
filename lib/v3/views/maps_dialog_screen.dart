import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:invoc/main.dart';
import 'package:invoc/v3/auth/constants/enums.dart';
import 'package:invoc/v3/views/osa_map_for_user.dart';
import 'package:invoc/v3/views/out_of_stock_map.dart';
import 'package:invoc/v3/views/re_stock_map.dart';
import 'package:provider/provider.dart';

import '../../api/model/firestore_product.dart';
import '../../providers/report_product_provider.dart';

class MapsDialog extends StatelessWidget {
  const MapsDialog({
    super.key,
    required this.buttonSelected,
    required this.reportProductProvider,
    required this.currentLatLng,
    required this.firestoreProduct,
  });

  final int buttonSelected;
  final ReportProductProvider reportProductProvider;
  final LatLng? currentLatLng;
  final FirestoreProduct firestoreProduct;

  @override
  Widget build(BuildContext context) {
    print('current latlng ${currentLatLng}');
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Consumer<ReportProductProvider>(builder: (context, value, child) {
        return Center(
          child: Container(
            margin: EdgeInsets.all(20.0),
            padding: EdgeInsets.only(
              bottom: 10.0,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.20000000298023224),
                    offset: Offset(0, 12),
                    blurRadius: 24)
              ],
              //color: Colors.green,
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
            child: (GlobalVariables.userRole == UserRole.user)
                ? buttonSelected == 0
                    ? OSAMapForUser(

                        coordinates:
                        // (reportProductProvider.latLng != null)
                        //     ? reportProductProvider.latLng!
                        //     :
                        currentLatLng,
                        productCode: firestoreProduct.code!,
                        productName: firestoreProduct.productName!,
                      )
                    : OutOfStockMap(
                        productCode: firestoreProduct.code!,
                        productName: firestoreProduct.productName!,
                      )
                : ReStockMap(),
          ),
        );
      });
    });
  }
}
