import 'package:flutter/material.dart';
import 'package:invoc/utils/invoc_app_theme.dart';

class NutriscoreWidget extends StatelessWidget {
  final String _productNutriscore;

  final List<String> _scores = ["a", "b", "c", "d", "e"];
  final Map<String, Color> _colors = {
    "a": Color.fromARGB(255, 68, 123, 71),
    "b": Color.fromARGB(255, 134, 174, 62),
    "c": Color.fromARGB(255, 233, 192, 51),
    "d": Color.fromARGB(255, 206, 110, 40),
    "e": Color.fromARGB(255, 190, 46, 32),
  };

  NutriscoreWidget(this._productNutriscore);

  Widget _buildTile(String value, bool isScoreOfProduct) {
    if (isScoreOfProduct)
      return Container(
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
            color: _colors[value],
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: InvocAppTheme.white, width: 1.0)),
        child: Text(
          value.toUpperCase(),
          style: TextStyle(
              decoration: TextDecoration.none,
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
      );

    BorderRadius? containerBorder;

    if (value == "a")
      containerBorder = BorderRadius.only(
          topLeft: Radius.circular(4), bottomLeft: Radius.circular(4));
    else if (value == "e")
      containerBorder = BorderRadius.only(
          topRight: Radius.circular(4), bottomRight: Radius.circular(4));

    return Container(
      padding: EdgeInsets.all(2.0),
      decoration:
          BoxDecoration(color: _colors[value], borderRadius: containerBorder),
      child: Text(
        value.toUpperCase(),
        style: TextStyle(
            color: Colors.white.withAlpha(150),
            fontSize: 16,
            decoration: TextDecoration.none,
            fontWeight: FontWeight.w400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        children: _scores
            .map((score) => _buildTile(score, score == _productNutriscore))
            .toList(),
      ),
    );
  }
}
