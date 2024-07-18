import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Provider/product_provider.dart';
import 'package:salespro_admin/Screen/Product/tablet_add_product.dart';
import 'package:salespro_admin/model/product_model.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../currency.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/Sidebar/sidebar_widget.dart';
import '../Widgets/TopBar/top_bar_widget.dart';

class TabletProductScreen extends StatefulWidget {
  const TabletProductScreen({Key? key}) : super(key: key);

  static const String route = '/mProduct';

  @override
  State<TabletProductScreen> createState() => _TabletProductScreenState();
}

class _TabletProductScreenState extends State<TabletProductScreen> {
  List<int> item = [
    10,
    20,
    30,
    50,
    80,
    100,
  ];
  List<String> itemName = [
    'Cotton Full Pant',
    'Cotton Long Sleeve T-shirt',
    'Female Scarf',
    'Cotton Black T-shirt',
    'Jeans Short Pant',
  ];
  List<String> quantityList = [
    '740',
    '324',
    '-567',
    '957',
    '854',
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

  List<String> catrgoryList = [
    'S.L',
    'Product NAME',
    'Category',
    'Brand',
    'QUANTITY',
    'PRICE/UNIT',
    'STATUS',
  ];
  List<String> catrgoryData = [
    '',
    'Apple Watch',
    'Electronics',
    'Apple',
    '100',
    '${currency}5.99/Piece',
    'Published',
  ];

  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkWhite,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: false,
        title: Text(
          lang.S.of(context).counterSale,
          style: kTextStyle.copyWith(color: kTitleColor),
        ),
        iconTheme: const IconThemeData(color: kTitleColor),
        actions: const [Center(child: TopBarTablate())],
      ),
      drawer: const Drawer(
        child: SideBarWidget(
          index: 3,
          isTab: true,
        ),
      ),
      body: Consumer(builder: (_, ref, watch) {
        AsyncValue<List<ProductModel>> productList = ref.watch(productProvider);
        return productList.when(data: (product) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: kWhiteTextColor),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              lang.S.of(context).productList,
                              style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kBlueTextColor),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kBlueTextColor),
                                child: Row(
                                  children: [
                                    const Icon(FeatherIcons.plus, color: kWhiteTextColor, size: 18.0),
                                    const SizedBox(width: 5.0),
                                    Text(
                                      lang.S.of(context).add,
                                      style: kTextStyle.copyWith(color: kWhiteTextColor),
                                    ),
                                  ],
                                ),
                              ),
                            ).onTap(
                              () => Navigator.of(context).pushNamed(TabletAddProduct.route),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        Divider(
                          thickness: 1.0,
                          color: kGreyTextColor.withOpacity(0.2),
                        ),
                        const SizedBox(height: 20.0),
                        // Row(
                        //   children: [
                        //     Text(
                        //       'Show:',
                        //       style: kTextStyle.copyWith(color: kTitleColor),
                        //     ),
                        //     const SizedBox(width: 5.0),
                        //     SizedBox(
                        //       width: 110.0,
                        //       height: 40,
                        //       child: FormField(
                        //         builder: (FormFieldState<dynamic> field) {
                        //           return InputDecorator(
                        //             decoration: InputDecoration(
                        //               border: OutlineInputBorder(
                        //                 borderRadius: BorderRadius.circular(10.0),
                        //                 borderSide: const BorderSide(color: kGreyTextColor),
                        //               ),
                        //               contentPadding: const EdgeInsets.only(left: 10.0, right: 4.0),
                        //               floatingLabelBehavior: FloatingLabelBehavior.never,
                        //             ),
                        //             child: DropdownButtonHideUnderline(child: selectItem()),
                        //           );
                        //         },
                        //       ),
                        //     ),
                        //     const Spacer(),
                        //     Container(
                        //       height: 40.0,
                        //       width: 300,
                        //       decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: kGreyTextColor)),
                        //       child: Center(
                        //         child: AppTextField(
                        //           showCursor: true,
                        //           cursorColor: kTitleColor,
                        //           textFieldType: TextFieldType.NAME,
                        //           decoration: InputDecoration(
                        //             contentPadding: const EdgeInsets.all(10.0),
                        //             hintText: ('Search Customer'),
                        //             hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                        //             border: InputBorder.none,
                        //             suffixIcon: Padding(
                        //               padding: const EdgeInsets.all(4.0),
                        //               child: Container(
                        //                   padding: const EdgeInsets.all(2.0),
                        //                   decoration: BoxDecoration(
                        //                     borderRadius: BorderRadius.circular(10.0),
                        //                     color: kGreyTextColor.withOpacity(0.2),
                        //                   ),
                        //                   child: const Icon(
                        //                     FeatherIcons.search,
                        //                     color: kTitleColor,
                        //                   )),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // const SizedBox(height: 20.0),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                              headingRowColor: MaterialStateProperty.all(kLitGreyColor),
                              showBottomBorder: false,
                              columns: [
                                DataColumn(
                                  label: Text(
                                    'S.L.',
                                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(lang.S.of(context).productName, style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                                ),
                                DataColumn(
                                  label: Text(lang.S.of(context).category, style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                                ),
                                DataColumn(
                                  label: Text(lang.S.of(context).brand, style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                                ),
                                DataColumn(
                                  label: Text(lang.S.of(context).quantity, style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                                ),
                                DataColumn(
                                  label: Text(lang.S.of(context).priceorUnit, style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                                ),
                                DataColumn(
                                  label: Text(lang.S.of(context).status, style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold)),
                                ),
                                const DataColumn(
                                  label: Icon(FeatherIcons.settings, color: kGreyTextColor),
                                ),
                              ],
                              rows: List.generate(
                                  product.length,
                                  (index) => DataRow(cells: [
                                        DataCell(
                                          Text((index + 1).toString()),
                                        ),
                                        DataCell(
                                          Text(product[index].productName, style: kTextStyle.copyWith(color: kGreyTextColor)),
                                        ),
                                        DataCell(
                                          Text(product[index].productCategory, style: kTextStyle.copyWith(color: kGreyTextColor)),
                                        ),
                                        DataCell(
                                          Text(product[index].brandName, style: kTextStyle.copyWith(color: kGreyTextColor)),
                                        ),
                                        DataCell(
                                          Text(product[index].productStock, style: kTextStyle.copyWith(color: kGreyTextColor)),
                                        ),
                                        DataCell(
                                          Text('$currency${product[index].productSalePrice}/${product[index].productUnit}',
                                              style: kTextStyle.copyWith(color: kGreyTextColor)),
                                        ),
                                        DataCell(
                                          Text('Published', style: kTextStyle.copyWith(color: kGreyTextColor)),
                                        ),
                                        DataCell(
                                          PopupMenuButton(
                                            icon: const Icon(FeatherIcons.moreVertical, size: 18.0),
                                            padding: EdgeInsets.zero,
                                            itemBuilder: (BuildContext bc) => [
                                              PopupMenuItem(
                                                child: Row(
                                                  children: [
                                                    const Icon(FeatherIcons.edit3, size: 18.0, color: kTitleColor),
                                                    const SizedBox(width: 4.0),
                                                    Text(
                                                      lang.S.of(context).edit,
                                                      style: kTextStyle.copyWith(color: kTitleColor),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem(
                                                child: Row(
                                                  children: [
                                                    const Icon(Icons.delete, size: 18.0, color: kTitleColor),
                                                    const SizedBox(width: 4.0),
                                                    Text(
                                                      lang.S.of(context).delete,
                                                      style: kTextStyle.copyWith(color: kTitleColor),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem(
                                                child: Row(
                                                  children: [
                                                    const Icon(FeatherIcons.share2, size: 18.0, color: kTitleColor),
                                                    const SizedBox(width: 4.0),
                                                    Text(
                                                      lang.S.of(context).share,
                                                      style: kTextStyle.copyWith(color: kTitleColor),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem(
                                                child: Row(
                                                  children: [
                                                    const Icon(FeatherIcons.eye, size: 18.0, color: kTitleColor),
                                                    const SizedBox(width: 4.0),
                                                    Text(
                                                      lang.S.of(context).preview,
                                                      style: kTextStyle.copyWith(color: kTitleColor),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                            onSelected: (value) {
                                              Navigator.pushNamed(context, '$value');
                                            },
                                          ),
                                        ),
                                      ]))),
                        ),
                      ],
                    ),
                  ),
                ),
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
      }),
    );
  }
}
