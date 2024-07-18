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
import 'package:salespro_admin/model/GSTModel.dart';
import '../../Provider/customer_provider.dart';
import '../../constant.dart';
import '../../model/customer_model.dart';
import '../../subscription.dart';
import '../Widgets/Constant Data/button_global.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/Sidebar/sidebar_widget.dart';
import '../Widgets/TopBar/top_bar_widget.dart';
import 'package:http/http.dart' as http;
import 'package:salespro_admin/generated/l10n.dart' as lang;

class AddCustomer extends StatefulWidget {
  const AddCustomer({Key? key, required this.typeOfCustomerAdd, required this.listOfPhoneNumber, required this.sideBarNumber}) : super(key: key);

  final String typeOfCustomerAdd;
  final List<String> listOfPhoneNumber;
  final int sideBarNumber;

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  String profilePicture =
      'https://firebasestorage.googleapis.com/v0/b/maanpos.appspot.com/o/Profile%20Picture%2Fblank-profile-picture-973460_1280.webp?alt=media&token=3578c1e0-7278-4c03-8b56-dd007a9befd3';

  Uint8List? image;

  Future<void> uploadFile() async {
    if (kIsWeb) {
      try {
        Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
        if (bytesFromPicker!.isNotEmpty) {
          EasyLoading.show(status: 'Uploading... ', dismissOnTap: false);
        }

        var snapshot = await FirebaseStorage.instance.ref('Profile Picture/${DateTime.now().millisecondsSinceEpoch}').putData(bytesFromPicker);
        var url = await snapshot.ref.getDownloadURL();
        EasyLoading.showSuccess('Upload Successful!');
        setState(() {
          image = bytesFromPicker;
          profilePicture = url.toString();
        });
      } on firebase_core.FirebaseException catch (e) {
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.code.toString())));
      }
    }
  }

  List<String> categories = [
    'Retailer',
    'Wholesaler',
    'Dealer',
    'Supplier',
  ];
  String pageName = 'Add Customer';

  String selectedCategories = 'Retailer';

  @override
  initState() {
    super.initState();
    if (widget.typeOfCustomerAdd == 'Buyer') {
      categories = [
        'Retailer',
        'Wholesaler',
        'Dealer',
      ];
    } else if (widget.typeOfCustomerAdd == 'Supplier') {
      categories = [
        'Supplier',
      ];
      selectedCategories = 'Supplier';
      pageName = 'Add Supplier';
    }
  }

  getGstInfoRepo({required String gst}) async {
    EasyLoading.show(status: 'Loading');
    final response = await http.get(
      Uri.parse('http://sheet.gstincheck.co.in/check/a8236019947ce679ce1dd511ccccd649/$gst'),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      EasyLoading.showSuccess('Done');
      final gstData = GstModel.fromJson(data);
      setState(() {
        customerNameController.text = gstData.data?.lgnm ?? '';
        customerAddressController.text = gstData.data?.pradr?.adr ?? '';
        billingStateController.text = gstData.data?.pradr?.addr?.stcd ?? '';
        billingZipController.text = gstData.data?.pradr?.addr?.pncd ?? '';
        billingCityController.text = gstData.data?.pradr?.addr?.city ?? '';
      });
    } else {
      EasyLoading.showError('Failed');
    }
  }

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

  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerPhoneController = TextEditingController();
  TextEditingController customerEmailController = TextEditingController();
  TextEditingController customerPreviousDueController = TextEditingController();
  TextEditingController customerAddressController = TextEditingController();
  TextEditingController billingStateController = TextEditingController();
  TextEditingController billingZipController = TextEditingController();
  TextEditingController billingCityController = TextEditingController();

  String shippingPhoneNumber = '';
  String shippingState = '';
  String shippingLandmark = '';
  String shippingPINCOD = '';
  String shippingName = '';
  String shippingAddress = '';
  String billingPINCOD = '';
  String billingGSTNumber = '';

  GlobalKey<FormState> addCustomer = GlobalKey<FormState>();

  bool validateAndSave() {
    final form = addCustomer.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

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
            child: Consumer(builder: (context, ref, _) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 240,
                    child: SideBarWidget(
                      index: widget.sideBarNumber,
                      isTab: false,
                    ),
                  ),
                  Container(
                    width: context.width() < 1080 ? 1080 - 240 : MediaQuery.of(context).size.width - 240,
                    decoration: const BoxDecoration(color: kDarkWhite),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10.0),
                            decoration: const BoxDecoration(
                              color: kWhiteTextColor,
                            ),
                            child: const TopBar(),
                          ),
                          const SizedBox(height: 20.0),
                          Container(
                            decoration: const BoxDecoration(color: kDarkWhite),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        pageName,
                                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 21.0),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            color: kWhiteTextColor,
                                          ),
                                          child: Form(
                                            key: addCustomer,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(lang.S.of(context).billingAddress, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                                const SizedBox(height: 20.0),

                                                ///__________Name_&_Type___________________________________
                                                Row(
                                                  children: [
                                                    ///_________Full Name___________________________________
                                                    Expanded(
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          if (value.isEmptyOrNull) {
                                                            return 'Full Name Is Required.';
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                        onSaved: (value) {
                                                          customerNameController.text = value!;
                                                        },
                                                        controller: customerNameController,
                                                        showCursor: true,
                                                        cursorColor: kTitleColor,
                                                        decoration: kInputDecoration.copyWith(
                                                          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                          labelText: lang.S.of(context).fullName,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enterFullName,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20.0),

                                                    ///_____Customer_type_____________________________________
                                                    Expanded(
                                                      child: FormField(
                                                        builder: (FormFieldState<dynamic> field) {
                                                          return InputDecorator(
                                                            decoration: InputDecoration(
                                                                enabledBorder: const OutlineInputBorder(
                                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                                  borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                                                                ),
                                                                contentPadding: const EdgeInsets.all(6.0),
                                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                                labelText: lang.S.of(context).type),
                                                            child: DropdownButtonHideUnderline(child: getCategories()),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 20.0),

                                                ///_________Phone_&_Opening_Balance___________________________________
                                                Row(
                                                  children: [
                                                    ///________Phone_Number___________________________________
                                                    Expanded(
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          if (value.isEmptyOrNull) {
                                                            return 'Phone Number is required.';
                                                          } else if (widget.listOfPhoneNumber.contains(value.removeAllWhiteSpace().toLowerCase())) {
                                                            return 'Phone Number already exists';
                                                          } else if (double.tryParse(value!) == null && value.isNotEmpty) {
                                                            return 'Please Enter valid phone number.';
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                        onSaved: (value) {
                                                          customerPhoneController.text = value!;
                                                        },
                                                        controller: customerPhoneController,
                                                        showCursor: true,
                                                        cursorColor: kTitleColor,
                                                        decoration: kInputDecoration.copyWith(
                                                          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                          labelText: lang.S.of(context).phone,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: '+8801712022529',
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ),

                                                    const SizedBox(width: 20.0),

                                                    ///_________Opening_balance___________________________________
                                                    Expanded(
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          if (double.tryParse(value!) == null && value.isNotEmpty) {
                                                            return 'Please Enter valid balance.';
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                        onSaved: (value) {
                                                          customerPreviousDueController.text = value!;
                                                        },
                                                        controller: customerPreviousDueController,
                                                        showCursor: true,
                                                        cursorColor: kTitleColor,
                                                        decoration: kInputDecoration.copyWith(
                                                          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                          labelText: lang.S.of(context).openingBalance,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enterOpeningBalance,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 20.0),

                                                ///_________shipping and bulling______________________________________
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    ///_______Bulling_Address________________________________________
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          ///_____Address_____________________________________________
                                                          TextFormField(
                                                            validator: (value) {
                                                              return null;
                                                            },
                                                            onSaved: (value) {
                                                              customerAddressController.text = value!;
                                                            },
                                                            controller: customerAddressController,
                                                            showCursor: true,
                                                            cursorColor: kTitleColor,
                                                            decoration: kInputDecoration.copyWith(
                                                              labelText: lang.S.of(context).fullAddress,
                                                              labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                              hintText: lang.S.of(context).enterFullAddress,
                                                              hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 20.0),

                                                          ///________Email_________________________________________
                                                          TextFormField(
                                                            validator: (value) {
                                                              return null;
                                                            },
                                                            onSaved: (value) {
                                                              customerEmailController.text = value!;
                                                            },
                                                            controller: customerEmailController,
                                                            showCursor: true,
                                                            cursorColor: kTitleColor,
                                                            decoration: kInputDecoration.copyWith(
                                                              labelText: lang.S.of(context).email,
                                                              labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                              hintText: 'maantheme@gmail.com',
                                                              hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 20.0),

                                                          ///_________PIN_COD_____________________________

                                                          TextFormField(
                                                            onChanged: (value) {
                                                              billingPINCOD = value;
                                                            },
                                                            decoration: kInputDecoration.copyWith(
                                                              errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                              labelText: lang.S.of(context).pinCode,
                                                              labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                              hintText: lang.S.of(context).enterPinCode,
                                                              hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 20.0),

                                                          ///________GST Number_______________________________

                                                          TextFormField(
                                                            onFieldSubmitted: (value) async {
                                                              await getGstInfoRepo(gst: value);
                                                            },
                                                            onChanged: (value) {
                                                              billingGSTNumber = value;
                                                            },
                                                            decoration: kInputDecoration.copyWith(
                                                              errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                              labelText: lang.S.of(context).gstNumber,
                                                              labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                              hintText: lang.S.of(context).enterGstNumber,
                                                              hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 20.0),

                                                          ///_________City_______________________________

                                                          TextFormField(
                                                            controller: billingCityController,
                                                            decoration: kInputDecoration.copyWith(
                                                              errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                              labelText: lang.S.of(context).city,
                                                              labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                              hintText: lang.S.of(context).enterOpeningBalance,
                                                              hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 20.0),

                                                          ///__________State & Zip__________________________

                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: TextFormField(
                                                                  decoration: kInputDecoration.copyWith(
                                                                    errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                                    labelText: lang.S.of(context).state,
                                                                    labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                                    hintText: lang.S.of(context).enterOpeningBalance,
                                                                    hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                                  ),
                                                                  controller: billingStateController,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Expanded(
                                                                child: TextFormField(
                                                                  decoration: kInputDecoration.copyWith(
                                                                    errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                                    labelText: lang.S.of(context).zip,
                                                                    labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                                    hintText: lang.S.of(context).enterOpeningBalance,
                                                                    hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                                  ),
                                                                  controller: billingZipController,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20),

                                                    ///_________Shipping_____________________________________________
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(lang.S.of(context).shippingAddress, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),

                                                          const SizedBox(height: 8),

                                                          ///_________NAME_____________________________

                                                          TextFormField(
                                                            onChanged: (value) {
                                                              shippingName = value;
                                                            },
                                                            decoration: kInputDecoration.copyWith(
                                                              errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                              labelText: lang.S.of(context).fullName,
                                                              labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                              hintText: lang.S.of(context).enterOpeningBalance,
                                                              hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 10.0),

                                                          ///_________Full_Address_______________________________

                                                          TextFormField(
                                                            onChanged: (value) {
                                                              shippingAddress = value;
                                                            },
                                                            decoration: kInputDecoration.copyWith(
                                                              errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                              labelText: lang.S.of(context).fullAddress,
                                                              labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                              hintText: lang.S.of(context).enterOpeningBalance,
                                                              hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 10.0),

                                                          ///_________PIN_COD_____________________________

                                                          TextFormField(
                                                            onChanged: (value) {
                                                              shippingPINCOD = value;
                                                            },
                                                            decoration: kInputDecoration.copyWith(
                                                              errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                              labelText: lang.S.of(context).pinCode,
                                                              labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                              hintText: lang.S.of(context).enterPinCode,
                                                              hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 10.0),

                                                          ///_________Landmark_______________________________

                                                          TextFormField(
                                                            onChanged: (value) {
                                                              shippingLandmark = value;
                                                            },
                                                            decoration: kInputDecoration.copyWith(
                                                              errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                              labelText: lang.S.of(context).landMark,
                                                              labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                              hintText: lang.S.of(context).enterOpeningBalance,
                                                              hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 10.0),

                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: TextFormField(
                                                                  onChanged: (value) {
                                                                    shippingState = value;
                                                                  },
                                                                  decoration: kInputDecoration.copyWith(
                                                                    errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                                    labelText: lang.S.of(context).state,
                                                                    labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                                    hintText: lang.S.of(context).enterOpeningBalance,
                                                                    hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Expanded(
                                                                child: TextFormField(
                                                                  onChanged: (value) {
                                                                    shippingPhoneNumber = value;
                                                                  },
                                                                  decoration: kInputDecoration.copyWith(
                                                                    errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                                    labelText: lang.S.of(context).phoneNumber,
                                                                    labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                                    hintText: lang.S.of(context).enterOpeningBalance,
                                                                    hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                ///_______Button_______________________________________________________
                                                const SizedBox(height: 30.0),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: context.width() < 1080 ? 1080 * .18 : MediaQuery.of(context).size.width * .18,
                                                      child: ButtonGlobal(
                                                        buttontext: lang.S.of(context).cancel,
                                                        buttonDecoration: kButtonDecoration.copyWith(color: Colors.red),
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20),
                                                    SizedBox(
                                                      width: context.width() < 1080 ? 1080 * .18 : MediaQuery.of(context).size.width * .18,
                                                      child: ButtonGlobal(
                                                        buttontext: lang.S.of(context).saveandPublished,
                                                        buttonDecoration: kButtonDecoration.copyWith(color: kGreenTextColor),
                                                        onPressed: () async {
                                                          if (validateAndSave()) {
                                                            try {
                                                              EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                                                              final DatabaseReference customerInformationRef =
                                                                  FirebaseDatabase.instance.ref().child(constUserId).child('Customers');
                                                              CustomerModel customerModel = CustomerModel(
                                                                customerFullName: customerNameController.text,
                                                                phoneNumber: customerPhoneController.text,
                                                                type: selectedCategories,
                                                                profilePicture: profilePicture,
                                                                emailAddress: customerEmailController.text,
                                                                customerAddress: customerAddressController.text,
                                                                dueAmount: customerPreviousDueController.text.isEmpty ? '0' : customerPreviousDueController.text,
                                                                openingBalance: customerPreviousDueController.text.isEmpty ? '0' : customerPreviousDueController.text,
                                                                remainedBalance: customerPreviousDueController.text.isEmpty ? '0' : customerPreviousDueController.text,
                                                                shippingPhoneNumber: shippingPhoneNumber,
                                                                billingCity: billingCityController.text,
                                                                billingPinCod: billingPINCOD,
                                                                billingState: billingStateController.text,
                                                                billingZip: billingZipController.text,
                                                                gstNumber: billingGSTNumber,
                                                                shippingAddress: shippingAddress,
                                                                shippingLandmark: shippingLandmark,
                                                                shippingName: shippingName,
                                                                shippingPINCOD: shippingPINCOD,
                                                                shippingState: shippingState,
                                                              );
                                                              await customerInformationRef.push().set(customerModel.toJson());

                                                              ///________subscription_plan_update_________________________________________________
                                                              // ignore: use_build_context_synchronously
                                                              Subscription.decreaseSubscriptionLimits(itemType: 'partiesNumber', context: context);

                                                              EasyLoading.showSuccess('Added Successfully!');
                                                              // ignore: unused_result
                                                              ref.refresh(buyerCustomerProvider);
                                                              // ignore: unused_result
                                                              ref.refresh(supplierProvider);
                                                              // ignore: unused_result
                                                              ref.refresh(allCustomerProvider);
                                                              Future.delayed(const Duration(milliseconds: 100), () {
                                                                Navigator.pop(context);
                                                              });
                                                            } catch (e) {
                                                              EasyLoading.dismiss();
                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                                            }
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 20.0),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20.0),
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          padding: const EdgeInsets.all(20.0),
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: kWhiteTextColor),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              const SizedBox(height: 10.0),
                                              DottedBorderWidget(
                                                padding: const EdgeInsets.all(6),
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
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              image != null
                                                  ? Image.memory(
                                                      image!,
                                                      width: 150,
                                                      height: 150,
                                                    )
                                                  : Image.network(
                                                      profilePicture,
                                                      width: 150,
                                                      height: 150,
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
