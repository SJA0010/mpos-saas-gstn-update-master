import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../Provider/product_provider.dart';
import '../../model/product_model.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/Constant Data/export_button.dart';
import '../Widgets/no_data_found.dart';

class CurrentStockWidget extends StatefulWidget {
  const CurrentStockWidget({Key? key, required this.search}) : super(key: key);
  final String search;

  @override
  State<CurrentStockWidget> createState() => _CurrentStockWidgetState();
}

class _CurrentStockWidgetState extends State<CurrentStockWidget> {
  List<int> item = [
    10,
    20,
    30,
    50,
    80,
    100,
  ];
  int selectedItem = 10;
  int itemCount = 10;

  DropdownButton<int> selectItem() {
    List<DropdownMenuItem<int>> dropDownItems = [];
    for (int des in item) {
      var item = DropdownMenuItem(
        value: des,
        child: Text('${des.toString()} items'),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      items: dropDownItems,
      value: selectedItem,
      onChanged: (value) {
        setState(() {
          selectedItem = value!;
          itemCount = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, __) {
        AsyncValue<List<ProductModel>> stockData = ref.watch(productProvider);
        return stockData.when(data: (stock) {
          List<ProductModel> stockData = [];
          for (var element in stock) {
            if (widget.search != '' && (element.productName.contains(widget.search) || element.productName.contains(widget.search))) {
              stockData.add(element);
            } else if (widget.search == '') {
              stockData.add(element);
            }
          }
          return Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: kWhiteTextColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        lang.S.of(context).stockReport,
                        style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          Text(
                            lang.S.of(context).show,
                            style: kTextStyle.copyWith(color: kTitleColor),
                          ),
                          const SizedBox(width: 5.0),
                          SizedBox(
                            width: 110.0,
                            height: 40,
                            child: FormField(
                              builder: (FormFieldState<dynamic> field) {
                                return InputDecorator(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(color: kGreyTextColor),
                                    ),
                                    contentPadding: const EdgeInsets.only(left: 10.0, right: 4.0),
                                    floatingLabelBehavior: FloatingLabelBehavior.never,
                                  ),
                                  child: DropdownButtonHideUnderline(child: selectItem()),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          Container(
                            height: 40.0,
                            width: 300,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: kGreyTextColor.withOpacity(0.1))),
                            child: AppTextField(
                              showCursor: true,
                              cursorColor: kTitleColor,
                              textFieldType: TextFieldType.NAME,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(10.0),
                                hintText: (lang.S.of(context).search),
                                hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                border: InputBorder.none,
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                      padding: const EdgeInsets.all(2.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.0),
                                        color: kGreyTextColor.withOpacity(0.1),
                                      ),
                                      child: const Icon(
                                        FeatherIcons.search,
                                        color: kTitleColor,
                                      )),
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          const ExportButton2(),
                        ],
                      ).visible(false),
                      // const SizedBox(height: 20.0),
                      stockData.isNotEmpty
                          ? SizedBox(
                              width: double.infinity,
                              child: DataTable(
                                headingRowColor: MaterialStateProperty.all(kLitGreyColor),
                                showBottomBorder: false,
                                columnSpacing: 0.0,
                                columns: [
                                  DataColumn(
                                    label: Text(
                                      'S.L',
                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(lang.S.of(context).PRODUCTNAME, style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      lang.S.of(context).CATEGORY,
                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(lang.S.of(context).PRICE, style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                                  ),
                                  DataColumn(
                                    label: Text(lang.S.of(context).QTY, style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                                  ),
                                  DataColumn(
                                    label: Text(lang.S.of(context).STATUS, style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                                  ),
                                  DataColumn(
                                    label: Text(lang.S.of(context).TOTALVALUE, style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                                  ),
                                  // const DataColumn(
                                  //   label: Icon(FeatherIcons.settings, color: kGreyTextColor),
                                  // ),
                                ],
                                rows: List.generate(
                                  stockData.length,
                                  (index) => DataRow(
                                    selected: true,
                                    cells: [
                                      DataCell(
                                        Text((index + 1).toString()),
                                      ),
                                      DataCell(
                                        GestureDetector(
                                          onTap: () {},
                                          child: SizedBox(
                                            width: 180,
                                            child: Text(
                                              stockData[index].productName,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: kTextStyle.copyWith(color: kGreyTextColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        GestureDetector(
                                          onTap: () {},
                                          child: SizedBox(
                                            width: 100,
                                            child: Text(
                                              stockData[index].productCategory,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: kTextStyle.copyWith(color: kGreyTextColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        GestureDetector(
                                          onTap: () {},
                                          child: Text(
                                            stockData[index].productSalePrice,
                                            style: kTextStyle.copyWith(color: kGreyTextColor),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        GestureDetector(
                                          onTap: () {},
                                          child: Text(
                                            stockData[index].productStock,
                                            style: kTextStyle.copyWith(color: kGreyTextColor),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        GestureDetector(
                                            onTap: () {},
                                            child: Text(stockData[index].productStock.toString().toInt() < 50 ? 'Low' : 'High',
                                                style: kTextStyle.copyWith(
                                                  color: stockData[index].productStock.toInt() < 50 ? Colors.red : kGreyTextColor,
                                                ))),
                                      ),
                                      DataCell(
                                        GestureDetector(
                                            onTap: () {},
                                            child: Text((stockData[index].productSalePrice.toInt() * stockData[index].productStock.toInt()).toString(),
                                                style: kTextStyle.copyWith(color: kGreyTextColor))),
                                      ),
                                      // DataCell(
                                      //   PopupMenuButton(
                                      //     icon: const Icon(FeatherIcons.moreVertical, size: 18.0),
                                      //     padding: EdgeInsets.zero,
                                      //     itemBuilder: (BuildContext bc) => [
                                      //       PopupMenuItem(
                                      //         child: GestureDetector(
                                      //           onTap: () {},
                                      //           child: Row(
                                      //             children: [
                                      //               const Icon(MdiIcons.printer, size: 18.0, color: kTitleColor),
                                      //               const SizedBox(width: 4.0),
                                      //               Text(
                                      //                 'Print',
                                      //                 style: kTextStyle.copyWith(color: kTitleColor),
                                      //               ),
                                      //             ],
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ],
                                      //     onSelected: (value) {
                                      //       Navigator.pushNamed(context, '$value');
                                      //     },
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : noDataFoundImage(text: lang.S.of(context).noReportFound),
                    ],
                  ),
                )
              ],
            ),
          );
        }, error: (e, stack) {
          return Center(
            child: Text(e.toString()),
          );
        }, loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
      },
    );
  }
}
