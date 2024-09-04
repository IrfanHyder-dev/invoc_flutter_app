import 'package:flutter/material.dart';
import 'package:invoc/utils/invoc_app_theme.dart';
import 'package:shimmer/shimmer.dart';

class ProductShimmerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 160,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
        child: Container(
          decoration: BoxDecoration(
            color: InvocAppTheme.white,
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
            child: Row(children: <Widget>[
              SizedBox(
                width: 110,
                child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  enabled: true,
                                  child: Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: InvocAppTheme.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                  ),
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    enabled: true,
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      color: Colors.white,
                                    )),
                                SizedBox(
                                  width: 16,
                                ),
                                Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    enabled: true,
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      color: Colors.white,
                                    )),
                              ],
                            ),
                          ]), //Your widget here,
                    )),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 24,
                      color: Colors.white,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                          top: 4,
                        ),
                        child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            enabled: true,
                            child: Container(
                              width: 150,
                              height: 20,
                              color: Colors.white,
                            ))),
                    Padding(
                        padding: const EdgeInsets.only(
                          top: 4,
                        ),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          enabled: true,
                          child: Container(
                            width: 80,
                            height: 20,
                            color: Colors.white,
                          ),
                        )),
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
