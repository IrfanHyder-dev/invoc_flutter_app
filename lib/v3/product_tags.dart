import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoc/api/model/firestore_product.dart';
import 'package:invoc/src/language/language_keys.dart';
import 'package:invoc/utils/invoc_app_theme.dart';
import 'package:invoc/v3/notifier/filter_notifier.dart';
import 'package:provider/provider.dart';

class ProductTags extends StatefulWidget {
  FirestoreProduct firestoreProduct;

  ProductTags(this.firestoreProduct);

  @override
  ProductTagsState createState() => ProductTagsState();
}

class ProductTagsState extends State<ProductTags>
    with TickerProviderStateMixin {
  List<ProductTag> tags = <ProductTag>[];


  ProductTag? generateProductTag(String value) {
    switch (value) {
      case 'en:palm-oil':
        return ProductTag(
            value, palmOilKey.tr, InvocAppTheme.tagNegativeColor, -1);
        break;
      case 'en:palm-oil-free':
        return ProductTag(
            value, palmOilFreeKey.tr, InvocAppTheme.tagPositiveColor, 0);
        break;
      case 'en:green-dot':
        return ProductTag(
            value, vegetarianKey.tr, InvocAppTheme.tagPositiveColor, 0);
        break;
      case 'en:non-vegan':
        return ProductTag(
            value, nonVeganKey.tr, InvocAppTheme.tagNegativeColor, -1);
        break;
      case 'en:vegetarian':
        return ProductTag(
            value, vegetarianKey.tr, InvocAppTheme.tagPositiveColor, 0);
        break;
      case 'en:non-vegetarian':
        return ProductTag(
            value, nonVeganKey.tr, InvocAppTheme.tagNegativeColor, -1);
        break;
      case 'en:vegan':
        return ProductTag(
            value, veganKey.tr, InvocAppTheme.tagPositiveColor, 0);
        break;
      case 'en:no-lactose':
        return ProductTag(
            value, lactoseFreeKey.tr, InvocAppTheme.tagPositiveColor, 0);
        break;
      case 'en:no-milk':
        return ProductTag(
            value, noMilkKey.tr, InvocAppTheme.tagPositiveColor, 0);
        break;
      case 'en:no-preservatives':
        return ProductTag(
            value, noPreservativesKey.tr, InvocAppTheme.tagPositiveColor, 0);
        break;
      //allergen
      case 'en:gluten':
        return ProductTag(
            value, glutenKey.tr, InvocAppTheme.tagNegativeColor, -1);
        break;
      case 'en:nuts':
        return ProductTag(
            value, nutsKey.tr, InvocAppTheme.tagNegativeColor, -1);
        break;
      case 'en:soybeans':
        return ProductTag(
            value, soybeansKey.tr, InvocAppTheme.tagNegativeColor, -1);
        break;
      case 'en:milk':
        return ProductTag(
            value, milkKey.tr, InvocAppTheme.tagNegativeColor, -1);
        break;
      case 'en:celery':
        return ProductTag(
            value, celeryKey.tr, InvocAppTheme.tagNegativeColor, -1);
        break;
      case 'en:egg':
        return ProductTag(value, eggKey.tr, InvocAppTheme.tagNegativeColor, -1);
        break;
      default:
        return null;
    }
  }

  @override
  void initState() {
    super.initState();
    print('product page 3 ${widget.firestoreProduct.labelTags}');
    if (widget.firestoreProduct.labelTags != null) {
      widget.firestoreProduct.labelTags!.forEach((labelTag) {
        ProductTag? tag = generateProductTag(labelTag);
        if(tag != null){
          tags.add(tag);
        }
      });
    }
    if (widget.firestoreProduct.allergensTags != null) {
      widget.firestoreProduct.allergensTags!.forEach((allergenTag) {
        ProductTag? tag = generateProductTag(allergenTag);
        if(tag != null){
          tags.add(tag);
        }
      });
    }

    //remove null
    tags.removeWhere((element) => element == null);

    //sort  by type
    tags.sort((a, b) => b.type.compareTo(a.type));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 4, left: 16, right: 12),
        child: Wrap(
          spacing: 10.0,
          runSpacing: 0,
          children: List<Widget>.generate(tags.length, (int index) {
            return
              ChoiceChip(
              label: Text(tags[index].name),
              selected: false,
              // labelPadding: const EdgeInsets.only(
              //     left: 5, right: 5,
              //     top: 0, bottom: 0
              // ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: BorderSide(color: Colors.transparent)),
              labelStyle: TextStyle(
                  fontSize: 12,
                  height: 1,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Gilroy'),
              backgroundColor: tags[index].color,
              onSelected: (bool selected) {
                // notify the provider
                Provider.of<FilterNotifier>(context, listen: false)
                    .setFilterKey(tags[index].originalValue);

              },
                            );
          }),
        ));
  }
}

class ProductTag {
  String originalValue;
  String name;
  Color color;
  int type;

  ProductTag(this.originalValue, this.name, this.color, this.type);
}
