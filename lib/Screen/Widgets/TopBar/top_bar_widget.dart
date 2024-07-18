import 'dart:js_interop';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as r;
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:salespro_admin/Screen/POS%20Sale/pos_sale.dart';
import 'package:salespro_admin/Screen/Purchase/purchase.dart';
import 'package:salespro_admin/Screen/Reports/report_screen.dart';
import 'package:salespro_admin/constant.dart';
import 'package:salespro_admin/model/personal_information_model.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../../Language/language_change_provider.dart';
import '../../../Provider/profile_provider.dart';
import '../../../currency.dart';
import '../../../model/user_role_model.dart';
import '../../Authentication/login_with_email.dart';
import '../../Authentication/profile_setup.dart';
import '../../Authentication/tablet_profile_set_up.dart';
import '../../Home/home_screen.dart';
import '../../Product/product.dart';
import '../Constant Data/constant.dart';

class TopBar extends StatefulWidget {
  const TopBar({
    Key? key,
    this.callback,
    this.isFromNoSearch,
  }) : super(key: key);

  final void Function()? callback;
  final bool? isFromNoSearch;

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  List<String> baseFlagsCode = [
    'US',
    'ES',
    'IN',
    'SA',
    'FR',
    'BD',
    'TR',
    'CN',
    'JP',
    'RO',
    'DE',
    'VN',
    'IT',
    'TH',
    'PT',
    'IL',
    'PL',
    'HU',
    'FI',
    'KR',
    'MY',
    'ID',
    'UA',
    'BA',
    'GR',
    'NL',
    'Pk',
    'LK',
    'IR',
    'RS',
    'KH',
    'LA',
    'RU',
    'IN',
    'IN',
    'IN',
    'ZA',
    'CZ',
    'SE',
    'SK',
    'SK',
    'MM',
    'AL',
    'DK',
    'AZ',
    'KZ',
    'HR',
    'NP'
  ];
  List<String> countryList = [
    'English',
    'Spanish',
    'Hindi',
    'Arabic',
    'France',
    'Bengali',
    'Turkish',
    'Chinese',
    'Japanese',
    'Romanian',
    'Germany',
    'Vietnamese',
    'Italian',
    'Thai',
    'Portuguese',
    'Hebrew',
    'Polish',
    'Hungarian',
    'Finland',
    'Korean',
    'Malay',
    'Indonesian',
    'Ukrainian',
    'Bosnian',
    'Greek',
    'Dutch',
    'Urdu',
    'Sinhala',
    'Persian',
    'Serbian',
    'Khmer',
    'Lao',
    'Russian',
    'Kannada',
    'Marathi',
    'Tamil',
    'Afrikaans',
    'Czech',
    'Swedish',
    'Slovak',
    'Swahili',
    'Burmese',
    'Albanian',
    'Danish',
    'Azerbaijani',
    'Kazakh',
    'Croatian',
    'Nepali'
  ];
  String? dropdownValue = 'Tsh (TZ Shillings)';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrency();
  }

  getCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('currency');

    if (!data.isEmptyOrNull) {
      for (var element in items) {
        if (element.substring(0, 2).contains(data!)) {
          setState(() {
            dropdownValue = element;
          });
          break;
        }
      }
    } else {
      setState(() {
        dropdownValue = items[0];
      });
    }
  }

  final ScrollController mainSideScroller = ScrollController();
  String selectedCountry = 'English';
  @override
  Widget build(BuildContext context) {
    return r.Consumer(
      builder: (_, ref, __) {
        r.AsyncValue<PersonalInformationModel> userProfileDetails = ref.watch(profileDetailsProvider);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Container(
            //   padding: const EdgeInsets.all(10.0),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(30.0),
            //     color: kBlueTextColor,
            //   ),
            //   child: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       const Icon(FeatherIcons.plus, color: kWhiteTextColor, size: 16.0),
            //       const SizedBox(width: 5.0),
            //       Text(
            //         'Stock',
            //         style: kTextStyle.copyWith(color: kWhiteTextColor),
            //       ),
            //     ],
            //   ),
            // ).onTap(
            //       () => Navigator.pushNamed(context, SaleReports.route, arguments: 'Stock Report'),
            // ),
            const SizedBox(
              width: 8.0,
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: kRedTextColor,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(FeatherIcons.plus, color: kWhiteTextColor, size: 16.0),
                  const SizedBox(width: 5.0),
                  Text(
                    lang.S.of(context).dueList,
                    style: kTextStyle.copyWith(color: kWhiteTextColor),
                  ),
                ],
              ),
            )
                .onTap(
                  () => Navigator.pushNamed(context, Reports.route, arguments: 'Due'),
                )
                .visible(false),
            // const SizedBox(
            //   width: 8.0,
            // ),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(color: kYellowColor),
                color: kWhiteTextColor,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(FeatherIcons.plus, color: kYellowColor, size: 16.0),
                  const SizedBox(width: 5.0),
                  Text(
                    lang.S.of(context).reports,
                    style: kTextStyle.copyWith(color: kYellowColor),
                  ),
                ],
              ),
            )
                .onTap(
                  () => Navigator.pushNamed(context, Reports.route),
                )
                .visible(false),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                height: 40.0,
                width: 400,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0), border: Border.all(color: kGreyTextColor.withOpacity(1.0))),
                child: Center(
                  child: AppTextField(
                    onChanged: (value) {
                      searchItems = value;
                      widget.callback != null ? widget.callback!() : null;
                    },
                    onTap: widget.isFromNoSearch !=null
                        ? () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const Product()));
                          }
                        : () {},
                    showCursor: true,
                    cursorColor: kTitleColor,
                    textFieldType: TextFieldType.NAME,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10.0),
                      hintText: ('Search Anything...'),
                      hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                      border: InputBorder.none,
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                            padding: const EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
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
              ),
            ),
            const Spacer(),

            // InkWell(
            //   onTap: (){
            //     Navigator.push(context, MaterialPageRoute(builder: (context)=>const LanguageScreen()));
            //   },
            //   child: Container(
            //     height: 40,
            //     width: 40,
            //     decoration: const BoxDecoration(
            //       shape: BoxShape.circle,
            //       color: Colors.blueAccent,
            //     ),
            //     child: const Icon(Icons.translate,color: Colors.white,),
            //   ),
            // ),
            SizedBox(
              width: 340,
              child: ListTile(
                horizontalTitleGap: 5,
                visualDensity: const VisualDensity(horizontal: -4),
                title: Text(
                  'Currency',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 18.0,
                  ),
                ),
                leading: const Icon(
                  Icons.currency_exchange,
                  color: kMainColor,
                ),
                trailing: DropdownButton(
                  underline: const SizedBox(),
                  value: dropdownValue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (newValue) async {
                    final prefs = await SharedPreferences.getInstance();
                    if (newValue == 'Tsh (TZ Shillings)') {
                      currency = 'Tsh';
                      await prefs.setString('currency', currency);
                    }
                    else if(newValue=='₹ (Rupee)'){
                      currency = "₹";
                      await prefs.setString('currency', currency);
                    }
                    else if(newValue=='€ (Euro)'){
                      currency = "€";
                      await prefs.setString('currency', currency);
                    }
                    else if(newValue=='₽ (Ruble)'){
                      currency = "₽";
                      await prefs.setString('currency', currency);
                    }
                    else if(newValue=='£ (UK Pound)'){
                      currency = "£";
                      await prefs.setString('currency', currency);
                    }
                    else if(newValue=='৳ (Taka)'){
                      currency = "৳";
                      await prefs.setString('currency', currency);
                    }
                    else if(newValue=='R (Rial)'){
                      currency = "R";
                      await prefs.setString('currency', currency);
                    }
                    else if(newValue=='Tsh (TZ Shillings)'){
                      currency = "Tsh";
                      await prefs.setString('currency', currency);
                    }
                    else {
                      currency = "\$";
                      await prefs.setString('currency', currency);
                    }
                    setState(() {
                      dropdownValue = newValue.toString();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>const MtHomeScreen() ,));
                      // Navigator.of(context).pushNamedR(MtHomeScreen.route);

                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 2),
              child: SizedBox(
                width: 200,
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField2(
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent))),
                    value: selectedCountry,
                    dropdownStyleData: const DropdownStyleData(maxHeight: 500, offset: Offset(-10, -10)),
                    items: List.generate(
                        countryList.length,
                        (index) => DropdownMenuItem(
                              onTap: () {
                                setState(
                                  () {
                                    selectedCountry = countryList[index];
                                    selectedCountry == 'English'
                                        ? context.read<LanguageChangeProvider>().changeLocale("en")
                                        : selectedCountry == 'Arabic'
                                            ? context.read<LanguageChangeProvider>().changeLocale("ar")
                                            : selectedCountry == 'Spanish'
                                                ? context.read<LanguageChangeProvider>().changeLocale("es")
                                                : selectedCountry == 'Hindi'
                                                    ? context.read<LanguageChangeProvider>().changeLocale("hi")
                                                    : selectedCountry == 'France'
                                                        ? context.read<LanguageChangeProvider>().changeLocale("fr")
                                                        : selectedCountry == "Bengali"
                                                            ? context.read<LanguageChangeProvider>().changeLocale("bn")
                                                            : selectedCountry == "Turkish"
                                                                ? context.read<LanguageChangeProvider>().changeLocale("tr")
                                                                : selectedCountry == "Chinese"
                                                                    ? context.read<LanguageChangeProvider>().changeLocale("zh")
                                                                    : selectedCountry == "Japanese"
                                                                        ? context.read<LanguageChangeProvider>().changeLocale("ja")
                                                                        : selectedCountry == "Romanian"
                                                                            ? context.read<LanguageChangeProvider>().changeLocale("ro")
                                                                            : selectedCountry == "Germany"
                                                                                ? context.read<LanguageChangeProvider>().changeLocale("de")
                                                                                : selectedCountry == "Vietnamese"
                                                                                    ? context.read<LanguageChangeProvider>().changeLocale("vi")
                                                                                    : selectedCountry == "Italian"
                                                                                        ? context.read<LanguageChangeProvider>().changeLocale("it")
                                                                                        : selectedCountry == "Thai"
                                                                                            ? context.read<LanguageChangeProvider>().changeLocale("th")
                                                                                            : selectedCountry == "Portuguese"
                                                                                                ? context.read<LanguageChangeProvider>().changeLocale("pt")
                                                                                                : selectedCountry == "Hebrew"
                                                                                                    ? context.read<LanguageChangeProvider>().changeLocale("he")
                                                                                                    : selectedCountry == "Polish"
                                                                                                        ? context.read<LanguageChangeProvider>().changeLocale("pl")
                                                                                                        : selectedCountry == "Hungarian"
                                                                                                            ? context.read<LanguageChangeProvider>().changeLocale("hu")
                                                                                                            : selectedCountry == "Finland"
                                                                                                                ? context.read<LanguageChangeProvider>().changeLocale("fi")
                                                                                                                : selectedCountry == "Korean"
                                                                                                                    ? context.read<LanguageChangeProvider>().changeLocale("ko")
                                                                                                                    : selectedCountry == "Malay"
                                                                                                                        ? context.read<LanguageChangeProvider>().changeLocale("ms")
                                                                                                                        : selectedCountry == "Indonesian"
                                                                                                                            ? context
                                                                                                                                .read<LanguageChangeProvider>()
                                                                                                                                .changeLocale("id")
                                                                                                                            : selectedCountry == "Ukrainian"
                                                                                                                                ? context
                                                                                                                                    .read<LanguageChangeProvider>()
                                                                                                                                    .changeLocale("uk")
                                                                                                                                : selectedCountry == "Bosnian"
                                                                                                                                    ? context
                                                                                                                                        .read<LanguageChangeProvider>()
                                                                                                                                        .changeLocale("bs")
                                                                                                                                    : selectedCountry == "Greek"
                                                                                                                                        ? context
                                                                                                                                            .read<LanguageChangeProvider>()
                                                                                                                                            .changeLocale("el")
                                                                                                                                        : selectedCountry == "Dutch"
                                                                                                                                            ? context
                                                                                                                                                .read<LanguageChangeProvider>()
                                                                                                                                                .changeLocale("nl")
                                                                                                                                            : selectedCountry == "Urdu"
                                                                                                                                                ? context
                                                                                                                                                    .read<LanguageChangeProvider>()
                                                                                                                                                    .changeLocale("ur")
                                                                                                                                                : selectedCountry == "Sinhala"
                                                                                                                                                    ? context
                                                                                                                                                        .read<
                                                                                                                                                            LanguageChangeProvider>()
                                                                                                                                                        .changeLocale("si")
                                                                                                                                                    : selectedCountry == "Persian"
                                                                                                                                                        ? context
                                                                                                                                                            .read<
                                                                                                                                                                LanguageChangeProvider>()
                                                                                                                                                            .changeLocale("fa")
                                                                                                                                                        : selectedCountry ==
                                                                                                                                                                "Serbian"
                                                                                                                                                            ? context
                                                                                                                                                                .read<
                                                                                                                                                                    LanguageChangeProvider>()
                                                                                                                                                                .changeLocale("sr")
                                                                                                                                                            : selectedCountry ==
                                                                                                                                                                    "Khmer"
                                                                                                                                                                ? context
                                                                                                                                                                    .read<
                                                                                                                                                                        LanguageChangeProvider>()
                                                                                                                                                                    .changeLocale(
                                                                                                                                                                        "km")
                                                                                                                                                                : selectedCountry ==
                                                                                                                                                                        "Lao"
                                                                                                                                                                    ? context
                                                                                                                                                                        .read<
                                                                                                                                                                            LanguageChangeProvider>()
                                                                                                                                                                        .changeLocale(
                                                                                                                                                                            "lo")
                                                                                                                                                                    : selectedCountry ==
                                                                                                                                                                            "Russian"
                                                                                                                                                                        ? context.read<LanguageChangeProvider>().changeLocale("ru")
                                                                                                                                                                        : selectedCountry == "Kannada"
                                                                                                                                                                            ? context.read<LanguageChangeProvider>().changeLocale("kn")
                                                                                                                                                                            : selectedCountry == "Marathi"
                                                                                                                                                                                ? context.read<LanguageChangeProvider>().changeLocale("mr")
                                                                                                                                                                                : selectedCountry == "Tamil"
                                                                                                                                                                                    ? context.read<LanguageChangeProvider>().changeLocale("ta")
                                                                                                                                                                                    : selectedCountry == "Afrikaans"
                                                                                                                                                                                        ? context.read<LanguageChangeProvider>().changeLocale("af")
                                                                                                                                                                                        : selectedCountry == "Czech"
                                                                                                                                                                                            ? context.read<LanguageChangeProvider>().changeLocale("cs")
                                                                                                                                                                                            : selectedCountry == "Swedish"
                                                                                                                                                                                                ? context.read<LanguageChangeProvider>().changeLocale("sv")
                                                                                                                                                                                                : selectedCountry == "Slovak"
                                                                                                                                                                                                    ? context.read<LanguageChangeProvider>().changeLocale("sk")
                                                                                                                                                                                                    : selectedCountry == "Swahili"
                                                                                                                                                                                                        ? context.read<LanguageChangeProvider>().changeLocale("sw")
                                                                                                                                                                                                        : selectedCountry == "Burmese"
                                                                                                                                                                                                            ? context.read<LanguageChangeProvider>().changeLocale("my")
                                                                                                                                                                                                            : selectedCountry == "Albanian"
                                                                                                                                                                                                                ? context.read<LanguageChangeProvider>().changeLocale("sq")
                                                                                                                                                                                                                : selectedCountry == "Danish"
                                                                                                                                                                                                                    ? context.read<LanguageChangeProvider>().changeLocale("da")
                                                                                                                                                                                                                    : selectedCountry == "Azerbaijani"
                                                                                                                                                                                                                        ? context.read<LanguageChangeProvider>().changeLocale("az")
                                                                                                                                                                                                                        : selectedCountry == "Kazakh"
                                                                                                                                                                                                                            ? context.read<LanguageChangeProvider>().changeLocale("kk")
                                                                                                                                                                                                                            : selectedCountry == "Croatian"
                                                                                                                                                                                                                                ? context.read<LanguageChangeProvider>().changeLocale("hr")
                                                                                                                                                                                                                                : selectedCountry == "Nepali"
                                                                                                                                                                                                                                    ? context.read<LanguageChangeProvider>().changeLocale("ne")
                                                                                                                                                                                                                                    : context.read<LanguageChangeProvider>().changeLocale("en");
                                  },
                                );
                              },
                              value: countryList[index],
                              child: InkWell(
                                child: Row(
                                  children: [
                                    Flag.fromString(
                                      baseFlagsCode[index],
                                      height: 20,
                                      width: 25,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      countryList[index],
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                    onChanged: (value) {
                      setState(() {
                        selectedCountry != value;
                      });
                    },
                  ),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: kRedTextColor,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(FeatherIcons.plus, color: kWhiteTextColor, size: 16.0),
                  const SizedBox(width: 5.0),
                  Text(
                    lang.S.of(context).sales,
                    style: kTextStyle.copyWith(color: kWhiteTextColor),
                  ),
                ],
              ),
            )
                .onTap(
                  () => Navigator.pushNamed(context, PosSale.route),
                )
                .visible(false),
            // const SizedBox(
            //   width: 8.0,
            // ),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: kGreenTextColor,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(FeatherIcons.plus, color: kWhiteTextColor, size: 16.0),
                  const SizedBox(width: 5.0),
                  Text(
                    lang.S.of(context).purchase,
                    style: kTextStyle.copyWith(color: kWhiteTextColor),
                  ),
                ],
              ),
            )
                .onTap(
                  () => Navigator.pushNamed(context, Purchase.route),
                )
                .visible(false),
            const SizedBox(
              width: 8.0,
            ),
            // Container(
            //   padding: const EdgeInsets.all(10.0),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(30.0),
            //     border: Border.all(color: kBlueTextColor),
            //     color: kWhiteTextColor,
            //   ),
            //   child: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       const Icon(FeatherIcons.plus, color: kBlueTextColor, size: 16.0),
            //       const SizedBox(width: 5.0),
            //       Text(
            //         'Add More',
            //         style: kTextStyle.copyWith(color: kBlueTextColor),
            //       ),
            //     ],
            //   ),
            // ),
            // const Padding(
            //   padding: EdgeInsets.all(8.0),
            //   child: Icon(
            //     FeatherIcons.bell,
            //     color: kTitleColor,
            //   ),
            // ),
            userProfileDetails.when(data: (details) {
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: PopupMenuButton(
                  padding: EdgeInsets.zero,
                  position: PopupMenuPosition.under,
                  icon: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey),
                      image: DecorationImage(image: NetworkImage(details.pictureUrl), fit: BoxFit.cover),
                    ),
                  ),
                  itemBuilder: (BuildContext bc) => [
                    PopupMenuItem(
                      child: GestureDetector(
                        onTap: () {
                          isSubUser ? null : ProfileSetUp(personalInformationModel: details).launch(context);
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.manage_accounts_sharp, size: 18.0, color: kTitleColor),
                            const SizedBox(width: 4.0),
                            Text(
                              isSubUser ? '${details.companyName}[$constSubUserTitle]' : 'Profile',
                              style: kTextStyle.copyWith(color: kTitleColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: GestureDetector(
                        onTap: () async {
                          await _signOut();
                          // ignore: use_build_context_synchronously
                          const LogInEmail(
                            isEmailLogin: true,
                            panelName: '',
                          ).launch(context, isNewTask: true);
                        },
                        child: Row(
                          children: [
                            const Icon(FeatherIcons.logOut, size: 18.0, color: kTitleColor),
                            const SizedBox(width: 4.0),
                            Text(
                              lang.S.of(context).logOut,
                              style: kTextStyle.copyWith(color: kTitleColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
              // return isSubUser
              //     ? Center(
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           children: [
              //             const Text(
              //               'User Role:',
              //             ),
              //             Text(
              //               '${details.companyName}[$constSubUserTitle]',
              //               style: const TextStyle(fontSize: 18),
              //             ),
              //           ],
              //         ),
              //       )
              //     : PopupMenuButton(
              //         padding: EdgeInsets.zero,
              //         position: PopupMenuPosition.under,
              //         icon: Container(
              //           height: 40,
              //           width: 40,
              //           decoration: BoxDecoration(
              //             image: DecorationImage(image: NetworkImage(details.pictureUrl), fit: BoxFit.cover),
              //             borderRadius: BorderRadius.circular(50),
              //           ),
              //         ),
              //         itemBuilder: (BuildContext bc) => [
              //           PopupMenuItem(
              //             child: GestureDetector(
              //               onTap: () {},
              //               child: Row(
              //                 children: [
              //                   const Icon(Icons.manage_accounts_sharp, size: 18.0, color: kTitleColor),
              //                   const SizedBox(width: 4.0),
              //                   Text(
              //                     'Profile',
              //                     style: kTextStyle.copyWith(color: kTitleColor),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ),
              //           PopupMenuItem(
              //             child: GestureDetector(
              //               onTap: () {},
              //               child: Row(
              //                 children: [
              //                   const Icon(FeatherIcons.logOut, size: 18.0, color: kTitleColor),
              //                   const SizedBox(width: 4.0),
              //                   Text(
              //                     'Log Out',
              //                     style: kTextStyle.copyWith(color: kTitleColor),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ),
              //         ],
              //       );
              // : GestureDetector(
              //     onTap: () {
              //
              //     },
              //     child: Container(
              //       height: 40,
              //       width: 40,
              //       decoration: BoxDecoration(
              //         image: DecorationImage(image: NetworkImage(details.pictureUrl), fit: BoxFit.cover),
              //         borderRadius: BorderRadius.circular(50),
              //       ),
              //     ),
              //   );
            }, error: (e, stack) {
              return Center(
                child: Text(e.toString()),
              );
            }, loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
          ],
        );
      },
    );
  }
}

class TopBarTablate extends StatelessWidget {
  const TopBarTablate({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return r.Consumer(
      builder: (_, ref, __) {
        r.AsyncValue<PersonalInformationModel> userProfileDetails = ref.watch(profileDetailsProvider);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Container(
            //   padding: const EdgeInsets.all(10.0),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(30.0),
            //     color: kBlueTextColor,
            //   ),
            //   child: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       const Icon(FeatherIcons.plus, color: kWhiteTextColor, size: 16.0),
            //       const SizedBox(width: 5.0),
            //       Text(
            //         'Stock',
            //         style: kTextStyle.copyWith(color: kWhiteTextColor),
            //       ),
            //     ],
            //   ),
            // ).onTap(
            //       () => Navigator.pushNamed(context, SaleReports.route, arguments: 'Stock Report'),
            // ),
            const SizedBox(
              width: 8.0,
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: kRedTextColor,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(FeatherIcons.plus, color: kWhiteTextColor, size: 16.0),
                  const SizedBox(width: 5.0),
                  Text(
                    lang.S.of(context).dueList,
                    style: kTextStyle.copyWith(color: kWhiteTextColor),
                  ),
                ],
              ),
            ),
            //     .onTap(
            //   () => Navigator.pushNamed(context, TabletSaleReport.route, arguments: 'Due'),
            // ),
            const SizedBox(
              width: 8.0,
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(color: kYellowColor),
                color: kWhiteTextColor,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(FeatherIcons.plus, color: kYellowColor, size: 16.0),
                  const SizedBox(width: 5.0),
                  Text(
                    lang.S.of(context).reports,
                    style: kTextStyle.copyWith(color: kYellowColor),
                  ),
                ],
              ),
            ),
            //         .onTap(
            //   () => Navigator.pushNamed(context, TabletSaleReport.route),
            // ),
            const SizedBox(
              width: 8.0,
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: kRedTextColor,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(FeatherIcons.plus, color: kWhiteTextColor, size: 16.0),
                  const SizedBox(width: 5.0),
                  Text(
                    lang.S.of(context).sales,
                    style: kTextStyle.copyWith(color: kWhiteTextColor),
                  ),
                ],
              ),
            ),
            //           .onTap(
            //   () => Navigator.pushNamed(context, TabletPosSale.route),
            // ),
            const SizedBox(
              width: 8.0,
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: kGreenTextColor,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(FeatherIcons.plus, color: kWhiteTextColor, size: 16.0),
                  const SizedBox(width: 5.0),
                  Text(
                    lang.S.of(context).purchase,
                    style: kTextStyle.copyWith(color: kWhiteTextColor),
                  ),
                ],
              ),
            ).visible(false),
            //     .onTap(
            //   () => Navigator.pushNamed(context, TabletPurchase.route),
            // ),
            const SizedBox(
              width: 8.0,
            ),
            // Container(
            //   padding: const EdgeInsets.all(10.0),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(30.0),
            //     border: Border.all(color: kBlueTextColor),
            //     color: kWhiteTextColor,
            //   ),
            //   child: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       const Icon(FeatherIcons.plus, color: kBlueTextColor, size: 16.0),
            //       const SizedBox(width: 5.0),
            //       Text(
            //         'Add More',
            //         style: kTextStyle.copyWith(color: kBlueTextColor),
            //       ),
            //     ],
            //   ),
            // ),
            // const Padding(
            //   padding: EdgeInsets.all(8.0),
            //   child: Icon(
            //     FeatherIcons.bell,
            //     color: kTitleColor,
            //   ),
            // ),
            userProfileDetails.when(data: (details) {
              return GestureDetector(
                onTap: () {
                  TabletProfileSetUp(
                    personalInformationModel: details,
                  ).launch(context);
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(details.pictureUrl), fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(50),
                  ),
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
            }),
          ],
        );
      },
    );
  }
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
  EasyLoading.showSuccess('Successfully Logged Out');
  finalUserRoleModel = UserRoleModel(
    email: '',
    userTitle: '',
    databaseId: '',
    salePermission: true,
    partiesPermission: true,
    purchasePermission: true,
    productPermission: true,
    profileEditPermission: true,
    addExpensePermission: true,
    lossProfitPermission: true,
    dueListPermission: true,
    stockPermission: true,
    reportsPermission: true,
    salesListPermission: true,
    purchaseListPermission: true,
    ledgerPermission: true,
    incomePermission: true,
    dailyTransActionPermission: true,
  );
}
