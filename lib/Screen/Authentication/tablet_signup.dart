import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Screen/Authentication/tablet_log_in.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../Widgets/Constant Data/button_global.dart';
import '../Widgets/Constant Data/constant.dart';

class TabletSignUp extends StatefulWidget {
  const TabletSignUp({Key? key}) : super(key: key);
  static const String route = '/msignup';
  @override
  State<TabletSignUp> createState() => _TabletSignUpState();
}

class _TabletSignUpState extends State<TabletSignUp> {
  List<String> categories = [
    'Fashion',
    'Electronic',
    'Computer Store',
    'Vegetable Store',
    'Meat Store',
    'Sweet Store',
  ];

  String selectedCategories = 'Fashion';

  DropdownButton<String> getCategories() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String des in categories) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      items: dropDownItems,
      value: selectedCategories,
      onChanged: (value) {
        setState(() {
          selectedCategories = value!;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 100.0),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * .90,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/mpos.png'),
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 1.0,
                            color: kGreyTextColor.withOpacity(0.1),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            lang.S.of(context).counterSaleSingUpPanel,
                            style: kTextStyle.copyWith(color: kGreyTextColor, fontWeight: FontWeight.bold, fontSize: 21.0),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10.0),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: AppTextField(
                                        showCursor: true,
                                        cursorColor: kTitleColor,
                                        textFieldType: TextFieldType.NAME,
                                        decoration: kInputDecoration.copyWith(
                                          labelText: lang.S.of(context).shopName,
                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                          hintText: lang.S.of(context).enterShopName,
                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20.0),
                                    Expanded(
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                          side: BorderSide(
                                            color: kGreyTextColor.withOpacity(0.1),
                                          ),
                                        ),
                                        child: ListTile(
                                          contentPadding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                          title: DropdownButtonHideUnderline(child: getCategories()),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 20.0),
                                Row(
                                  children: [
                                    Expanded(
                                      child: AppTextField(
                                        showCursor: true,
                                        cursorColor: kTitleColor,
                                        textFieldType: TextFieldType.NAME,
                                        decoration: kInputDecoration.copyWith(
                                          labelText: lang.S.of(context).phone,
                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                          hintText: lang.S.of(context).enterYourPhoneNumber,
                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20.0),
                                    Expanded(
                                      child: AppTextField(
                                        showCursor: true,
                                        cursorColor: kTitleColor,
                                        textFieldType: TextFieldType.NAME,
                                        decoration: kInputDecoration.copyWith(
                                          labelText: lang.S.of(context).email,
                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                          hintText: lang.S.of(context).enterEmailAddresss,
                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20.0),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .41,
                                  child: AppTextField(
                                    showCursor: true,
                                    cursorColor: kTitleColor,
                                    textFieldType: TextFieldType.PASSWORD,
                                    decoration: kInputDecoration.copyWith(
                                      labelText: lang.S.of(context).password,
                                      labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                      hintText: lang.S.of(context).enterYourPassword,
                                      hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                ButtonGlobal(
                                    buttontext: lang.S.of(context).register,
                                    buttonDecoration: kButtonDecoration.copyWith(color: kGreenTextColor, borderRadius: BorderRadius.circular(8.0)),
                                    onPressed: (() {
                                      // ProfileSetUp(personalInformationModel: PersonalInformationModel(),).launch(context);
                                    })),
                                const SizedBox(height: 20.0),
                                RichText(
                                  text: TextSpan(
                                    text: lang.S.of(context).alreadyhaveAnAcconuts,
                                    style: kTextStyle.copyWith(color: kTitleColor),
                                    children: [
                                      TextSpan(
                                        text: lang.S.of(context).login,
                                        style: kTextStyle.copyWith(color: kGreenTextColor),
                                      )
                                    ],
                                  ),
                                ).onTap(() => Navigator.of(context).pushNamed(TabletLogIn.route)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
