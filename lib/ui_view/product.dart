import 'package:flutter/material.dart';
import 'package:invoc/api/InvocAPIClient.dart';
import 'package:invoc/utils/invoc_app_theme.dart';

class ProductView extends StatelessWidget {
  const ProductView(
      { this.animationController, this.animation, this.product});
  final AnimationController? animationController;
  final Animation<double>? animation;
  final Product? product;

  @override
  Widget build(BuildContext context) {
    ProductHelper.createImageUrls(product!);

    return SizedBox(
      width: double.infinity,
      height: 190,
      child: Stack(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
            child: Container(
              decoration: BoxDecoration(
                color: InvocAppTheme.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: InvocAppTheme.grey.withOpacity(0.2),
                      offset: Offset(1.1, 1.1),
                      blurRadius: 10.0),
                ],
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 16, left: 16, right: 16, bottom: 8),
                child: Row(children: <Widget>[
                  Column(
                    children: <Widget>[
                      if (product!.imgSmallUrl != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Center(
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(product!.imgSmallUrl!)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                            ),
                          ),
                        ),
                      if (product!.imgSmallUrl == null)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Center(
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.grey,
                                image: DecorationImage(
                                    fit: BoxFit.scaleDown,
                                    image: AssetImage(
                                        'assets/images/ionov_transparent_logo.png')),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 110,
                        child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.favorite_border,
                                    color: InvocAppTheme.nearlyDarkBlue,
                                    size: 30,
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Icon(
                                    Icons.share,
                                    color: InvocAppTheme.nearlyDarkBlue,
                                    size: 30,
                                  )
                                ],
                              ), //Your widget here,
                            )),
                      )
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          product!.productName!,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: InvocAppTheme.fontName,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 0.2,
                            color: InvocAppTheme.darkText,
                          ),
                        ),
                        if (product!.brands != null)
                          Padding(
                              padding: const EdgeInsets.only(
                                top: 4,
                              ),
                              child: Text(
                                //mealsListData.meals.join('\n'),
                                product!.brands!,
                                style: TextStyle(
                                  fontFamily: InvocAppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  letterSpacing: 0.2,
                                  color: InvocAppTheme.dark_grey,
                                ),
                              )),
                        if (product!.servingSize != null)
                          Padding(
                              padding: const EdgeInsets.only(
                                top: 4,
                              ),
                              child: Text(
                                //mealsListData.meals.join('\n'),
                                product!.servingSize!,
                                style: TextStyle(
                                  fontFamily: InvocAppTheme.fontName,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 13,
                                  letterSpacing: 0.2,
                                  color: InvocAppTheme.dark_grey,
                                ),
                              )),
                      ],
                    ),
                  )
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
