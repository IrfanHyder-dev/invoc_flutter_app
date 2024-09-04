import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/guide/info_guide_widget.dart';

class InvocScoreWidget extends StatefulWidget {
  final String _productNutriscore;
  final bool showInfoIcon;

  InvocScoreWidget(this._productNutriscore, this.showInfoIcon);

  @override
  State<InvocScoreWidget> createState() => _InvocScoreWidgetState();
}

class _InvocScoreWidgetState extends State<InvocScoreWidget> {
  final GlobalKey btnKey = GlobalKey();

  final List<String> _scores = ["a", "b", "c", "d", "e"];

  final Map<String, Color> _colors = {
    "a": Color.fromARGB(255, 0, 134, 15),
    "b": Color.fromARGB(255, 0, 193, 37),
    "c": Color.fromARGB(255, 234, 189, 0),
    "d": Color.fromARGB(255, 252, 144, 44),
    "e": Color.fromARGB(255, 234, 63, 0),
  };

  //
  Widget _buildTile(String value, bool isScoreOfProduct) {
    if (isScoreOfProduct)
      return Container(
        margin: EdgeInsets.only(left: 0.5, right: 0.5),
        width: 29,
        height: 29,
        decoration: BoxDecoration(
          color: _colors[value],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
            child: Text(
          value.toUpperCase(),
          style: TextStyle(
              decoration: TextDecoration.none,
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600),
        )),
      );

    BorderRadius containerBorder = BorderRadius.all(Radius.circular(4));
    return Container(
      margin: EdgeInsets.only(left: 0.5, right: 0.5),
      width: 23,
      height: 23,
      decoration: BoxDecoration(
          color: _colors[value]!.withOpacity(0.5),
          borderRadius: containerBorder),
      child: Center(
          child: Text(
        value.toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white.withAlpha(130),
            fontSize: 16,
            decoration: TextDecoration.none,
            fontWeight: FontWeight.w100),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: _scores
              .map((score) =>
                  _buildTile(score, score == widget._productNutriscore))
              .toList(),
        ),
        //SizedBox(width: 5,),
        if (widget.showInfoIcon)
          GestureDetector(
              key: btnKey,
              onTap: () {
                Get.bottomSheet(InfoGuideSheet(context: context),
                    isScrollControlled: true,
                    isDismissible: false,
                    enableDrag: false,
                    ignoreSafeArea: false);
              },
              child: Container(
                  height: 25,
                  width: 25,
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: Icon(
                      Icons.info,
                    ),
                  )))
      ],
    );
  }
}
