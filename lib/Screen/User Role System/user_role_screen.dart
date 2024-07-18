import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Screen/User%20Role%20System/user_role_details.dart';
import 'package:salespro_admin/Screen/Widgets/no_data_found.dart';
import 'package:salespro_admin/model/user_role_model.dart';
import '../../Provider/user_role_provider.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/Sidebar/sidebar_widget.dart';
import '../Widgets/TopBar/top_bar_widget.dart';
import 'add_user_role_screen.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;

class UserRoleScreen extends StatefulWidget {
  const UserRoleScreen({Key? key}) : super(key: key);

  static const String route = '/user_role';

  @override
  State<UserRoleScreen> createState() => _UserRoleScreenState();
}

class _UserRoleScreenState extends State<UserRoleScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // voidLink(context: context);
  }

  int selectedItem = 10;
  int itemCount = 10;
  ScrollController mainScroll = ScrollController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: kDarkWhite,
          body: Scrollbar(
            controller: mainScroll,
            child: SingleChildScrollView(
              controller: mainScroll,
              scrollDirection: Axis.horizontal,
              child: Consumer(builder: (_, ref, watch) {
                final customers = ref.watch(userRoleProvider);
                return customers.when(data: (allCustomerList) {
                  List<UserRoleModel> customerList = allCustomerList;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 240,
                        child: SideBarWidget(
                          index: 14,
                          isTab: false,
                        ),
                      ),
                      Container(
                        width: context.width() < 1080 ? 1080 - 240 : MediaQuery.of(context).size.width - 240,
                        decoration: const BoxDecoration(color: kDarkWhite),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10.0),
                                decoration: const BoxDecoration(
                                  color: kWhiteTextColor,
                                ),
                                child: const TopBar(),
                              ),
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
                                            lang.S.of(context).userRole,
                                            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                            onTap: (() {
                                              showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return StatefulBuilder(builder: (context, setState1) {
                                                    return Dialog(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10.0),
                                                        ),
                                                        child: const SizedBox(
                                                          width: 700,
                                                          child: Padding(
                                                            padding: EdgeInsets.all(30.0),
                                                            child: AddUserRole(),
                                                          ),
                                                        ));
                                                  });
                                                },
                                              );
                                            }),
                                            child: Container(
                                              height: 40,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                color: kBlueTextColor,
                                                borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                border: Border.all(width: 1, color: kBlueTextColor),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  lang.S.of(context).addNewUser,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5.0),
                                      Divider(
                                        thickness: 1.0,
                                        color: kGreyTextColor.withOpacity(0.2),
                                      ),
                                      const SizedBox(height: 20.0),
                                      customerList.isNotEmpty
                                          ? Column(
                                              children: [
                                                Column(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.all(15),
                                                      decoration: BoxDecoration(color: kGreyTextColor.withOpacity(0.3)),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          const SizedBox(width: 50, child: Text('S.L')),
                                                          SizedBox(width: 200, child: Text(lang.S.of(context).userName)),
                                                          SizedBox(width: 200, child: Text(lang.S.of(context).userRole)),
                                                          SizedBox(width: 200, child: Text(lang.S.of(context).email)),
                                                          SizedBox(width: 50, child: Text(lang.S.of(context).action)),
                                                        ],
                                                      ),
                                                    ),
                                                    ListView.builder(
                                                      shrinkWrap: true,
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      itemCount: customerList.length,
                                                      itemBuilder: (BuildContext context, int index) {
                                                        return Column(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.all(15),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  ///______________S.L__________________________________________________
                                                                  SizedBox(
                                                                    width: 50,
                                                                    child: Text((index + 1).toString(), style: kTextStyle.copyWith(color: kGreyTextColor)),
                                                                  ),

                                                                  ///______________Date__________________________________________________
                                                                  SizedBox(
                                                                    width: 200,
                                                                    child: Text(
                                                                      customerList[index].userTitle,
                                                                      maxLines: 2,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                                    ),
                                                                  ),

                                                                  SizedBox(
                                                                    width: 200,
                                                                    child: Text(
                                                                      customerList[index].userRoleName ?? '',
                                                                      maxLines: 2,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                                    ),
                                                                  ),

                                                                  ///____________Invoice_________________________________________________
                                                                  SizedBox(
                                                                    width: 200,
                                                                    child: Text(customerList[index].email,
                                                                        maxLines: 2, overflow: TextOverflow.ellipsis, style: kTextStyle.copyWith(color: kGreyTextColor)),
                                                                  ),

                                                                  ///______Party Name___________________________________________________________
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      showDialog(
                                                                        barrierDismissible: false,
                                                                        context: context,
                                                                        builder: (BuildContext context) {
                                                                          return StatefulBuilder(builder: (context, setState1) {
                                                                            return Dialog(
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                                ),
                                                                                child: SizedBox(
                                                                                  width: 700,
                                                                                  child: UserRoleDetails(
                                                                                    userRoleModel: customerList[index],
                                                                                  ),
                                                                                ));
                                                                          });
                                                                        },
                                                                      );
                                                                    },
                                                                    child: SizedBox(
                                                                      width: 50,
                                                                      child: Text(
                                                                        'View >',
                                                                        style: kTextStyle.copyWith(color: Colors.blue),
                                                                        maxLines: 2,
                                                                        overflow: TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              width: double.infinity,
                                                              height: 1,
                                                              color: kGreyTextColor.withOpacity(0.2),
                                                            )
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                // ListView.builder(
                                                //   shrinkWrap: true,
                                                //   physics: const NeverScrollableScrollPhysics(),
                                                //   itemCount: customerList.length,
                                                //   itemBuilder: (BuildContext context, int index) {
                                                //     return Card(
                                                //       child: ListTile(
                                                //         onTap: () {},
                                                //         title: Text(customerList[index].userTitle),
                                                //         subtitle: Text(customerList[index].email),
                                                //         trailing: const Icon(Icons.arrow_forward_ios),
                                                //       ),
                                                //     );
                                                //   },
                                                // ),
                                              ],
                                            )
                                          : noDataFoundImage(text: lang.S.of(context).noUserFound),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
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
            ),
          )),
    );
  }
}
