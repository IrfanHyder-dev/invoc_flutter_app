import 'package:flutter/material.dart';
import 'package:invoc/api/model/Product.dart';
import 'package:invoc/utils/invoc_app_theme.dart';

class StaggeredProductItemView extends StatelessWidget {
  final Product product;
  final AnimationController animationController;
  final Animation<double> animation;

  StaggeredProductItemView(
      this.product, this.animationController, this.animation);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation.value), 0.0, 0.0),
            child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                color: Colors.white,
                margin: const EdgeInsets.all(8),
                child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: <Widget>[
                        if (product.imgSmallUrl != null)
                          Container(
                            child: FadeInImage(
                              image: NetworkImage(product.imgSmallUrl!),
                              placeholder: AssetImage(
                                  'assets/images/ionov_transparent_logo.png'),
                            ),
                          ),
                        if (product.imgSmallUrl == null)
                          Container(
                            child: Image.asset(
                                'assets/images/ionov_transparent_logo.png',
                                fit: BoxFit.scaleDown),
                          ),
                        SizedBox(
                          height: 8,
                        ),
                        if (product.productName != null)
                          Text(
                            product.productName!,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: InvocAppTheme.fontName,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              letterSpacing: 0.2,
                              color: InvocAppTheme.darkText,
                            ),
                          ),
                        if (product.brands != null)
                          Padding(
                              padding: const EdgeInsets.only(
                                top: 4,
                              ),
                              child: Text(
                                product.brands!,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: InvocAppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  letterSpacing: 0.2,
                                  color: InvocAppTheme.dark_grey,
                                ),
                              )),
                        if (product.servingSize != null)
                          Padding(
                              padding: const EdgeInsets.only(
                                top: 4,
                              ),
                              child: Text(
                                product.servingSize!,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: InvocAppTheme.fontName,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12,
                                  letterSpacing: 0.2,
                                  color: InvocAppTheme.dark_grey,
                                ),
                              )),
                      ],
                    ))),
          ),
        );
      },
    );
  }
}
