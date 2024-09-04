import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoc/api/model/firestore_product.dart';
import 'package:invoc/src/language/language_keys.dart';
import 'package:invoc/utils/invoc_app_theme.dart';

class ProductItem extends StatelessWidget {
  final FirestoreProduct? product;

  const ProductItem({ this.product});

  String replaceCommaWithDash(String input) {
    if(input.isNotEmpty && input != null){
      String data = input[0].toUpperCase() + input.substring(1);
      return data.replaceAll(RegExp(r'\s*,\s*|(?<!\s),(?!\s)'), ' - ');
    }else{
      return input.replaceAll(RegExp(r'\s*,\s*|(?<!\s),(?!\s)'), ' - ');
    }
  }

  @override
  Widget build(BuildContext context) {
    Color? nutriColor = product!.nutriscoreGrade != null
        ? InvocAppTheme.nutriColor[product!.nutriscoreGrade]
        : const Color(0xfff1583c);
    return Padding(
      padding: const EdgeInsets.only(top: 2, left: 8, right: 12),
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(
                    top: 5, left: 1, right: 1, bottom: 12),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Center(
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: product!.images != null
                                    ? Image.network(product!.images!.thumb!).image
                                    : AssetImage(
                                        'assets/images/bunny_small.png'),
                              )),
                            ),
                          ),
                        ),
                        //if(product.imgSmallUrl == null)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                if (product!.brands != null &&
                                    product!.brands!.isNotEmpty)
                                  Text(replaceCommaWithDash(product!.brands!),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontFamily: InvocAppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: InvocAppTheme.textColor,
                                          overflow:TextOverflow.ellipsis ,
                                          decoration: TextDecoration.none),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                    // product!.productName!,
                                    replaceCommaWithDash(product!.productName!),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontFamily: InvocAppTheme.fontName,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                      color: InvocAppTheme.textColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                SizedBox(
                                  height: 4,
                                ),
                                //if(product.servingSize != null )
                                if (product!.nutriments != null && product!.nutriments!.energyKcalValue != null)
                                Text.rich(
                                  TextSpan(
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontFamily: InvocAppTheme.fontName,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xff2e2e2e),
                                    ),
                                    children: [
                                      // if (product!.nutriments != null && product!.nutriments!.energyKcalValue != null)
                                        TextSpan(
                                          text: product
                                              !.nutriments!.energyKcalValue
                                              .toString(),
                                        ),
                                      if (product!.servingQuantity != null )
                                        TextSpan(
                                          text: kcalPerKey.tr,
                                          // '${product.servingQuantity.toInt()}'
                                          // 'g',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      if (product!.servingQuantity == null )
                                        TextSpan(
                                          text: kcalPerKey.tr,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                    ],
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                //InvocScoreWidget(product.nutriscoreGrade),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (product!.nutriscoreGrade != null)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          height: 28,
                          width: 28,
                          // alignment: Alignment.center,
                          decoration: BoxDecoration(shape: BoxShape.circle,color: nutriColor),
                          child: Center(
                            child: Text.rich(
                              TextSpan(
                                style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontFamily: 'GilroyBold',
                                  fontSize: 15,
                                  color: Colors.white,
                                  height: 1
                                ),
                                children: [
                                  if (product!.nutriscoreScore != null)
                                    TextSpan(
                                      text: product!.nutriscoreGrade.toString().toUpperCase(),
                                      //text: InvocAppTheme.getPosition(product.nutriscoreScore, product.nutriscoreGrade).toInt().toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        // height: 1
                                      ),
                                    ),
                                ],
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
