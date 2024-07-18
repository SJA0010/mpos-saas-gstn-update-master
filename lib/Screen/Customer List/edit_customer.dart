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
import '../../Provider/customer_provider.dart';
import '../../constant.dart';
import '../../model/customer_model.dart';
import '../Widgets/Constant Data/button_global.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/Sidebar/sidebar_widget.dart';
import '../Widgets/TopBar/top_bar_widget.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;

class EditCustomer extends StatefulWidget {
  const EditCustomer({Key? key, required this.customerModel, required this.typeOfCustomerAdd, required this.popupContext, required this.allPreviousCustomer}) : super(key: key);
  final List<CustomerModel> allPreviousCustomer;
  final CustomerModel customerModel;
  final String typeOfCustomerAdd;
  final BuildContext popupContext;

  @override
  State<EditCustomer> createState() => _EditCustomerState();
}

class _EditCustomerState extends State<EditCustomer> {
  GlobalKey<FormState> addCustomer = GlobalKey<FormState>();

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

  String profilePicture = '';

  Uint8List? image;

  Future<void> uploadFile() async {
    if (kIsWeb) {
      try {
        Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
        if (bytesFromPicker!.isNotEmpty) {
          EasyLoading.show(
            status: 'Uploading... ',
            dismissOnTap: false,
          );
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
  String pageName = 'Edit Customer';

  String selectedCategories = 'Retailer';

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
  TextEditingController customerAddressController = TextEditingController();
  TextEditingController customerEmailController = TextEditingController();
  TextEditingController billingPINCODController = TextEditingController();
  TextEditingController billingGSTNumberController = TextEditingController();
  TextEditingController billingCityController = TextEditingController();

  TextEditingController billingStateController = TextEditingController();
  TextEditingController billingZipController = TextEditingController();
  TextEditingController shippingNameController = TextEditingController();
  TextEditingController shippingAddressController = TextEditingController();
  TextEditingController shippingPINCODController = TextEditingController();
  TextEditingController shippingLandmarkController = TextEditingController();
  TextEditingController shippingStateController = TextEditingController();
  TextEditingController shippingPhoneController = TextEditingController();

  @override
  void initState() {
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
    selectedCategories = widget.customerModel.type;
    profilePicture = widget.customerModel.profilePicture;
    customerNameController.text = widget.customerModel.customerFullName;
    customerPhoneController.text = widget.customerModel.phoneNumber;
    customerEmailController.text = widget.customerModel.emailAddress;
    customerAddressController.text = widget.customerModel.customerAddress;
    billingPINCODController.text = widget.customerModel.billingPinCod;
    billingGSTNumberController.text = widget.customerModel.gstNumber;
    billingCityController.text = widget.customerModel.billingCity;
    billingStateController.text = widget.customerModel.billingState;
    billingZipController.text = widget.customerModel.billingZip;
    shippingNameController.text = widget.customerModel.shippingName;
    shippingAddressController.text = widget.customerModel.shippingAddress;
    shippingPINCODController.text = widget.customerModel.shippingPINCOD;
    shippingLandmarkController.text = widget.customerModel.shippingLandmark;
    shippingStateController.text = widget.customerModel.shippingState;
    shippingPhoneController.text = widget.customerModel.shippingPhoneNumber;
    getCustomerKey(widget.customerModel.phoneNumber);
    super.initState();
  }

  bool validateAndSave() {
    final form = addCustomer.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  bool isPhoneNumberAlreadyUsed(String phoneNumber) {
    for (var element in widget.allPreviousCustomer) {
      if (element.phoneNumber == phoneNumber) {
        return true;
      }
    }
    return false;
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
                  const SizedBox(
                    width: 240,
                    child: SideBarWidget(
                      index: 5,
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
                                                const SizedBox(height: 20.0),

                                                ///__________Name_&_Type___________________________________
                                                Row(
                                                  children: [
                                                    ///________Full_Name_______________________________________
                                                    Expanded(
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          if (value.isEmptyOrNull) {
                                                            return 'Customer Name Is Required.';
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
                                                          labelText: lang.S.of(context).customerName,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintText: lang.S.of(context).enterCustomerName,
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20.0),

                                                    ///______________Type______________________________________________
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

                                                ///__________Phone_&_DeathOfBarth___________________________________
                                                Row(
                                                  children: [
                                                    ///__________PhoneNumber___________________________________
                                                    Expanded(
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          if (value.isEmptyOrNull) {
                                                            return 'Please enter a phone number.';
                                                          } else if (double.tryParse(value!) == null) {
                                                            return 'Enter a valid Phone Number';
                                                          } else if (isPhoneNumberAlreadyUsed(value) && value != widget.customerModel.phoneNumber) {
                                                            return 'Phone number already Used';
                                                          }
                                                          return null;
                                                        },
                                                        onSaved: (value) {
                                                          customerPhoneController.text = value!;
                                                        },
                                                        controller: customerPhoneController,
                                                        cursorColor: kTitleColor,
                                                        decoration: kInputDecoration.copyWith(
                                                          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                          labelText: lang.S.of(context).phone,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20.0),

                                                    ///________Opening_______________________________
                                                    Expanded(
                                                      child: TextFormField(
                                                        validator: (value) {
                                                          return null;
                                                        },
                                                        readOnly: true,
                                                        initialValue: widget.customerModel.dueAmount,
                                                        cursorColor: kTitleColor,
                                                        decoration: kInputDecoration.copyWith(
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
                                                              hintText: lang.S.of(context).enterEmailAddresss,
                                                              hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 20.0),

                                                          ///_________PIN_COD_____________________________

                                                          TextFormField(
                                                            controller: billingPINCODController,
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
                                                            controller: billingGSTNumberController,
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
                                                                  controller: billingStateController,
                                                                  decoration: kInputDecoration.copyWith(
                                                                    errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                                    labelText: lang.S.of(context).state,
                                                                    labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                                    hintText: lang.S.of(context).enterYourState,
                                                                    hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Expanded(
                                                                child: TextFormField(
                                                                  controller: billingZipController,
                                                                  decoration: kInputDecoration.copyWith(
                                                                    errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                                    labelText: lang.S.of(context).zip,
                                                                    labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                                    hintText: lang.S.of(context).enterZip,
                                                                    hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                                  ),
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
                                                            controller: shippingNameController,
                                                            decoration: kInputDecoration.copyWith(
                                                              errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                              labelText: lang.S.of(context).fullName,
                                                              labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                              hintText: lang.S.of(context).enterFullName,
                                                              hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 10.0),

                                                          ///_________Full_Address_______________________________

                                                          TextFormField(
                                                            controller: shippingAddressController,
                                                            decoration: kInputDecoration.copyWith(
                                                              errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                              labelText: lang.S.of(context).fullAddress,
                                                              labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                              hintText: lang.S.of(context).enterFullAddress,
                                                              hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 10.0),

                                                          ///_________PIN_COD_____________________________

                                                          TextFormField(
                                                            controller: shippingPINCODController,
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
                                                            controller: shippingLandmarkController,
                                                            decoration: kInputDecoration.copyWith(
                                                              errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                              labelText: lang.S.of(context).landMark,
                                                              labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                              hintText: lang.S.of(context).enterLandMark,
                                                              hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 10.0),

                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: TextFormField(
                                                                  controller: shippingStateController,
                                                                  decoration: kInputDecoration.copyWith(
                                                                    errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                                    labelText: lang.S.of(context).state,
                                                                    labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                                    hintText: lang.S.of(context).enterYourState,
                                                                    hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Expanded(
                                                                child: TextFormField(
                                                                  controller: shippingPhoneController,
                                                                  decoration: kInputDecoration.copyWith(
                                                                    errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                                                    labelText: lang.S.of(context).phoneNumber,
                                                                    labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                                    hintText: lang.S.of(context).enterYourPhoneNumber,
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
                                                          Navigator.pop(widget.popupContext);
                                                          Navigator.pop(context);
                                                        },
                                                      ),
                                                    ),
                                                    const SizedBox(width: 30),
                                                    SizedBox(
                                                      width: context.width() < 1080 ? 1080 * .18 : MediaQuery.of(context).size.width * .18,
                                                      child: ButtonGlobal(
                                                        buttontext: lang.S.of(context).saveandPublished,
                                                        buttonDecoration: kButtonDecoration.copyWith(color: kGreenTextColor),
                                                        onPressed: () async {
                                                          if (validateAndSave()) {
                                                            try {
                                                              EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                                                              DatabaseReference reference = FirebaseDatabase.instance.ref("$constUserId/Customers/$customerKey");

                                                              CustomerModel customerModel = CustomerModel(
                                                                customerFullName: customerNameController.text,
                                                                phoneNumber: customerPhoneController.text,
                                                                type: selectedCategories,
                                                                profilePicture: profilePicture,
                                                                emailAddress: customerEmailController.text,
                                                                customerAddress: customerAddressController.text,
                                                                dueAmount: widget.customerModel.dueAmount,
                                                                remainedBalance: widget.customerModel.remainedBalance,
                                                                openingBalance: widget.customerModel.openingBalance,
                                                                shippingState: shippingStateController.text,
                                                                shippingPINCOD: shippingPINCODController.text,
                                                                shippingName: shippingNameController.text,
                                                                shippingLandmark: shippingLandmarkController.text,
                                                                shippingAddress: shippingAddressController.text,
                                                                gstNumber: billingGSTNumberController.text,
                                                                billingZip: billingZipController.text,
                                                                billingState: billingStateController.text,
                                                                billingPinCod: billingPINCODController.text,
                                                                billingCity: billingCityController.text,
                                                                shippingPhoneNumber: shippingPhoneController.text,
                                                              );

                                                              ///___________update_customer_________________________________________________________
                                                              await reference.set(customerModel.toJson());

                                                              ///_________chanePhone in All invoice_________________________________________________
                                                              String key = '';
                                                              widget.customerModel.phoneNumber != customerModel.phoneNumber ||
                                                                      widget.customerModel.customerFullName != customerModel.customerFullName
                                                                  ? widget.customerModel.type != 'Supplier'
                                                                      ? await FirebaseDatabase.instance
                                                                          .ref(constUserId)
                                                                          .child('Sales Transition')
                                                                          .orderByKey()
                                                                          .get()
                                                                          .then((value) async {
                                                                          for (var element in value.children) {
                                                                            var data = jsonDecode(jsonEncode(element.value));
                                                                            if (data['customerPhone'].toString() == widget.customerModel.phoneNumber) {
                                                                              key = element.key.toString();
                                                                              DatabaseReference reference = FirebaseDatabase.instance.ref("$constUserId/Sales Transition/$key");
                                                                              await reference.update(
                                                                                  {'customerName': customerModel.customerFullName, 'customerPhone': customerModel.phoneNumber});
                                                                            }
                                                                          }
                                                                        })
                                                                      : await FirebaseDatabase.instance
                                                                          .ref(constUserId)
                                                                          .child('Purchase Transition')
                                                                          .orderByKey()
                                                                          .get()
                                                                          .then((value) async {
                                                                          for (var element in value.children) {
                                                                            var data = jsonDecode(jsonEncode(element.value));
                                                                            if (data['customerPhone'].toString() == widget.customerModel.phoneNumber) {
                                                                              key = element.key.toString();
                                                                              DatabaseReference reference = FirebaseDatabase.instance.ref("$constUserId/Purchase Transition/$key");
                                                                              await reference.update(
                                                                                  {'customerName': customerModel.customerFullName, 'customerPhone': customerModel.phoneNumber});
                                                                            }
                                                                          }
                                                                        })
                                                                  : null;

                                                              EasyLoading.showSuccess('Added Successfully!');

                                                              // ignore: unused_result
                                                              ref.refresh(allCustomerProvider);
                                                              // ignore: use_build_context_synchronously
                                                              Navigator.pop(widget.popupContext);

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
                                                            ]))
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
