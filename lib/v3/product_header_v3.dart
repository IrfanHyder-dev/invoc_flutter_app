import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoc/api/model/firestore_product.dart';
import 'package:invoc/src/language/language_keys.dart';
import 'package:invoc/utils/invoc_app_theme.dart';
import 'package:invoc/v3/views/invoc_score_grid.dart';

class ProductNormalHeader extends StatelessWidget {
  final FirestoreProduct? product;
  final bool hideName;
  final String name = 'mounim,Naeem iqbal';

  const ProductNormalHeader({this.product, required this.hideName});


  String capitalizeFirstLetter(String input) {
    print('string string product header $input');
    if(input.isNotEmpty && input != null){
      String data = input[0].toUpperCase() + input.substring(1);
      return data.replaceAll(RegExp(r'\s*,\s*|(?<!\s),(?!\s)'), ' - ');
    }else{
      return input.replaceAll(RegExp(r'\s*,\s*|(?<!\s),(?!\s)'), ' - ');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 8, right: 5),
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(
                    top: 12, left: 1, right: 1, bottom: 12),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Center(
                            child: Container(
                              height: 104,
                              width: 104,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: product!.images == null
                                        ? Image.asset(
                                                'assets/images/bunny_small.png')
                                            .image
                                        : Image.network(product!.images!.thumb!)
                                            .image),
                              ),
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
                                Text(
                                    product!.calculatedBrand!.isNotEmpty
                                        ? capitalizeFirstLetter(product!.calculatedBrand!)
                                        : product!.brands!.isNotEmpty
                                            ? capitalizeFirstLetter(product!.brands!)
                                            : "",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontFamily: InvocAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: InvocAppTheme.textColor,
                                        decoration: TextDecoration.none),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                SizedBox(
                                  height: 4,
                                ),
                                if (!hideName)
                                  Text(capitalizeFirstLetter(product!.productName!),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontFamily: InvocAppTheme.fontName,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 22,
                                        color: InvocAppTheme.textColor,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                if (!hideName)
                                  SizedBox(
                                    height: 4,
                                  ),
                                Text.rich(
                                  TextSpan(
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontFamily: InvocAppTheme.fontName,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xff2e2e2e),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: product!.nutriments!.energyKcalValue == null
                                            ? ""
                                            : product!.nutriments!.energyKcalValue
                                                .toString(),
                                      ),
                                      // if (pproduct!.nutriments!.energyKcalValue == null)
                                      //   TextSpan(
                                      //     text: kcalPerKey.tr,
                                      //     style: TextStyle(
                                      //       fontSize: 14,
                                      //       fontWeight: FontWeight.w400,
                                      //     ),
                                      //   ),
                                      if (product!.nutriments!.energyKcalValue != null)
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
                                if (product!.nutriscoreGrade != null)
                                  InvocScoreWidget(
                                      product!.nutriscoreGrade!, true),
                                if (product!.novaGroup != null) ...[
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Material(
                                    color: Colors.white,
                                    child: Row(
                                      children: [
                                        Text(
                                          '${novaKey.tr}:',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 25,
                                            child: ListView.builder(
                                                itemCount: 4,
                                                shrinkWrap: true,
                                                physics:
                                                    BouncingScrollPhysics(),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (_, index) {
                                                  int i = index + 1;
                                                  return Container(
                                                    margin: EdgeInsets.only(
                                                        right: 8),
                                                    height: 25,
                                                    width: 25,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        border: Border.all(
                                                            color: product
                                                                        !.novaGroup ==
                                                                    i
                                                                ? Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                : Colors
                                                                    .black)),
                                                    child: Center(
                                                      child: Text(
                                                        i.toString(),
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              product!.novaGroup ==
                                                                      i
                                                                  ? FontWeight
                                                                      .bold
                                                                  : FontWeight
                                                                      .w400,
                                                          color: product
                                                                      !.novaGroup ==
                                                                  i
                                                              ? Theme.of(
                                                                      context)
                                                                  .primaryColor
                                                              : Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                                if (product!.additivesN != null) ...[
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Material(
                                    color: Colors.white,
                                    child: Row(
                                      children: [
                                        Text(
                                          '${additiveKey.tr}:',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 25,
                                            child: ListView.builder(
                                                itemCount: 4,
                                                shrinkWrap: true,
                                                physics:
                                                    BouncingScrollPhysics(),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (_, i) {
                                                  return Container(
                                                    margin: EdgeInsets.only(
                                                        right: 8),
                                                    height: 25,
                                                    width: 25,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        border: Border.all(
                                                            color: (product!.additivesN ==
                                                                        i ||
                                                                    (i == 3 &&
                                                                        product!.additivesN! > 3))
                                                                ? Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                : Colors
                                                                    .black)),
                                                    child: Center(
                                                      child: Text(
                                                        i == 3
                                                            ? "3+"
                                                            : i.toString(),
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: (product
                                                                          !.additivesN ==
                                                                      i ||
                                                                  (i == 3 &&
                                                                      product!.additivesN! >
                                                                          3))
                                                              ? FontWeight.bold
                                                              : FontWeight.w400,
                                                          color: (product!.additivesN ==
                                                                      i ||
                                                                  (i == 3 &&
                                                                      product!.additivesN! >
                                                                          3))
                                                              ? Theme.of(
                                                                      context)
                                                                  .primaryColor
                                                              : Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                ]
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
