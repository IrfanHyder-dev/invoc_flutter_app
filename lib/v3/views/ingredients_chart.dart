import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoc/api/model/firestore_product.dart';
import 'package:invoc/main.dart';

class IngredientChart extends StatelessWidget {
  FirestoreProduct? product;

  IngredientChart(this.product);

  final Color barBackgroundColor = const Color(0xff72d8bf);
  int? touchedIndex;
  List<BarChartGroupData> bars = <BarChartGroupData>[];
  List<String> names = <String>[];
  List<String> values = <String>[];
  List<Map<String, double>> nutrimentsList = [];

  void initState() {
    makeNutrimentsList();
  }

  void makeNutrimentsList() {
    if (product!.nutriments != null) {
      final Nutriments nutriments = product!.nutriments!;
      nutriments.toJson().forEach((key, value) {
        if (value != null &&
            key != 'energy_100g' &&
            key != 'energy-kcal_value') {
          String nutrimentName = (key == 'saturated-fat') ? 'fat(Sat)' : key;
          nutrimentsList.add({nutrimentName: value});
        }
      });
      nutrimentsList.sort((a, b) => a.keys.first.compareTo(b.keys.first));
    }
  }

  @override
  Widget build(BuildContext context) {
    makeNutrimentsList();
    if (product!.nutriments == null) {
      return Container();
    }

    processData();

    return AspectRatio(
      aspectRatio: 3.0,
      child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Container(
            width: Get.width,
            child: Center(
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: NeverScrollableScrollPhysics(),
                itemCount: nutrimentsList.length,
                itemBuilder: (context, index) {
                  Map<String, double> mapData = nutrimentsList[index];
                  String keyAtIndex = mapData.keys.first;
                  double? valueAtIndex = mapData[keyAtIndex];
                  return ingredientWidget(
                      nutrimentName: keyAtIndex, nutrimentValue: valueAtIndex!);
                },
                separatorBuilder: (context, index) => SizedBox(
                  width: 14,
                ),
              ),
            ),
          )),
    );
  }

  Column ingredientWidget({String? nutrimentName, double? nutrimentValue}) {
    return Column(
      children: [
        Container(
            width: 35,
            alignment: Alignment.center,
            child: Text('${nutrimentValue!.toStringAsFixed(2)}')),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 20,
          width: 20,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: Container(
            margin: EdgeInsets.all(4),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorRange(
                    nutrimentValue: nutrimentValue,
                    nutrimentName: nutrimentName!)),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(nutrimentName.capitalizeFirst!),
      ],
    );
  }

  Color colorRange({String? nutrimentName, double? nutrimentValue}) {
    switch (nutrimentName) {
      case 'fiber':
        {
          {
            if (nutrimentValue! <= 20) {
              return Colors.amber;
            } else if (nutrimentValue > 20) {
              return Colors.green;
            }
          }
        }
        break;
      case 'salt':
        {
          if (nutrimentValue! <= 0.3) {
            return Colors.green;
          } else if (nutrimentValue > 0.3 && nutrimentValue <= 1.5) {
            return Colors.amber;
          } else if (nutrimentValue > 1.5) {
            return Colors.red;
          }
        }
        break;
      case 'proteins':
        {
          if (nutrimentValue! <= 20) {
            return Colors.amber;
          } else if (nutrimentValue > 20) {
            return Colors.green;
          }
        }
        break;
      case 'sugars':
        {
          if (nutrimentValue! <= 5) {
            return Colors.green;
          } else if (nutrimentValue > 5 && nutrimentValue <= 22.5) {
            return Colors.amber;
          } else if (nutrimentValue > 22.5) {
            return Colors.red;
          }
        }
        break;
      case 'fat(Sat)':
        {
          if (nutrimentValue! <= 1.5) {
            return Colors.green;
          } else if (nutrimentValue > 1.5 && nutrimentValue <= 5) {
            return Colors.amber;
          } else if (nutrimentValue > 5) {
            return Colors.red;
          }
        }
        break;
      case 'fat':
        {
          if (nutrimentValue! <= 3) {
            return Colors.green;
          } else if (nutrimentValue > 3 && nutrimentValue <= 17.5) {
            return Colors.amber;
          } else if (nutrimentValue > 17.5) {
            return Colors.red;
          }
        }
        break;
      default:
        return Colors.transparent;
    }
    return Colors.transparent;
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 8,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: isTouched ? [Colors.yellow] : [barColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 100,
            colors: [Colors.white],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
      barsSpace: 0,
    );
  }

  List<BarChartGroupData>? processData() {
    int index = 0;
    Nutriments nutriments = product!.nutriments!;
    if (nutriments.fat != null) {
      bars.add(makeGroupData(index, nutriments.fat!,
          isTouched: index == touchedIndex,
          barColor: HexColor(getGToR(nutriments.fat ?? 0.0))));
      names.add('Fat');
      values.add(nutriments.fat!.toStringAsPrecision(2));
      index++;
    }

    if (nutriments.saturatedFat != null) {
      bars.add(makeGroupData(index, nutriments.saturatedFat!,
          isTouched: index == touchedIndex,
          barColor: HexColor(getGToR(nutriments.saturatedFat ?? 0.0))));
      names.add('Sat.Fat');
      values.add(nutriments.saturatedFat!.toStringAsPrecision(2));
      index++;
    }

    if (nutriments.sugars != null) {
      bars.add(makeGroupData(index, nutriments.sugars!,
          isTouched: index == touchedIndex,
          barColor: HexColor(getGToR(nutriments.sugars ?? 0.0))));
      names.add('Sugar');
      values.add(nutriments.sugars!.toStringAsPrecision(2));
      index++;
    }

    if (nutriments.salt != null) {
      bars.add(makeGroupData(index, nutriments.salt!,
          isTouched: index == touchedIndex,
          barColor: HexColor(getGToR(nutriments.salt!))));
      names.add('Salt');
      values.add(nutriments.salt!.toStringAsPrecision(2));

      index++;
    }

    if (nutriments.fiber != null) {
      bars.add(makeGroupData(index, nutriments.fiber!,
          isTouched: index == touchedIndex,
          barColor: HexColor(getRToG(nutriments.fiber!))));
      // barColor: HexColor(getColor('low'))));
      names.add('Fiber');
      values.add(nutriments.fiber!.toStringAsPrecision(2));

      index++;
    }

    if (nutriments.proteins != null) {
      bars.add(makeGroupData(index, nutriments.proteins!,
          isTouched: index == touchedIndex,
          barColor: HexColor(getRToG(nutriments.proteins!))));
      // barColor: HexColor(getColor('low'))));
      names.add('Proteins');
      values.add(nutriments.proteins!.toStringAsPrecision(2));
      index++;
    }
  }

  double? getMaxValue(double value) {
    if (value > 15) {
      return 15;
    }
  }

  BarChartData mainBarData() {
    return BarChartData(
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
              fitInsideVertically: true,
              tooltipBgColor: Colors.blueGrey,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String weekDay = names[rodIndex];
                return BarTooltipItem(
                    weekDay + '\n' + (rod.y - 1).toString(),
                    TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w100,
                        fontSize: 10,
                        fontFamily: 'Gilroy'));
              }),
          touchCallback: (barTouchResponse) {},
        ),
        titlesData: FlTitlesData(
          show: true,
          topTitles: SideTitles(
            showTitles: true,
            getTextStyles: (context, value) => getTopTitleStyle(),
            // (value) =>
            margin: 8,
            getTitles: (double value) {
              return values[value.toInt()];
            },
          ),
          bottomTitles: SideTitles(
            showTitles: true,
            getTextStyles: (context, value) => getBottomStyle(),
            margin: 8,
            getTitles: (double value) {
              print(names[value.toInt()] + ": " + values[value.toInt()]);
              return names[value.toInt()];
            },
          ),
          leftTitles: SideTitles(
            showTitles: false,
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: bars,
        alignment: BarChartAlignment.center,
        groupsSpace: 48,
        maxY: 100,
        minY: 0);
  }

  String getColor(String name) {
    switch (name) {
      case 'low':
        return '#8FD96E';
      case 'moderate':
        return '#EBDB15';
      case 'high':
        return '#EB1549';
        default:return '';
    }
  }

  String getGToR(double nutrientValue) {
    if (nutrientValue <= 35.0) {
      return '#8FD96E';
    } else if (nutrientValue > 35.0 && nutrientValue <= 70.0) {
      return '#EBDB15';
    } else if (nutrientValue > 70.0 && nutrientValue <= 100.0) {
      return 'EB1549';
    }else{
      return '';
    }
  }

  String getRToG(double nutrientValue) {
    if (nutrientValue <= 35.0) {
      return '#EB1549';
    } else if (nutrientValue > 35.0 && nutrientValue <= 70.0) {
      return '#EBDB15';
    } else if (nutrientValue > 70.0 && nutrientValue <= 100.0) {
      return '#8FD96E';
    }
    else{
      return '';
    }
  }

  String getColorOfBar(int name) {
    switch (name) {
      case 0:
        return '#8FD96E';
      case 1:
        return '#8FD96E';
      case 2:
        return '#EBDB15';
      case 3:
        return '#8FD96E';
      case 4:
        return '#EB1549';
      case 5:
        return '#8FD96E';
      default:
        return '';
    }
  }

  getTopTitleStyle() {
    return TextStyle(
        color: Color(0XFF3C285C),
        fontWeight: FontWeight.w100,
        fontSize: 12,
        fontFamily: 'Gilroy');
  }

  getBottomStyle() {
    return TextStyle(
        color: Color(0XFF3C285C),
        fontWeight: FontWeight.w100,
        fontSize: 12,
        fontFamily: 'Gilroy');
  }
}
