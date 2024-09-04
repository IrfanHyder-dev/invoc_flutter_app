import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconCard extends StatelessWidget {
  const IconCard({
    this.icon,
    this.name,
  });

  final String? icon;
  final String? name;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
        margin: EdgeInsets.only(right: 16, bottom: 15, left: 20),
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        elevation: 2,
        child: Container(
          alignment: Alignment.center,
          height: (size.height * 0.15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                      height: 42, width: 42, child: SvgPicture.asset(icon!))),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
                color: Color(0xFF8FD96E),
                height: 20,
                width: MediaQuery.of(context).size.width,
                child: Text(name!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w300,
                      fontSize: 10,
                      color: const Color(0xff3C285C),
                    )),
              ),
            ],
          ),
        ));
  }
}
