import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:salespro_admin/Screen/Widgets/Constant%20Data/button_global.dart';
import 'package:salespro_admin/model/personal_information_model.dart';
import '../../constant.dart';
import '../../model/seller_info_model.dart';
import '../../subscription.dart';
import '../Home/home_screen.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;

import '../Widgets/Constant Data/constant.dart';

class ProfileAdd extends StatefulWidget {
  const ProfileAdd({
    Key? key,
  }) : super(key: key);

  static const String route = '/addProfile';

  @override
  State<ProfileAdd> createState() => _ProfileAddState();
}

class _ProfileAddState extends State<ProfileAdd> {
  String profilePicture =
      'https://firebasestorage.googleapis.com/v0/b/essge-enterprise.appspot.com/o/WhatsApp%20Image%202023-06-08%20at%204.13.23%20PM.jpeg?alt=media&token=5100d20b-98e5-43fc-bb9e-4d26cb5e83bd&_gl=1*1w3gae2*_ga*MTA4MTI3NDE2MC4xNjgzMDEzNTky*_ga_CW55HF8NVT*MTY4NjIxODgyMS4yOS4xLjE2ODYyMTkyODQuMC4wLjA.';

  Uint8List? image;

  Future<void> uploadFile() async {
    if (kIsWeb) {
      try {
        Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
        bytesFromPicker != null
            ? EasyLoading.show(
                status: 'Uploading... ',
                dismissOnTap: false,
              )
            : null;
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
    'Shoes',
    'Clothing',
    'Pharmacy',
    'Furniture',
    'Laundry',
    'Trading',
    'Rice mill',
    'Handicraft',
    'Super Shop',
    'Sunglasses',
    'Coffee & Tea',
    'E-Commerce',
    'Manufacturing',
    'Poultry & Agro',
    'General Store',
    'Mobile Top up',
    'Bag & Luggage',
    'Vehicles & Parts',
    'Home & Kitchen',
    'Motorbike & parts',
    'Mobile & Gadgets',
    'Books & Stationery',
    'Sports & Exercise',
    'Gift, Toys & flowers',
    'Pet & Accessories',
    'Internet, Dish & TV',
    'Service & Repairing',
    'Hardware & sanitary',
    'Cosmetic & Jewellery',
    'Computer & Electronic',
    'Travel Ticket & Rental',
    'Grocery, Fruits & Bakery',
    'Saloon & Beauty Parlour',
    'Shop Rent & Office Rent',
    'Thai Aluminium & Glass',
    'Construction & Raw materials',
    'Others',
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
    super.initState();
  }

  int opiningBalance = 0;

  TextEditingController companyNameController = TextEditingController();
  TextEditingController companyPhoneNumberController = TextEditingController();
  TextEditingController shopOpeningBalanceController = TextEditingController();
  TextEditingController tncController = TextEditingController();

  String email = '';
  String gstNumber = '';
  String address = '';
  String city = '';
  String state = '';
  String zip = '';

  String bankAccountNumberController = '';
  String bankBranchNameController = '';
  String bankNameController = '';
  String bankIFSCController = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkWhite,
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            width: context.width() < 750 ? 750 : MediaQuery.of(context).size.width,
            height: context.height() < 500 ? 500 : MediaQuery.of(context).size.height,
            child: Consumer(
              builder: (context, ref, _) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Container(
                        width: context.width() < 940 ? 477 : MediaQuery.of(context).size.width * .50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              decoration: const BoxDecoration(
                                image: DecorationImage(image: AssetImage('images/mpos.png'), fit: BoxFit.fill),
                              ),
                            ),
                            Divider(
                              thickness: 1.0,
                              color: kGreyTextColor.withOpacity(0.1),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Form(
                                    key: globalKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ///_______Business_category______________________________________________
                                        SizedBox(
                                          height: 50.0,
                                          child: FormField(
                                            builder: (FormFieldState<dynamic> field) {
                                              return InputDecorator(
                                                decoration: InputDecoration(
                                                    labelText: lang.S.of(context).businessCategory, border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                                                child: DropdownButtonHideUnderline(child: getCategories()),
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),

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
                                          controller: companyPhoneNumberController,
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
                                          onChanged: (value) {
                                            email = value;
                                          },
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(),
                                            labelText: lang.S.of(context).email,
                                            hintText: lang.S.of(context).enterEmailAddresss,
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),

                                        ///_____GSt___________________________________________________
                                        TextFormField(
                                          onChanged: (value) {
                                            gstNumber = value;
                                          },
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(),
                                            labelText: lang.S.of(context).gstNumber,
                                            hintText: lang.S.of(context).enterGstNumber,
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),

                                        ///________Address_______________________________
                                        TextFormField(
                                          onChanged: (value) {
                                            address = value;
                                          },
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(),
                                            labelText: lang.S.of(context).address,
                                            hintText: lang.S.of(context).enterFullAddress,
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),

                                        ///_________City_____________________________________
                                        TextFormField(
                                          onChanged: (value) {
                                            city = value;
                                          },
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
                                                onChanged: (value) {
                                                  state = value;
                                                },
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
                                                onChanged: (value) {
                                                  zip = value;
                                                },
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
                                        TextFormField(
                                          controller: shopOpeningBalanceController,
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(),
                                            labelText: lang.S.of(context).openingBalance,
                                            hintText: lang.S.of(context).enteropeningBalance,
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        const Text('Bank Details', style: TextStyle(fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 10.0),

                                        ///_______Bank_NAME_AND_BRANCH_NAME_____________________________
                                        Row(
                                          children: [
                                            ///________Bank_Name_____________________________
                                            Expanded(
                                              child: TextFormField(
                                                onChanged: (value) {
                                                  bankNameController = value;
                                                },
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
                                                onChanged: (value) {
                                                  bankBranchNameController = value;
                                                },
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
                                                onChanged: (value) {
                                                  bankAccountNumberController = value;
                                                },
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
                                                onChanged: (value) {
                                                  bankIFSCController = value;
                                                },
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
                                    ),
                                  ),
                                  const SizedBox(height: 20.0),
                                  ButtonGlobal(
                                    buttontext: lang.S.of(context).continued,
                                    buttonDecoration: kButtonDecoration.copyWith(color: kGreenTextColor, borderRadius: BorderRadius.circular(8.0)),
                                    onPressed: () async {
                                      if (dropdownValue == 'Select Business Category') {
                                        EasyLoading.showError('Please select Business Category');
                                      } else if (validateAndSave()) {
                                        try {
                                          EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                                          final DatabaseReference personalInformationRef = FirebaseDatabase.instance.ref().child(await getUserID()).child('Personal Information');
                                          PersonalInformationModel personalInformation = PersonalInformationModel(
                                            phoneNumber: companyPhoneNumberController.text,
                                            pictureUrl: profilePicture,
                                            companyName: companyNameController.text,
                                            countryName: countryName,
                                            language: '',
                                            dueInvoiceCounter: 1,
                                            purchaseInvoiceCounter: 1,
                                            saleInvoiceCounter: 1,
                                            businessCategory: dropdownValue,
                                            shopOpeningBalance: shopOpeningBalanceController.text == '' ? 0 : shopOpeningBalanceController.text.toInt(),
                                            remainingShopBalance: shopOpeningBalanceController.text == '' ? 0 : shopOpeningBalanceController.text.toInt(),
                                            address: address,
                                            city: city,
                                            email: email,
                                            gstNo: gstNumber,
                                            state: state,
                                            zip: zip,
                                            bankAccountNumber: bankAccountNumberController,
                                            bankBranchName: bankBranchNameController,
                                            bankName: bankNameController,
                                            ifscNumber: bankIFSCController,
                                            tAndC: tncController.text,
                                          );

                                          ///________super_admin_data_post_________________________________________________________
                                          await personalInformationRef.set(personalInformation.toJson());
                                          SellerInfoModel sellerInfoModel = SellerInfoModel(
                                            businessCategory: dropdownValue,
                                            companyName: companyNameController.text,
                                            phoneNumber: companyPhoneNumberController.text,
                                            countryName: countryName,
                                            language: '',
                                            pictureUrl: profilePicture,
                                            userID: FirebaseAuth.instance.currentUser!.uid,
                                            email: FirebaseAuth.instance.currentUser!.email,
                                            subscriptionDate: DateTime.now().toString(),
                                            subscriptionName: 'Free',
                                            subscriptionMethod: 'Not Provided',
                                          );
                                          await FirebaseDatabase.instance.ref().child('Admin Panel').child('Seller List').push().set(sellerInfoModel.toJson());

                                          EasyLoading.showSuccess('Added Successfully', duration: const Duration(milliseconds: 1000));

                                          ///_________free_subscription_______________________________________

                                          final DatabaseReference subscriptionRef = FirebaseDatabase.instance.ref().child(constUserId).child('Subscription');
                                          await subscriptionRef.set(Subscription.freeSubscriptionPlan.toJson());
                                          EasyLoading.showSuccess('Added Successfully!');
                                          final data = ref.refresh(profileDetailsProvider);
                                          if (data.hasError) {}
                                          // ignore: use_build_context_synchronously
                                          Navigator.pushNamed(context, MtHomeScreen.route);
                                        } catch (e) {
                                          EasyLoading.dismiss();
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                        }
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
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
