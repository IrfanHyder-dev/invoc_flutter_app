import 'package:flutter/material.dart';
import 'package:invoc/api/model/Product.dart';
import 'package:invoc/utils/invoc_app_theme.dart';
import 'package:invoc/widgets/counter_animation.dart';

class ProductOverviewTile extends StatelessWidget {
  final Product product;

  ProductOverviewTile(this.product);

  Widget _buildName() {
    if (product.productName != null && product.productName!.isNotEmpty) {
      return Text(
        product.productName!,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontFamily: InvocAppTheme.fontName,
          fontWeight: FontWeight.w600,
          fontSize: 16,
          letterSpacing: -0.1,
          color: InvocAppTheme.darkText,
          decoration: TextDecoration.none,
        ),
      );
    } else {}
    return Container();
  }

  Widget _buildTextsColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildName(),

        SizedBox(
          height: 8,
        ),

        if (product.brands != null && product.brands!.isNotEmpty)
          Text(
            product.brands!,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: InvocAppTheme.fontName,
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: InvocAppTheme.lightText,
              decoration: TextDecoration.none,
            ),
          ),
        SizedBox(
          height: 8,
        ),
        if (product.servingSize != null)
          Text(
            product.servingSize!,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: InvocAppTheme.fontName,
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: InvocAppTheme.darkText,
              decoration: TextDecoration.none,
            ),
          ),
        SizedBox(
          height: 8,
        ),
        if (product.nutriscore != null)
          CounterAnimation(
            begin: 0,
            end: product.currentNutriScore,
            duration: 2,
            curve: Curves.easeOut,
            textStyle: TextStyle(
              fontFamily: InvocAppTheme.fontName,
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: InvocAppTheme.nutriColor[product.nutriscore],
              decoration: TextDecoration.none,
            ),
          )
        //       if(product.categoryNutriScore != null && product.categoryNutriScore.scores.elementAt(0).entries.length > 1 ) InvocLineChart(product: product,)
      ],
    );
  }

  Widget _buildDragIndicator() {
    return Container(
      // GestureDetector
      margin: EdgeInsets.symmetric(horizontal: 60.0, vertical: 12.0),
      width: 60,
      height: 8,
      decoration: BoxDecoration(
          color: Colors.grey.withAlpha(150),
          borderRadius: BorderRadius.circular(5)),
    );
  }

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
        topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0));
    if (product == null) return Container();
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: radius),
      child: Column(
        children: <Widget>[
          _buildDragIndicator(),
          Expanded(
            child: Row(
              children: <Widget>[
                if (product.imgSmallUrl != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.only(left: 16),
                        height: 160,
                        width: 120,
                        child: FadeInImage(
                          image: NetworkImage(product.imgSmallUrl!),
                          placeholder: AssetImage(
                              'assets/images/ionov_transparent_logo.png'),
                        ),
                      ),
                    ),
                  ),
                if (product.imgSmallUrl == null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Center(
                      child: Container(
                        height: 160,
                        width: 120,
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
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: _buildTextsColumn(),
                ),
                SizedBox(
                  width: 8,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
