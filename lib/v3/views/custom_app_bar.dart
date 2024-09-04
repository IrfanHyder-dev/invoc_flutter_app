import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomAppBar extends PreferredSize{
  final double? height;
  final bool? showBackButton;
  final bool? hideColor;

  CustomAppBar(this.showBackButton, this.hideColor,
      {this.height = kToolbarHeight}) : super(preferredSize: Size.fromHeight(kToolbarHeight),child: Container());


  Size get preferredSize => Size.fromHeight(height!);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (showBackButton!)
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 8),
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ),
            if (!hideColor!)
              Expanded(
                  child: Stack(children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    height: kToolbarHeight,
                    width: size.width - size.width / 2.2,
                    child: SvgPicture.asset('assets/images/top-effect.svg',
                        allowDrawingOutsideViewBox: true, fit: BoxFit.fill),
                  ),
                ),
              ]))
          ],
        ));
  }
}
