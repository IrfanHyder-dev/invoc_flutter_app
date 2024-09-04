import 'package:flutter/material.dart';
import 'package:invoc/api/model/Product.dart';
import 'package:invoc/ui_view/nutrient_view.dart';
import 'package:invoc/ui_view/title_view.dart';
import 'package:invoc/utils/invoc_app_theme.dart';
import 'package:invoc/widgets/counter_animation.dart';

class ProductNormalHeader extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;
  final Product? product;

  const ProductNormalHeader(
      { this.animationController, this.animation, this.product});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 16, bottom: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: InvocAppTheme.white,
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 32, left: 1, right: 1, bottom: 16),
                      child: Row(
                        children: <Widget>[
                          if (product!.imgSmallUrl != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Center(
                                child: Container(
                                  height: 160,
                                  width: 120,
                                  child: FadeInImage(
                                    image: NetworkImage(product!.imgSmallUrl!),
                                    placeholder: AssetImage(
                                        'assets/images/ionov_transparent_logo.png'),
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
                                    image: DecorationImage(
                                        fit: BoxFit.scaleDown,
                                        image: AssetImage(
                                            'assets/images/ionov_transparent_logo.png')),
                                  ),
                                ),
                              ),
                            ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  if (product!.brands != null &&
                                      product!.brands!.isNotEmpty)
                                    Text(
                                      product!.brands!,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: InvocAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: InvocAppTheme.lightText,
                                      ),
                                    ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  if (product!.servingSize != null)
                                    Text(
                                      product!.servingSize!,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: InvocAppTheme.fontName,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: InvocAppTheme.darkText,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  if (product!.nutriscore != null)
                                    CounterAnimation(
                                        begin: 0,
                                        end: product!.currentNutriScore!,
                                        duration: 2,
                                        curve: Curves.easeOut,
                                        textStyle: TextStyle(
                                          fontFamily: InvocAppTheme.fontName,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                          color: InvocAppTheme
                                              .nutriColor[product!.nutriscore],
                                          decoration: TextDecoration.none,
                                        )),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (product!.nutriments != null)
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, top: 8, bottom: 8),
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            color: InvocAppTheme.background,
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 8,
                    ),
                    if (product!.nutriments != null)
                      TitleView(
                        titleTxt: 'Nutriments',
                        subTxt: '',
                        animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: animationController!,
                                curve: Interval((1 / 4) * 0, 1.0,
                                    curve: Curves.fastOutSlowIn))),
                        animationController: animationController!,
                      ),
                    SizedBox(
                      height: 8,
                    ),
                    if (product!.nutrientList != null &&
                        product!.nutrientList!.isNotEmpty)
                      GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        childAspectRatio: 2.0,
                        padding: const EdgeInsets.only(
                            top: 0, bottom: 0, right: 16, left: 16),
                        children:
                            List.generate(product!.nutrientList!.length, (index) {
                          final int count = product!.nutrientList!.length;
                          final Animation<double> animation =
                              Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                      parent: animationController!,
                                      curve: Interval((1 / count) * index, 1.0,
                                          curve: Curves.fastOutSlowIn)));
                          animationController!.forward();

                          return NutrientView(
                            nutrientLevelItem: product!.nutrientList![index],
                            animation: animation,
                            animationController: animationController,
                          );
                        }),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
