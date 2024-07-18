// ignore_for_file: unused_result, use_build_context_synchronously

import 'dart:convert';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Provider/profile_provider.dart';
import 'package:salespro_admin/Screen/Authentication/tablet_profile_set_up.dart';
import 'package:salespro_admin/Screen/Home/home_screen.dart';
import 'package:salespro_admin/Screen/Widgets/Constant%20Data/button_global.dart';
import 'package:salespro_admin/model/personal_information_model.dart';
import 'package:salespro_admin/responsive.dart' as res;
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../constant.dart';
import '../../model/seller_info_model.dart';
import '../Widgets/Constant Data/constant.dart';

class ProfileSetUp extends StatefulWidget {
  const ProfileSetUp({
    Key? key,
    required this.personalInformationModel,
  }) : super(key: key);
  final PersonalInformationModel personalInformationModel;

  static const String route = '/editprofile';

  @override
  State<ProfileSetUp> createState() => _ProfileSetUpState();
}

class _ProfileSetUpState extends State<ProfileSetUp> {
  String initialCountry = 'Bangladesh';
  late String companyName, phoneNumber;
  String profilePicture = 'https://i.imgur.com/jlyGd1j.jpg';

  Uint8List? image;

  Future<void> uploadFile() async {
    // File file = File(filePath);
    if (kIsWeb) {
      try {
        Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
        bytesFromPicker != null ? EasyLoading.show(status: 'Uploading... ', dismissOnTap: false) : null;
        // File? file = await ImagePickerWeb.getImageAsFile();

        var snapshot = await FirebaseStorage.instance.ref('Profile Picture/${DateTime.now().millisecondsSinceEpoch}').putData(bytesFromPicker!);
        var url = await snapshot.ref.getDownloadURL();
        EasyLoading.showSuccess('Upload Successful!');
        setState(() {
          image = bytesFromPicker;
          profilePicture = url.toString();
        });
      } on firebase_core.FirebaseException catch (e) {
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.code.toString(),
            ),
          ),
        );
      }
    }
  }

  List<String> categories = [
    'Select Business Category',
    'Fashion Store',
    'Electronic Store',
    'Computer Store',
    'Vegetable Store',
    'Meat Store',
    'Sweet Store',
  ];

  String dropdownValue = 'Select Business Category';

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
      value: dropdownValue,
      onChanged: (value) {
        setState(() {
          dropdownValue = value!;
        });
      },
    );
  }

  List<String> language = [
    'Select A Language',
    'English',
    'Bengali',
    'Hindi',
    'Urdu',
    'Chinese',
    'French',
    'Spanish',
  ];

  String selectedLanguage = 'Select A Language';

  DropdownButton<String> getLanguage() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String des in language) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      items: dropDownItems,
      value: selectedLanguage,
      onChanged: (value) {
        setState(() {
          selectedLanguage = value!;
        });
      },
    );
  }

  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  late String customerKey;
  void getCustomerKey(String phoneNumber) async {
    await FirebaseDatabase.instance.ref(constUserId).child('Customers').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        if (data['phoneNumber'].toString() == phoneNumber) {
          customerKey = element.key.toString();
        }
      }
    });
  }

  @override
  void initState() {
    profilePicture = widget.personalInformationModel.pictureUrl;
    selectedLanguage = widget.personalInformationModel.language;
    dropdownValue = widget.personalInformationModel.businessCategory;
    companyNameController.text = widget.personalInformationModel.companyName;
    phoneNumberController.text = widget.personalInformationModel.phoneNumber!;
    addressController.text = widget.personalInformationModel.address;
    emailController.text = widget.personalInformationModel.email;
    stateController.text = widget.personalInformationModel.state;
    zipController.text = widget.personalInformationModel.zip;
    cityController.text = widget.personalInformationModel.city;
    gstNumberController.text = widget.personalInformationModel.gstNo;
    shopOpeningBalanceController.text = widget.personalInformationModel.shopOpeningBalance.toString();
    getCustomerKey(widget.personalInformationModel.phoneNumber);
    bankNameController.text = widget.personalInformationModel.bankName;
    bankBranchNameController.text = widget.personalInformationModel.bankBranchName;
    bankAccountNumberController.text = widget.personalInformationModel.bankAccountNumber;
    bankIFSCController.text = widget.personalInformationModel.ifscNumber;
    tncController.text = widget.personalInformationModel.tAndC;
    super.initState();
  }

  int opiningBalance = 0;

  TextEditingController companyNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController shopOpeningBalanceController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController gstNumberController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController bankBranchNameController = TextEditingController();
  TextEditingController bankAccountNumberController = TextEditingController();
  TextEditingController bankIFSCController = TextEditingController();
  TextEditingController tncController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkWhite,
      body: res.Responsive(
        mobile: Container(),
        tablet: TabletProfileSetUp(personalInformationModel: widget.personalInformationModel),
        desktop: SingleChildScrollView(
          child: Consumer(
            builder: (context, ref, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * .50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 80,
                                  width: 80,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage('images/mlogo.png'),
                                    ),
                                  ),
                                ),
                                Divider(
                                  thickness: 1.0,
                                  color: kGreyTextColor.withOpacity(0.1),
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  lang.S.of(context).enterYourProfile,
                                  style: kTextStyle.copyWith(color: kGreyTextColor, fontWeight: FontWeight.bold, fontSize: 21.0),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10.0),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(20.0),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: kWhiteTextColor),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            DottedBorderWidget(
                                              color: kLitGreyColor,
                                              child: ClipRRect(
                                                borderRadius: const BorderRadius.all(Radius.circular(12)),
                                                child: Container(
                                                  width: context.width(),
                                                  padding: const EdgeInsets.all(10.0),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20.0),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          const Icon(Icons.cloud_upload, size: 50.0, color: kLitGreyColor).onTap(() => uploadFile()),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 5.0),
                                                      RichText(
                                                          text: TextSpan(
                                                              text: lang.S.of(context).uploadanImage,
                                                              style: kTextStyle.copyWith(color: kGreenTextColor, fontWeight: FontWeight.bold),
                                                              children: [
                                                            TextSpan(
                                                                text: lang.S.of(context).ordragdropPNGPG,
                                                                style: kTextStyle.copyWith(color: kGreyTextColor, fontWeight: FontWeight.bold))
                                                          ])),
                                                      image != null
                                                          ? Image.memory(
                                                              image!,
                                                              width: 150,
                                                              height: 150,
                                                            )
                                                          : Image.network(profilePicture, width: 150, height: 150),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10.0),
                                      Form(
                                          key: globalKey,
                                          child: Column(
                                            children: [
                                              ///________Name_________________________________________

                                              TextFormField(
                                                controller: companyNameController,
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return 'Company Name can\'n be empty';
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                  border: const OutlineInputBorder(),
                                                  labelText: lang.S.of(context).companyName,
                                                  hintText: lang.S.of(context).enterYourState,
                                                ),
                                              ),
                                              const SizedBox(height: 10.0),

                                              ///__________PhoneNumber__________________________________
                                              TextFormField(
                                                controller: phoneNumberController,
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return 'Phone number can\'n be empty';
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                  border: const OutlineInputBorder(),
                                                  labelText: lang.S.of(context).phoneNumber,
                                                  hintText: lang.S.of(context).enterYourPhoneNumber,
                                                ),
                                              ),
                                              const SizedBox(height: 10.0),

                                              ///________Email____________________________________________
                                              TextFormField(
                                                controller: emailController,
                                                decoration: InputDecoration(
                                                  border: const OutlineInputBorder(),
                                                  labelText: lang.S.of(context).email,
                                                  hintText: lang.S.of(context).enterEmailAddresss,
                                                ),
                                              ),
                                              const SizedBox(height: 10.0),

                                              ///_____GSt___________________________________________________
                                              TextFormField(
                                                controller: gstNumberController,
                                                decoration: InputDecoration(
                                                  border: const OutlineInputBorder(),
                                                  labelText: lang.S.of(context).gstNumber,
                                                  hintText: lang.S.of(context).enterGstNumber,
                                                ),
                                              ),
                                              const SizedBox(height: 10.0),

                                              ///________Address_______________________________
                                              TextFormField(
                                                controller: addressController,
                                                decoration: InputDecoration(
                                                  border: const OutlineInputBorder(),
                                                  labelText: lang.S.of(context).address,
                                                  hintText: lang.S.of(context).enterFullAddress,
                                                ),
                                              ),
                                              const SizedBox(height: 10.0),

                                              ///_________City_____________________________________
                                              TextFormField(
                                                controller: cityController,
                                                decoration: InputDecoration(
                                                  border: const OutlineInputBorder(),
                                                  labelText: lang.S.of(context).cityPinCode,
                                                  hintText: lang.S.of(context).enterYourCityPinCode,
                                                ),
                                              ),
                                              const SizedBox(height: 10.0),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: TextFormField(
                                                      controller: stateController,
                                                      decoration: InputDecoration(
                                                        border: const OutlineInputBorder(),
                                                        labelText: lang.S.of(context).state,
                                                        hintText: lang.S.of(context).enterYourState,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: TextFormField(
                                                      controller: zipController,
                                                      decoration: InputDecoration(
                                                        border: const OutlineInputBorder(),
                                                        labelText: lang.S.of(context).zip,
                                                        hintText: lang.S.of(context).enterYourZip,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 10.0),
                                              Text(lang.S.of(context).bankDetails, style: const TextStyle(fontWeight: FontWeight.bold)),
                                              const SizedBox(height: 10.0),

                                              ///_______Bank_NAME_AND_BRANCH_NAME_____________________________
                                              Row(
                                                children: [
                                                  ///________Bank_Name_____________________________
                                                  Expanded(
                                                    child: TextFormField(
                                                      controller: bankNameController,
                                                      decoration: InputDecoration(
                                                        border: const OutlineInputBorder(),
                                                        labelText: lang.S.of(context).bankName,
                                                        hintText: lang.S.of(context).enterYourBankName,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),

                                                  ///___________Branch_Name___________________________
                                                  Expanded(
                                                    child: TextFormField(
                                                      controller: bankBranchNameController,
                                                      decoration: InputDecoration(
                                                        border: const OutlineInputBorder(),
                                                        labelText: lang.S.of(context).branchName,
                                                        hintText: lang.S.of(context).enterYourBranchName,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 10.0),

                                              ///_______Bank_AC_Number_&_IFSC NUMBER_____________________________
                                              Row(
                                                children: [
                                                  ///________Bank_AC_Number_____________________________
                                                  Expanded(
                                                    child: TextFormField(
                                                      controller: bankAccountNumberController,
                                                      decoration: InputDecoration(
                                                        border: const OutlineInputBorder(),
                                                        labelText: lang.S.of(context).bankAccountNumber,
                                                        hintText: lang.S.of(context).enterYourBankAccountNumber,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),

                                                  ///___________IFSC NUMBER___________________________
                                                  Expanded(
                                                    child: TextFormField(
                                                      controller: bankIFSCController,
                                                      decoration: InputDecoration(
                                                        border: const OutlineInputBorder(),
                                                        labelText: lang.S.of(context).ifsc,
                                                        hintText: lang.S.of(context).enterYourIfscNumber,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 10.0),

                                              ///________T&C______________________
                                              TextFormField(
                                                controller: tncController,
                                                decoration: InputDecoration(
                                                  border: const OutlineInputBorder(),
                                                  labelText: lang.S.of(context).tc,
                                                  hintText: lang.S.of(context).enterYourBanktc,
                                                ),
                                              ),
                                              const SizedBox(height: 10.0),
                                            ],
                                          )),
                                      const SizedBox(height: 20.0),
                                      ButtonGlobal(
                                        buttontext: lang.S.of(context).continued,
                                        buttonDecoration: kButtonDecoration.copyWith(color: kGreenTextColor, borderRadius: BorderRadius.circular(8.0)),
                                        onPressed: () async {
                                          try {
                                            EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                                            final DatabaseReference personalInformationRef = FirebaseDatabase.instance.ref().child(constUserId).child('Personal Information');
                                            PersonalInformationModel personalInformation = PersonalInformationModel(
                                              phoneNumber: phoneNumberController.text,
                                              pictureUrl: profilePicture,
                                              companyName: companyNameController.text,
                                              countryName: addressController.text,
                                              language: selectedLanguage,
                                              dueInvoiceCounter: widget.personalInformationModel.dueInvoiceCounter,
                                              saleInvoiceCounter: widget.personalInformationModel.saleInvoiceCounter,
                                              purchaseInvoiceCounter: widget.personalInformationModel.purchaseInvoiceCounter,
                                              businessCategory: dropdownValue,
                                              shopOpeningBalance: shopOpeningBalanceController.text.toInt(),
                                              remainingShopBalance: shopOpeningBalanceController.text.toInt(),
                                              address: addressController.text,
                                              city: cityController.text,
                                              email: emailController.text,
                                              gstNo: gstNumberController.text,
                                              state: stateController.text,
                                              zip: zipController.text,
                                              bankAccountNumber: bankAccountNumberController.text,
                                              bankBranchName: bankBranchNameController.text,
                                              bankName: bankNameController.text,
                                              ifscNumber: bankIFSCController.text,
                                              tAndC: tncController.text,
                                            );
                                            await personalInformationRef.set(personalInformation.toJson());

                                            EasyLoading.showSuccess('Added Successfully', duration: const Duration(milliseconds: 1000));

                                            SellerInfoModel sellerInfoModel = SellerInfoModel(
                                              businessCategory: dropdownValue,
                                              companyName: companyNameController.text,
                                              phoneNumber: phoneNumberController.text,
                                              countryName: addressController.text,
                                              language: selectedLanguage,
                                              pictureUrl: profilePicture,
                                              userID: constUserId,
                                              email: '',
                                              subscriptionDate: DateTime.now().toString(),
                                              subscriptionName: 'Free',
                                              subscriptionMethod: 'Not Provided',
                                            );
                                            await FirebaseDatabase.instance.ref().child('Admin Panel').child('Seller List').push().set(sellerInfoModel.toJson());

                                            EasyLoading.showSuccess('Added Successfully', duration: const Duration(milliseconds: 1000));

                                            ref.refresh(profileDetailsProvider);
                                            Navigator.pushNamed(context, MtHomeScreen.route);
                                          } catch (e) {
                                            EasyLoading.dismiss();
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                          }
                                          // Navigator.pushNamed(context, '/otp');
                                        },
                                      ),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
