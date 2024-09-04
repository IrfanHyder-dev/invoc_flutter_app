import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RowTextWidget extends StatelessWidget {
  RowTextWidget({
    this.title,
    this.description,
  });

  String? title;
  String? description;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: Get.width * 0.2,
            height: Get.height * 0.04,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Get.height * 0.01),
              border: Border.all(color: Colors.white),
            ),
            child: Center(
              child: Text(
                title!,
                maxLines: 3,
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Container(
            height: Get.height * 0.04,
            child: RotationTransition(
                turns: new AlwaysStoppedAnimation(45 / 360),
                child: Image.asset("assets/icons/red_arrow_up.png")),
          ),
          SizedBox(
            width: 5,
          ),
          Container(
            width: Get.width * 0.55,
            height: Get.height * 0.12,
            // alignment: Alignment.topLeft,
            child: Text(
              description!,
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.w100),
            ),
          ),
        ],
      ),
    );
  }
}
