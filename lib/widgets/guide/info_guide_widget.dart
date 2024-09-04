import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoc/api/InvocAPIClient.dart';
import 'package:invoc/src/language/language_keys.dart';
import 'package:invoc/widgets/guide/row_text_widget.dart';
import '../../utils/invoc_app_theme.dart';
import '../../v3/views/invoc_score_grid.dart';

class InfoGuideSheet extends StatelessWidget {
  const InfoGuideSheet({
    required this.context,
  }) ;

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    Color color = InvocAppTheme.nutriColor["e"]!;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(
          Get.height * 0.02,
        ),
        height: context.height,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.topRight,
              child: CloseButton(
                color: Colors.red,
                onPressed: () => Get.back(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: Get.height * 0.05,
                  child: RotationTransition(
                    turns: new AlwaysStoppedAnimation(120 / 360),
                    child: Image.asset("assets/icons/red_arrow_up.png"),
                  ),
                ),
                InvocScoreWidget("e", false),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Text(
                underlyingCategoryKey.tr,
                maxLines: 3,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w100),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RowTextWidget(title: novaKey.tr, description: novaTextKey.tr),
            SizedBox(
              height: 20,
            ),
            RowTextWidget(
                title: additiveKey.tr, description: additiveTextKey.tr),
            SizedBox(
              height: 20,
            ),
            Container(
              //width: MediaQuery.of(context).size.width * .15,
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
              child: Center(
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: "16",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                        fontFamily: 'GilroyBold',
                        fontSize: 16,
                        height: 1,
                        color: color,
                      ),
                    ),
                    TextSpan(
                      text: thKey.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                        fontFamily: 'GilroyBold',
                        fontSize: 12,
                        height: 1,
                        color: color,
                      ),
                    ),
                  ]),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: Get.height * 0.04,
              child: Image.asset("assets/icons/red_arrow_down1.png"),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                invocBenchmarkKey.tr,
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w100),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 80,
              child: Center(
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: ImageHelper().guideImages.length,
                    itemBuilder: (context, i) => Center(
                          child: Container(
                            margin: EdgeInsets.all(8),
                            height: 80,
                            width: 67,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                image: DecorationImage(
                                  image:
                                      AssetImage(ImageHelper().guideImages[i]),
                                  fit: BoxFit.contain,
                                )),
                          ),
                        )),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 30,
                  width: 200,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      // color: Color(0x123C285C),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        nutrients100gKey.tr,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontFamily: 'GilroyBold',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: const Color(0xff3C285C),
                          // color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      Get.height * 0.005,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.expand_more,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  // color: Colors.red,
                  width: Get.width * 0.65,
                  child: Text(
                    nutrientsTextKey.tr,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w100),
                  ),
                ),
                Container(
                  height: Get.height * 0.06,
                  width: Get.width * 0.2,
                  child: RotationTransition(
                    turns: new AlwaysStoppedAnimation(340 / 360),
                    child: Image.asset("assets/icons/red_arrow_up.png",
                        fit: BoxFit.fitWidth),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
