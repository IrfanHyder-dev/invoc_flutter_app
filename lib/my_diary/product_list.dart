import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:invoc/api/InvocAPIClient.dart';
import 'package:invoc/api/model/parameter/SearchEnum.dart';
import 'package:invoc/api/utils/ProductQueryConfigurations.dart';
import 'package:invoc/my_diary/staggered_product_item.dart';
import 'package:invoc/pages/product_detail_page.dart';
import 'package:invoc/ui_view/product_shimmer_view.dart';
import 'package:invoc/utils/invoc_app_theme.dart';
import 'package:invoc/v2/alternative/details_screen.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class ProductList extends StatefulWidget {
  final Animation<dynamic>? mainScreenAnimation;
  final String? productCode;
  final SearchType? searchType;

  const ProductList(
      {this.mainScreenAnimation, this.productCode, this.searchType});

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  int? page;

  @override
  void initState() {
    page = 0;
    _controller = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  Widget buildShimmerList() {
    return ListView.builder(
        itemCount: 4,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemBuilder: (_, __) => ProductShimmerView());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: getFuture(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Product>? data = snapshot.data;

          if (data!.isEmpty) {
            return _buildErrorOrEmptyContainer();
          } else {
            return Container(child: _buildStaggeredGrid(data));
          }
        } else if (snapshot.hasError) {
          return _buildErrorOrEmptyContainer();
        }
        return buildShimmerList();
      },
    );
  }

  String getErrorMessage() {
    var errorMessage;
    switch (widget.searchType) {
      case SearchType.ALTERNATIVE:
        errorMessage =
            'Invoc is assesing the alternative... \n Soon will be available ';
        break;
      case SearchType.EAN:
        errorMessage = 'Wow, you won, Invoc is still learning';
        break;
      case SearchType.BRAND:
        errorMessage = 'Wow, you won, Invoc is still learning';
        break;
      case SearchType.BASKET:
        errorMessage = 'Basket is empty... ';
        break;
      case SearchType.UNDEFINED:
        errorMessage = 'Wow, you won, Invoc is still learning';
        break;
    }
    return errorMessage;
  }

  Future<List<Product>> getFuture() {
    var future;
    switch (widget.searchType) {
      case SearchType.ALTERNATIVE:
        future = InvocAPIClient.getAlternativeProducts(widget.productCode!);
        break;
      case SearchType.EAN:
        future = InvocAPIClient.getCategoryProducts(widget.productCode!, 'ean');
        break;
      case SearchType.BRAND:
        future =
            InvocAPIClient.getCategoryProducts(widget.productCode!, 'brand');
        break;
      case SearchType.BASKET:
        future = InvocAPIClient.getBasketProducts(widget.productCode!);
        break;
      case SearchType.UNDEFINED:
        future = InvocAPIClient.getSearchProducts(widget.productCode!);
        break;
    }
    return future;
  }

  Widget _buildErrorOrEmptyContainer() {
    return Container(
      margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Center(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              getErrorMessage(),
              style: TextStyle(
                fontFamily: InvocAppTheme.fontName,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 0.2,
                color: InvocAppTheme.dark_grey,
              ),
              textAlign: TextAlign.center,
            )),
      ),
    );
  }

  Widget _buildStaggeredGrid(List<Product> products) {

    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      crossAxisCount: 4,
      itemCount: products.length,
      physics: ClampingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        final int count = products.length;
        final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(
                parent: _controller!,
                curve: Interval((1 / count) * index, 1.0,
                    curve: Curves.fastOutSlowIn)));
        _controller!.forward();
        return InkWell(
          child:
              StaggeredProductItemView(products[index], _controller!, animation),
          onTap: () {
            _loadProductDetails(products[index].barcode!);
          },
        );
      },
      staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  _loadProductDetails(String productCode) async {
    //show loader
    ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.normal, isDismissible: true, showLogs: true);
    pr.style(progressWidget: CircularProgressIndicator());
    pr.show();

    await InvocAPIClient.getProduct(ProductQueryConfiguration(productCode))
        .then((product) {
      pr.hide();
      if (widget.searchType == SearchType.ALTERNATIVE) {
        //load alternative screen
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DetailsScreen()));
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ProductDetailPage(product: product, slideDown: (){})),
        );
      }
    }).catchError((Object _error) {
      pr.hide();
    });
  }
}
