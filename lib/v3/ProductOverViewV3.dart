import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoc/api/model/firestore_product.dart';
import 'package:invoc/utils/invoc_app_theme.dart';
import 'package:invoc/v3/views/invoc_score_grid.dart';

class ProductOverViewV3 extends StatelessWidget {
  FirestoreProduct product;

  ProductOverViewV3(this.product);
  String capitalizeFirstLetter(String input) {
    print('string string product overView $input');
    if(input.isNotEmpty && input != null){
      String data = input[0].toUpperCase() + input.substring(1);
      return data.replaceAll(RegExp(r'\s*,\s*|(?<!\s),(?!\s)'), ' - ');
    }else{
      return input.replaceAll(RegExp(r'\s*,\s*|(?<!\s),(?!\s)'), ' - ');
    }
  }
  Widget newVersion() {
    Color? nutriColor = product.nutriscoreGrade != null
        ? InvocAppTheme.nutriColor[product.nutriscoreGrade]
        : const Color(0xfff1583c);
    return Container(
      color: Colors.transparent,
      height: 280,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 220,
            decoration: BoxDecoration(
              color: InvocAppTheme.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18.0),
                topRight: const Radius.circular(18.0),
              ),
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 30,
                  left: 20,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (product.brands != null && product.brands!.isNotEmpty)
                          Text(capitalizeFirstLetter(product.brands!),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontFamily: InvocAppTheme.fontName,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: InvocAppTheme.textColor,
                                  decoration: TextDecoration.none),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        SizedBox(
                          height: 4,
                        ),
                        Container(
                          width: Get.width * 0.5,
                          child: Text(capitalizeFirstLetter(product.productName!),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontFamily: InvocAppTheme.fontName,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: InvocAppTheme.textColor,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        InvocScoreWidget(product.nutriscoreGrade!, false),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 12,
            // right: 0,
            left: 20,
            height: 70,
            width: 70,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  //color: Colors.purple,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.pink, width: 2),
                ),
                child: Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: nutriColor!, width: 2)),
                  child: Center(
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontFamily: 'GilroyBold',
                          fontSize: 22,
                          color: nutriColor,
                        ),
                        children: [
                          if (product.nutriscoreScore != null)
                            TextSpan(
                              text: product.nutriscoreScore.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            // left: 0,
            right: 20,
            width: 113.0,
            height: 178.0,
            child: Container(
              //color: Colors.green,

              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage( product.images?.thumb ?? ""),
                          fit: BoxFit.contain),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return newVersion();
  }
}
