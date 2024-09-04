import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:invoc/api/model/firestore_cluster_product.dart';
import 'package:invoc/v3/alternative_listing.dart';
import 'package:invoc/v3/product_header_v3.dart';

class ProductDetails extends StatefulWidget {
  final FirestoreClusterAndProduct? clusterAndProduct;

  const ProductDetails({ this.clusterAndProduct});

  @override
  ProductDetailState createState() => ProductDetailState();
}

class ProductDetailState extends State<ProductDetails>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 38),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 12.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.string(
                _svg_ch6q9d,
                allowDrawingOutsideViewBox: true,
                fit: BoxFit.fill,
              )
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Flexible(
            child: ListView(
              children: <Widget>[
                ProductNormalHeader(
                  product: widget.clusterAndProduct!.product,
                  hideName: false,
                ),
                Material(child: AlternativeListing(widget.clusterAndProduct!)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  var radius = 10.0;

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.arcToPoint(Offset(size.width, size.height),
        radius: Radius.elliptical(30, 10));
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

const String _svg_ch6q9d =
    '<svg viewBox="132.5 488.5 117.0 1.0" ><path transform="translate(132.5, 488.5)" d="M 0 0 L 117 0" fill="none" fill-opacity="0.12" stroke="#0b22d1" stroke-width="4" stroke-opacity="0.12" stroke-miterlimit="4" stroke-linecap="round" /></svg>';
