import 'package:flutter/material.dart';
import 'package:invoc/api/model/NutrientLevelItem.dart';
import 'package:invoc/main.dart';
import 'package:invoc/utils/invoc_app_theme.dart';

class NutrientView extends StatelessWidget {
  final NutrientLevelItem? nutrientLevelItem;
  final AnimationController? animationController;
  final Animation<double>? animation;

  const NutrientView(
      {
      this.nutrientLevelItem,
      this.animationController,
      this.animation})
  ;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
              transform: Matrix4.translationValues(
                  100 * (1.0 - animation!.value), 0.0, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    nutrientLevelItem!.category,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: InvocAppTheme.fontName,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      letterSpacing: -0.2,
                      color: InvocAppTheme.darkText,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Container(
                      height: 4,
                      width: 70,
                      decoration: BoxDecoration(
                        color:
                            HexColor(nutrientLevelItem!.color).withOpacity(0.2),
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: ((70 / nutrientLevelItem!.divider) *
                                animation!.value),
                            height: 4,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                HexColor(nutrientLevelItem!.color),
                                HexColor(nutrientLevelItem!.color)
                                    .withOpacity(0.5),
                              ]),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.0)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      nutrientLevelItem!.reading,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: InvocAppTheme.fontName,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: HexColor(nutrientLevelItem!.color),
                      ),
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }
}
