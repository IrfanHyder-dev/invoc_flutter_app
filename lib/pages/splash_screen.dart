import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:invoc/main.dart';
import 'package:invoc/utils/InvocNavigator.dart';
import 'package:invoc/v3/auth/constants/enums.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
@override
  void initState(){
    super.initState();
    moveToNextScreen();
  }

  void moveToNextScreen(){
    Future.delayed(Duration(seconds: 5)).then((_) {

      InvocNavigator.goToHome(Get.context!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        padding: EdgeInsets.only(left: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                // height: 100,
                // width: 250,

                child: SvgPicture.asset('assets/images/top_image.svg',width: 280),
              ),
            ),

            // SizedBox(
            //   height: 10,
            // ),
            Row(
              children: [
                SizedBox(
                    // height: 50,
                    // width: 45,
                    child:(GlobalVariables.userRole == UserRole.user)
                        ?Image.asset('assets/images/apple_smile_small_appbar.png',width: 45,height: 60,)
                        :Image.asset('assets/images/admin_launcer_icon_2.jpg',width: 45,)
      ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'InVoc',
                  style: TextStyle(
                    fontSize: 42,
                    color: Colors.black,
                    fontFamily: 'poppins_regular',
                  ),
                ),
              ],
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Scan",
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Color(0XFF4A148C),
                      fontFamily: 'poppins_regular',
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "&",
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w300,
                          color: Color(0XFF4A148C),
                          fontFamily: 'poppins_regular',
                        ),
                      ),
                      Text(
                        " Compare",
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Color(0XFF4A148C),
                          fontFamily: 'poppins_regular',
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Your food",
                    style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w300,
                        color: Color(0XFF4A148C),
                        fontFamily: 'poppins_regular',
                        height: 0),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  // Expanded(
                  //   child: Container(
                  //     height: 150,
                  //     child: Stack(
                  //       alignment: Alignment.bottomRight,
                  //       children: [
                  //         SizedBox(
                  //             height: 110,
                  //             width: 120,
                  //             child: SvgPicture.asset(
                  //                 'assets/images/green_background.svg')),
                  //         Image.asset(
                  //           'assets/images/a.png',
                  //           width: 100,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),


                  Container(
                      // height: 100,
                      width: 115,
                      // color: Colors.green,
                      child: Image.asset('assets/images/image_green_bottle.png')),
                  Container(
                    height: 40,
                    width: 40,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.white,boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1),spreadRadius: 5,blurRadius: 5)]),
                    child: Center(child: Text('VS',style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Color(0XFF4A148C),fontFamily: 'poppins_regular',) ,)),
                  ),
                  Container(
                    // height: 100,
                      width: 115,
                      // color: Colors.green,
                      child: Image.asset('assets/images/image_pink_bottle.png')),

                  // Expanded(
                  //   child: Container(
                  //     height: 150,
                  //     child: Stack(
                  //       alignment: Alignment.topLeft,
                  //       children: [
                  //         Center(
                  //             child: SvgPicture.asset(
                  //           'assets/images/skin_background.svg',
                  //           width: 120,
                  //           height: 110,
                  //         )),
                  //         Container(
                  //             margin: EdgeInsets.only(top: 20),
                  //             child: Image.asset('assets/images/b.png')),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  // Spacer(),
                  // Container(
                  //   height: 40,
                  //   width: 40,
                  //   decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.white,boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1),spreadRadius: 5,blurRadius: 5)]),
                  //   child: Center(child: Text('VS',style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Color(0XFF4A148C),fontFamily: 'poppins_regular',) ,)),
                  //
                  // ),
                  // Spacer(),
                  // Stack(children: [
                  //   SizedBox(
                  //       height: 110,
                  //       width: 120,
                  //       child: SvgPicture.asset('assets/images/skin_background.svg')),
                  //   Positioned(
                  //     right: 0,
                  //     top: 0,
                  //     left: 0,
                  //     bottom: 10,
                  //     //   left: 0,
                  //     child:
                  //     // SvgPicture.asset('assets/images/a.svg'),
                  //     SizedBox(
                  //       // height: 170,
                  //       //   width: 170,
                  //         child: Image.asset('assets/images/b.png',)),
                  //   ),
                  // ],)
                ],
              ),
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
