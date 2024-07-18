// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Subscription`
  String get subscription {
    return Intl.message(
      'Subscription',
      name: 'subscription',
      desc: '',
      args: [],
    );
  }

  /// `Business Category`
  String get businessCategory {
    return Intl.message(
      'Business Category',
      name: 'businessCategory',
      desc: '',
      args: [],
    );
  }

  /// `Company Name`
  String get companyName {
    return Intl.message(
      'Company Name',
      name: 'companyName',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Company Name`
  String get enterYourCompanyName {
    return Intl.message(
      'Enter Your Company Name',
      name: 'enterYourCompanyName',
      desc: '',
      args: [],
    );
  }

  /// `Enter your State`
  String get enterYourState {
    return Intl.message(
      'Enter your State',
      name: 'enterYourState',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter your Phone Number`
  String get enterYourPhoneNumber {
    return Intl.message(
      'Enter your Phone Number',
      name: 'enterYourPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Enter email address`
  String get enterEmailAddresss {
    return Intl.message(
      'Enter email address',
      name: 'enterEmailAddresss',
      desc: '',
      args: [],
    );
  }

  /// `GST NO`
  String get gstNumber {
    return Intl.message(
      'GST NO',
      name: 'gstNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter GST Number`
  String get enterGstNumber {
    return Intl.message(
      'Enter GST Number',
      name: 'enterGstNumber',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Enter full address`
  String get enterFullAddress {
    return Intl.message(
      'Enter full address',
      name: 'enterFullAddress',
      desc: '',
      args: [],
    );
  }

  /// `City Pin Code`
  String get cityPinCode {
    return Intl.message(
      'City Pin Code',
      name: 'cityPinCode',
      desc: '',
      args: [],
    );
  }

  /// `Enter your City Pin Code`
  String get enterYourCityPinCode {
    return Intl.message(
      'Enter your City Pin Code',
      name: 'enterYourCityPinCode',
      desc: '',
      args: [],
    );
  }

  /// `State`
  String get state {
    return Intl.message(
      'State',
      name: 'state',
      desc: '',
      args: [],
    );
  }

  /// `Zip`
  String get zip {
    return Intl.message(
      'Zip',
      name: 'zip',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Zip`
  String get enterYourZip {
    return Intl.message(
      'Enter Your Zip',
      name: 'enterYourZip',
      desc: '',
      args: [],
    );
  }

  /// `Opening Balance`
  String get openingBalance {
    return Intl.message(
      'Opening Balance',
      name: 'openingBalance',
      desc: '',
      args: [],
    );
  }

  /// `Enter Opening Balance`
  String get enteropeningBalance {
    return Intl.message(
      'Enter Opening Balance',
      name: 'enteropeningBalance',
      desc: '',
      args: [],
    );
  }

  /// `Bank Details`
  String get bankDetails {
    return Intl.message(
      'Bank Details',
      name: 'bankDetails',
      desc: '',
      args: [],
    );
  }

  /// `Bank Name`
  String get bankName {
    return Intl.message(
      'Bank Name',
      name: 'bankName',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Bank Name`
  String get enterYourBankName {
    return Intl.message(
      'Enter Your Bank Name',
      name: 'enterYourBankName',
      desc: '',
      args: [],
    );
  }

  /// `Branch Name`
  String get branchName {
    return Intl.message(
      'Branch Name',
      name: 'branchName',
      desc: '',
      args: [],
    );
  }

  /// `Enter You Branch Name`
  String get enterYourBranchName {
    return Intl.message(
      'Enter You Branch Name',
      name: 'enterYourBranchName',
      desc: '',
      args: [],
    );
  }

  /// `Bank Account Number`
  String get bankAccountNumber {
    return Intl.message(
      'Bank Account Number',
      name: 'bankAccountNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter your bank account number`
  String get enterYourBankAccountNumber {
    return Intl.message(
      'Enter your bank account number',
      name: 'enterYourBankAccountNumber',
      desc: '',
      args: [],
    );
  }

  /// `IFSC`
  String get ifsc {
    return Intl.message(
      'IFSC',
      name: 'ifsc',
      desc: '',
      args: [],
    );
  }

  /// `Enter your bank IFSC number`
  String get enterYourIfscNumber {
    return Intl.message(
      'Enter your bank IFSC number',
      name: 'enterYourIfscNumber',
      desc: '',
      args: [],
    );
  }

  /// `T&C`
  String get tc {
    return Intl.message(
      'T&C',
      name: 'tc',
      desc: '',
      args: [],
    );
  }

  /// `Enter your bank T&C`
  String get enterYourBanktc {
    return Intl.message(
      'Enter your bank T&C',
      name: 'enterYourBanktc',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continued {
    return Intl.message(
      'Continue',
      name: 'continued',
      desc: '',
      args: [],
    );
  }

  /// `Reset Your Password`
  String get resetYourPassword {
    return Intl.message(
      'Reset Your Password',
      name: 'resetYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get resetPassword {
    return Intl.message(
      'Reset Password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Password`
  String get enterYourPassword {
    return Intl.message(
      'Enter Your Password',
      name: 'enterYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Edit Your Profile`
  String get enterYourProfile {
    return Intl.message(
      'Edit Your Profile',
      name: 'enterYourProfile',
      desc: '',
      args: [],
    );
  }

  /// `Upload an image`
  String get uploadanImage {
    return Intl.message(
      'Upload an image',
      name: 'uploadanImage',
      desc: '',
      args: [],
    );
  }

  /// `or drag & drop PNG, JPG`
  String get ordragdropPNGPG {
    return Intl.message(
      'or drag & drop PNG, JPG',
      name: 'ordragdropPNGPG',
      desc: '',
      args: [],
    );
  }

  /// `Company Name`
  String get comapanyName {
    return Intl.message(
      'Company Name',
      name: 'comapanyName',
      desc: '',
      args: [],
    );
  }

  /// `COUNTER SALE Signup Panel`
  String get counterSaleSingUpPanel {
    return Intl.message(
      'COUNTER SALE Signup Panel',
      name: 'counterSaleSingUpPanel',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password again`
  String get enterYourPasswordAgain {
    return Intl.message(
      'Enter your password again',
      name: 'enterYourPasswordAgain',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Already have account?`
  String get alreadyhaveAnAcconuts {
    return Intl.message(
      'Already have account?',
      name: 'alreadyhaveAnAcconuts',
      desc: '',
      args: [],
    );
  }

  /// `Choose a plan`
  String get choceaplan {
    return Intl.message(
      'Choose a plan',
      name: 'choceaplan',
      desc: '',
      args: [],
    );
  }

  /// `All Basic Features`
  String get allBasicFeature {
    return Intl.message(
      'All Basic Features',
      name: 'allBasicFeature',
      desc: '',
      args: [],
    );
  }

  /// `Unlimited Invoices`
  String get unlimitedInvoices {
    return Intl.message(
      'Unlimited Invoices',
      name: 'unlimitedInvoices',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get getStarted {
    return Intl.message(
      'Get Started',
      name: 'getStarted',
      desc: '',
      args: [],
    );
  }

  /// `Current Plan`
  String get currentPlan {
    return Intl.message(
      'Current Plan',
      name: 'currentPlan',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password?`
  String get forgotpassword {
    return Intl.message(
      'Forgot password?',
      name: 'forgotpassword',
      desc: '',
      args: [],
    );
  }

  /// `Select Your Language`
  String get selectYourLanguage {
    return Intl.message(
      'Select Your Language',
      name: 'selectYourLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Shop Name`
  String get shopName {
    return Intl.message(
      'Shop Name',
      name: 'shopName',
      desc: '',
      args: [],
    );
  }

  /// `Enter your shop Name`
  String get enterShopName {
    return Intl.message(
      'Enter your shop Name',
      name: 'enterShopName',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get phone {
    return Intl.message(
      'Phone',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Enter your phone no.`
  String get enterPhoneNumber {
    return Intl.message(
      'Enter your phone no.',
      name: 'enterPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Billing Address`
  String get billingAddress {
    return Intl.message(
      'Billing Address',
      name: 'billingAddress',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullName {
    return Intl.message(
      'Full Name',
      name: 'fullName',
      desc: '',
      args: [],
    );
  }

  /// `Enter Full Name`
  String get enterFullName {
    return Intl.message(
      'Enter Full Name',
      name: 'enterFullName',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get type {
    return Intl.message(
      'Type',
      name: 'type',
      desc: '',
      args: [],
    );
  }

  /// `Full Address`
  String get fullAddress {
    return Intl.message(
      'Full Address',
      name: 'fullAddress',
      desc: '',
      args: [],
    );
  }

  /// `PIN CODE`
  String get pinCode {
    return Intl.message(
      'PIN CODE',
      name: 'pinCode',
      desc: '',
      args: [],
    );
  }

  /// `Enter PIN CODE`
  String get enterPinCode {
    return Intl.message(
      'Enter PIN CODE',
      name: 'enterPinCode',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get city {
    return Intl.message(
      'City',
      name: 'city',
      desc: '',
      args: [],
    );
  }

  /// `Enter Opening Balance.`
  String get enterOpeningBalance {
    return Intl.message(
      'Enter Opening Balance.',
      name: 'enterOpeningBalance',
      desc: '',
      args: [],
    );
  }

  /// `Shipping Address`
  String get shippingAddress {
    return Intl.message(
      'Shipping Address',
      name: 'shippingAddress',
      desc: '',
      args: [],
    );
  }

  /// `Landmark`
  String get landMark {
    return Intl.message(
      'Landmark',
      name: 'landMark',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Save & Publish`
  String get saveandPublished {
    return Intl.message(
      'Save & Publish',
      name: 'saveandPublished',
      desc: '',
      args: [],
    );
  }

  /// `Customer List`
  String get customerList {
    return Intl.message(
      'Customer List',
      name: 'customerList',
      desc: '',
      args: [],
    );
  }

  /// `Add Customer`
  String get addCustomer {
    return Intl.message(
      'Add Customer',
      name: 'addCustomer',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Are you want to delete this Customer?`
  String get areYouWantTodeleteThisCustomer {
    return Intl.message(
      'Are you want to delete this Customer?',
      name: 'areYouWantTodeleteThisCustomer',
      desc: '',
      args: [],
    );
  }

  /// `No Customer Found`
  String get noCustomerFound {
    return Intl.message(
      'No Customer Found',
      name: 'noCustomerFound',
      desc: '',
      args: [],
    );
  }

  /// `Party Name`
  String get partyName {
    return Intl.message(
      'Party Name',
      name: 'partyName',
      desc: '',
      args: [],
    );
  }

  /// `Party Type`
  String get partyType {
    return Intl.message(
      'Party Type',
      name: 'partyType',
      desc: '',
      args: [],
    );
  }

  /// `Due`
  String get due {
    return Intl.message(
      'Due',
      name: 'due',
      desc: '',
      args: [],
    );
  }

  /// `Customer Name`
  String get customerName {
    return Intl.message(
      'Customer Name',
      name: 'customerName',
      desc: '',
      args: [],
    );
  }

  /// `Enter Customer Name`
  String get enterCustomerName {
    return Intl.message(
      'Enter Customer Name',
      name: 'enterCustomerName',
      desc: '',
      args: [],
    );
  }

  /// `Enter zip`
  String get enterZip {
    return Intl.message(
      'Enter zip',
      name: 'enterZip',
      desc: '',
      args: [],
    );
  }

  /// `Enter Landmark`
  String get enterLandMark {
    return Intl.message(
      'Enter Landmark',
      name: 'enterLandMark',
      desc: '',
      args: [],
    );
  }

  /// `Customer`
  String get customer {
    return Intl.message(
      'Customer',
      name: 'customer',
      desc: '',
      args: [],
    );
  }

  /// `Suppliers`
  String get suppliers {
    return Intl.message(
      'Suppliers',
      name: 'suppliers',
      desc: '',
      args: [],
    );
  }

  /// `Collect Due >`
  String get collectdue {
    return Intl.message(
      'Collect Due >',
      name: 'collectdue',
      desc: '',
      args: [],
    );
  }

  /// `No Due Transaction Found`
  String get nodueTrasactionFound {
    return Intl.message(
      'No Due Transaction Found',
      name: 'nodueTrasactionFound',
      desc: '',
      args: [],
    );
  }

  /// `Create Payment`
  String get createPayments {
    return Intl.message(
      'Create Payment',
      name: 'createPayments',
      desc: '',
      args: [],
    );
  }

  /// `Grand Total`
  String get grandTotal {
    return Intl.message(
      'Grand Total',
      name: 'grandTotal',
      desc: '',
      args: [],
    );
  }

  /// `Paying Amount`
  String get payingAmount {
    return Intl.message(
      'Paying Amount',
      name: 'payingAmount',
      desc: '',
      args: [],
    );
  }

  /// `Enter Paid Amount`
  String get enterPaymentAmount {
    return Intl.message(
      'Enter Paid Amount',
      name: 'enterPaymentAmount',
      desc: '',
      args: [],
    );
  }

  /// `Change Amount`
  String get changeAmount {
    return Intl.message(
      'Change Amount',
      name: 'changeAmount',
      desc: '',
      args: [],
    );
  }

  /// `Due Amount`
  String get dueAmonunt {
    return Intl.message(
      'Due Amount',
      name: 'dueAmonunt',
      desc: '',
      args: [],
    );
  }

  /// `Payment Type`
  String get paymentType {
    return Intl.message(
      'Payment Type',
      name: 'paymentType',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Enter Expense Category`
  String get enterExpenseCategory {
    return Intl.message(
      'Enter Expense Category',
      name: 'enterExpenseCategory',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid data`
  String get pleaseEnterValidData {
    return Intl.message(
      'Please enter valid data',
      name: 'pleaseEnterValidData',
      desc: '',
      args: [],
    );
  }

  /// `Category Name`
  String get categoryName {
    return Intl.message(
      'Category Name',
      name: 'categoryName',
      desc: '',
      args: [],
    );
  }

  /// `Category Name`
  String get enterCategoryName {
    return Intl.message(
      'Category Name',
      name: 'enterCategoryName',
      desc: '',
      args: [],
    );
  }

  /// `Descaription`
  String get description {
    return Intl.message(
      'Descaription',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Add Description....`
  String get adddescription {
    return Intl.message(
      'Add Description....',
      name: 'adddescription',
      desc: '',
      args: [],
    );
  }

  /// `Expense Category List`
  String get expenseCategoryList {
    return Intl.message(
      'Expense Category List',
      name: 'expenseCategoryList',
      desc: '',
      args: [],
    );
  }

  /// `Add Category`
  String get addCategory {
    return Intl.message(
      'Add Category',
      name: 'addCategory',
      desc: '',
      args: [],
    );
  }

  /// `Show:`
  String get show {
    return Intl.message(
      'Show:',
      name: 'show',
      desc: '',
      args: [],
    );
  }

  /// `Search...`
  String get search {
    return Intl.message(
      'Search...',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Action`
  String get action {
    return Intl.message(
      'Action',
      name: 'action',
      desc: '',
      args: [],
    );
  }

  /// `Are you want to delete this Customer?`
  String get areYouWantTodeletethisCusotmer {
    return Intl.message(
      'Are you want to delete this Customer?',
      name: 'areYouWantTodeletethisCusotmer',
      desc: '',
      args: [],
    );
  }

  /// `No Expense Category Found`
  String get noExpenseCategoryFound {
    return Intl.message(
      'No Expense Category Found',
      name: 'noExpenseCategoryFound',
      desc: '',
      args: [],
    );
  }

  /// `Expense Details`
  String get expenseDetails {
    return Intl.message(
      'Expense Details',
      name: 'expenseDetails',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get category {
    return Intl.message(
      'Category',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  /// `Reference No`
  String get referenceNumber {
    return Intl.message(
      'Reference No',
      name: 'referenceNumber',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message(
      'Amount',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `Note`
  String get note {
    return Intl.message(
      'Note',
      name: 'note',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get nam {
    return Intl.message(
      'Name',
      name: 'nam',
      desc: '',
      args: [],
    );
  }

  /// `Income`
  String get income {
    return Intl.message(
      'Income',
      name: 'income',
      desc: '',
      args: [],
    );
  }

  /// `Add/Update Expense List`
  String get addUpdateExpanseList {
    return Intl.message(
      'Add/Update Expense List',
      name: 'addUpdateExpanseList',
      desc: '',
      args: [],
    );
  }

  /// `Expense Date`
  String get expenseDate {
    return Intl.message(
      'Expense Date',
      name: 'expenseDate',
      desc: '',
      args: [],
    );
  }

  /// `Enter expense date`
  String get enterExpenseDate {
    return Intl.message(
      'Enter expense date',
      name: 'enterExpenseDate',
      desc: '',
      args: [],
    );
  }

  /// `Expense For`
  String get expenseFor {
    return Intl.message(
      'Expense For',
      name: 'expenseFor',
      desc: '',
      args: [],
    );
  }

  /// `Enter Name`
  String get entername {
    return Intl.message(
      'Enter Name',
      name: 'entername',
      desc: '',
      args: [],
    );
  }

  /// `Enter Amount`
  String get enterAmount {
    return Intl.message(
      'Enter Amount',
      name: 'enterAmount',
      desc: '',
      args: [],
    );
  }

  /// `Enter Reference Number`
  String get enterReferenceNumber {
    return Intl.message(
      'Enter Reference Number',
      name: 'enterReferenceNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter Note`
  String get enterNote {
    return Intl.message(
      'Enter Note',
      name: 'enterNote',
      desc: '',
      args: [],
    );
  }

  /// `Between`
  String get between {
    return Intl.message(
      'Between',
      name: 'between',
      desc: '',
      args: [],
    );
  }

  /// `To`
  String get to {
    return Intl.message(
      'To',
      name: 'to',
      desc: '',
      args: [],
    );
  }

  /// `Total Expense`
  String get totalExpense {
    return Intl.message(
      'Total Expense',
      name: 'totalExpense',
      desc: '',
      args: [],
    );
  }

  /// `Expense List`
  String get expenseList {
    return Intl.message(
      'Expense List',
      name: 'expenseList',
      desc: '',
      args: [],
    );
  }

  /// `Expense Category`
  String get expenseCategory {
    return Intl.message(
      'Expense Category',
      name: 'expenseCategory',
      desc: '',
      args: [],
    );
  }

  /// `New Expense`
  String get newExpnense {
    return Intl.message(
      'New Expense',
      name: 'newExpnense',
      desc: '',
      args: [],
    );
  }

  /// `Created by`
  String get createdby {
    return Intl.message(
      'Created by',
      name: 'createdby',
      desc: '',
      args: [],
    );
  }

  /// `View`
  String get view {
    return Intl.message(
      'View',
      name: 'view',
      desc: '',
      args: [],
    );
  }

  /// `No Expense Found`
  String get noExpenseFound {
    return Intl.message(
      'No Expense Found',
      name: 'noExpenseFound',
      desc: '',
      args: [],
    );
  }

  /// `Expense`
  String get expense {
    return Intl.message(
      'Expense',
      name: 'expense',
      desc: '',
      args: [],
    );
  }

  /// `Total Sales`
  String get totalSales {
    return Intl.message(
      'Total Sales',
      name: 'totalSales',
      desc: '',
      args: [],
    );
  }

  /// `Purchase`
  String get purchase {
    return Intl.message(
      'Purchase',
      name: 'purchase',
      desc: '',
      args: [],
    );
  }

  /// `New Customers`
  String get newCustomer {
    return Intl.message(
      'New Customers',
      name: 'newCustomer',
      desc: '',
      args: [],
    );
  }

  /// `Daily Sales`
  String get dailySales {
    return Intl.message(
      'Daily Sales',
      name: 'dailySales',
      desc: '',
      args: [],
    );
  }

  /// `Daily Collection`
  String get dailyCollection {
    return Intl.message(
      'Daily Collection',
      name: 'dailyCollection',
      desc: '',
      args: [],
    );
  }

  /// `Instant Privacy`
  String get inistantPrivacy {
    return Intl.message(
      'Instant Privacy',
      name: 'inistantPrivacy',
      desc: '',
      args: [],
    );
  }

  /// `Stock Inventory`
  String get stockInventory {
    return Intl.message(
      'Stock Inventory',
      name: 'stockInventory',
      desc: '',
      args: [],
    );
  }

  /// `Stock value`
  String get stockvalue {
    return Intl.message(
      'Stock value',
      name: 'stockvalue',
      desc: '',
      args: [],
    );
  }

  /// `Low Stocks`
  String get lowStocks {
    return Intl.message(
      'Low Stocks',
      name: 'lowStocks',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get other {
    return Intl.message(
      'Other',
      name: 'other',
      desc: '',
      args: [],
    );
  }

  /// `Other Income`
  String get otherIncome {
    return Intl.message(
      'Other Income',
      name: 'otherIncome',
      desc: '',
      args: [],
    );
  }

  /// `COUNTER SALE`
  String get counterSale {
    return Intl.message(
      'COUNTER SALE',
      name: 'counterSale',
      desc: '',
      args: [],
    );
  }

  /// `Enter Income Category`
  String get enterIncomeCategory {
    return Intl.message(
      'Enter Income Category',
      name: 'enterIncomeCategory',
      desc: '',
      args: [],
    );
  }

  /// `Income Category List`
  String get incomeCategoryList {
    return Intl.message(
      'Income Category List',
      name: 'incomeCategoryList',
      desc: '',
      args: [],
    );
  }

  /// `No Income Category Found`
  String get noIncomeCategoryFound {
    return Intl.message(
      'No Income Category Found',
      name: 'noIncomeCategoryFound',
      desc: '',
      args: [],
    );
  }

  /// `Income Details`
  String get incomeDetails {
    return Intl.message(
      'Income Details',
      name: 'incomeDetails',
      desc: '',
      args: [],
    );
  }

  /// `Add Update Income List`
  String get addUpdateIncomeList {
    return Intl.message(
      'Add Update Income List',
      name: 'addUpdateIncomeList',
      desc: '',
      args: [],
    );
  }

  /// `Income Date`
  String get incomeDate {
    return Intl.message(
      'Income Date',
      name: 'incomeDate',
      desc: '',
      args: [],
    );
  }

  /// `Enter Income Date`
  String get enterIncomeDate {
    return Intl.message(
      'Enter Income Date',
      name: 'enterIncomeDate',
      desc: '',
      args: [],
    );
  }

  /// `Income for`
  String get incomefor {
    return Intl.message(
      'Income for',
      name: 'incomefor',
      desc: '',
      args: [],
    );
  }

  /// `Total Income`
  String get totalIncome {
    return Intl.message(
      'Total Income',
      name: 'totalIncome',
      desc: '',
      args: [],
    );
  }

  /// `Income List`
  String get incomeList {
    return Intl.message(
      'Income List',
      name: 'incomeList',
      desc: '',
      args: [],
    );
  }

  /// `Income category`
  String get incomeCategory {
    return Intl.message(
      'Income category',
      name: 'incomeCategory',
      desc: '',
      args: [],
    );
  }

  /// `New Income`
  String get newIncome {
    return Intl.message(
      'New Income',
      name: 'newIncome',
      desc: '',
      args: [],
    );
  }

  /// `No Income Found`
  String get noIncomeFound {
    return Intl.message(
      'No Income Found',
      name: 'noIncomeFound',
      desc: '',
      args: [],
    );
  }

  /// `Print Invoice`
  String get printInvoice {
    return Intl.message(
      'Print Invoice',
      name: 'printInvoice',
      desc: '',
      args: [],
    );
  }

  /// `Money Receipt`
  String get moneyReciept {
    return Intl.message(
      'Money Receipt',
      name: 'moneyReciept',
      desc: '',
      args: [],
    );
  }

  /// `Bill to:`
  String get billTo {
    return Intl.message(
      'Bill to:',
      name: 'billTo',
      desc: '',
      args: [],
    );
  }

  /// `Invoice No.`
  String get incvoiceNumber {
    return Intl.message(
      'Invoice No.',
      name: 'incvoiceNumber',
      desc: '',
      args: [],
    );
  }

  /// `Total Dues`
  String get totalDues {
    return Intl.message(
      'Total Dues',
      name: 'totalDues',
      desc: '',
      args: [],
    );
  }

  /// `Paid Amount`
  String get paidAmount {
    return Intl.message(
      'Paid Amount',
      name: 'paidAmount',
      desc: '',
      args: [],
    );
  }

  /// `Remaining Due`
  String get RemainingDue {
    return Intl.message(
      'Remaining Due',
      name: 'RemainingDue',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Charge`
  String get DeliveryCharge {
    return Intl.message(
      'Delivery Charge',
      name: 'DeliveryCharge',
      desc: '',
      args: [],
    );
  }

  /// `Invoice`
  String get invoice {
    return Intl.message(
      'Invoice',
      name: 'invoice',
      desc: '',
      args: [],
    );
  }

  /// `Product`
  String get product {
    return Intl.message(
      'Product',
      name: 'product',
      desc: '',
      args: [],
    );
  }

  /// `Quantity`
  String get quantity {
    return Intl.message(
      'Quantity',
      name: 'quantity',
      desc: '',
      args: [],
    );
  }

  /// `Unit Price`
  String get unitPrice {
    return Intl.message(
      'Unit Price',
      name: 'unitPrice',
      desc: '',
      args: [],
    );
  }

  /// `Total Price`
  String get totalPrice {
    return Intl.message(
      'Total Price',
      name: 'totalPrice',
      desc: '',
      args: [],
    );
  }

  /// `Sub Total`
  String get subTotal {
    return Intl.message(
      'Sub Total',
      name: 'subTotal',
      desc: '',
      args: [],
    );
  }

  /// `Total Vat`
  String get totalVat {
    return Intl.message(
      'Total Vat',
      name: 'totalVat',
      desc: '',
      args: [],
    );
  }

  /// `Total Discount`
  String get totalDiscount {
    return Intl.message(
      'Total Discount',
      name: 'totalDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Total Payable`
  String get totalPayable {
    return Intl.message(
      'Total Payable',
      name: 'totalPayable',
      desc: '',
      args: [],
    );
  }

  /// `Paid`
  String get paid {
    return Intl.message(
      'Paid',
      name: 'paid',
      desc: '',
      args: [],
    );
  }

  /// `Service Charge`
  String get serviceCharge {
    return Intl.message(
      'Service Charge',
      name: 'serviceCharge',
      desc: '',
      args: [],
    );
  }

  /// `Invoice No.`
  String get invoiceno {
    return Intl.message(
      'Invoice No.',
      name: 'invoiceno',
      desc: '',
      args: [],
    );
  }

  /// `Remaining Due`
  String get remainingDue {
    return Intl.message(
      'Remaining Due',
      name: 'remainingDue',
      desc: '',
      args: [],
    );
  }

  /// `Total Purchase`
  String get totalPurchase {
    return Intl.message(
      'Total Purchase',
      name: 'totalPurchase',
      desc: '',
      args: [],
    );
  }

  /// `Receive Amount`
  String get reciveAmount {
    return Intl.message(
      'Receive Amount',
      name: 'reciveAmount',
      desc: '',
      args: [],
    );
  }

  /// `Customer Due`
  String get customerDue {
    return Intl.message(
      'Customer Due',
      name: 'customerDue',
      desc: '',
      args: [],
    );
  }

  /// `Supplier Due`
  String get supplierDue {
    return Intl.message(
      'Supplier Due',
      name: 'supplierDue',
      desc: '',
      args: [],
    );
  }

  /// `No Transaction Found`
  String get noTransactionFound {
    return Intl.message(
      'No Transaction Found',
      name: 'noTransactionFound',
      desc: '',
      args: [],
    );
  }

  /// `Item name`
  String get itemName {
    return Intl.message(
      'Item name',
      name: 'itemName',
      desc: '',
      args: [],
    );
  }

  /// `Purchase Price`
  String get purchasePrice {
    return Intl.message(
      'Purchase Price',
      name: 'purchasePrice',
      desc: '',
      args: [],
    );
  }

  /// `Sale Price`
  String get salePrice {
    return Intl.message(
      'Sale Price',
      name: 'salePrice',
      desc: '',
      args: [],
    );
  }

  /// `Profit`
  String get profit {
    return Intl.message(
      'Profit',
      name: 'profit',
      desc: '',
      args: [],
    );
  }

  /// `Loss`
  String get loss {
    return Intl.message(
      'Loss',
      name: 'loss',
      desc: '',
      args: [],
    );
  }

  /// `Total Profit`
  String get toalProfit {
    return Intl.message(
      'Total Profit',
      name: 'toalProfit',
      desc: '',
      args: [],
    );
  }

  /// `Total Loss`
  String get totalLoss {
    return Intl.message(
      'Total Loss',
      name: 'totalLoss',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'Total Discount' key

  /// `Unpaid`
  String get unpaid {
    return Intl.message(
      'Unpaid',
      name: 'unpaid',
      desc: '',
      args: [],
    );
  }

  /// `Loss/Profit`
  String get lossProfit {
    return Intl.message(
      'Loss/Profit',
      name: 'lossProfit',
      desc: '',
      args: [],
    );
  }

  /// `Total Amount`
  String get totalAmount {
    return Intl.message(
      'Total Amount',
      name: 'totalAmount',
      desc: '',
      args: [],
    );
  }

  /// `Sale amount`
  String get saleAmont {
    return Intl.message(
      'Sale amount',
      name: 'saleAmont',
      desc: '',
      args: [],
    );
  }

  /// `Pay amount`
  String get payAmont {
    return Intl.message(
      'Pay amount',
      name: 'payAmont',
      desc: '',
      args: [],
    );
  }

  /// `Profit(+)`
  String get profitplus {
    return Intl.message(
      'Profit(+)',
      name: 'profitplus',
      desc: '',
      args: [],
    );
  }

  /// `Profit(-)`
  String get lossminus {
    return Intl.message(
      'Profit(-)',
      name: 'lossminus',
      desc: '',
      args: [],
    );
  }

  /// `Your Payment is canceled`
  String get yourPaymentisCancelled {
    return Intl.message(
      'Your Payment is canceled',
      name: 'yourPaymentisCancelled',
      desc: '',
      args: [],
    );
  }

  /// `Your Payment is successfully`
  String get yourPaymentisSuccesful {
    return Intl.message(
      'Your Payment is successfully',
      name: 'yourPaymentisSuccesful',
      desc: '',
      args: [],
    );
  }

  /// `Hold`
  String get hold {
    return Intl.message(
      'Hold',
      name: 'hold',
      desc: '',
      args: [],
    );
  }

  /// `Hold Number`
  String get holdNumber {
    return Intl.message(
      'Hold Number',
      name: 'holdNumber',
      desc: '',
      args: [],
    );
  }

  /// `Previous Due:`
  String get previousDue {
    return Intl.message(
      'Previous Due:',
      name: 'previousDue',
      desc: '',
      args: [],
    );
  }

  /// `Product Name`
  String get produactName {
    return Intl.message(
      'Product Name',
      name: 'produactName',
      desc: '',
      args: [],
    );
  }

  /// `Select Serial Number`
  String get selectSerialNumber {
    return Intl.message(
      'Select Serial Number',
      name: 'selectSerialNumber',
      desc: '',
      args: [],
    );
  }

  /// `Search Serial Number`
  String get searchSerialNumber {
    return Intl.message(
      'Search Serial Number',
      name: 'searchSerialNumber',
      desc: '',
      args: [],
    );
  }

  /// `Serial Numbers`
  String get serialNumbers {
    return Intl.message(
      'Serial Numbers',
      name: 'serialNumbers',
      desc: '',
      args: [],
    );
  }

  /// `Selected Serial Numbers`
  String get selectedSerialNumber {
    return Intl.message(
      'Selected Serial Numbers',
      name: 'selectedSerialNumber',
      desc: '',
      args: [],
    );
  }

  /// `No Serial Number Found`
  String get noSerailNumberFound {
    return Intl.message(
      'No Serial Number Found',
      name: 'noSerailNumberFound',
      desc: '',
      args: [],
    );
  }

  /// `Previous Due:`
  String get perviousDue {
    return Intl.message(
      'Previous Due:',
      name: 'perviousDue',
      desc: '',
      args: [],
    );
  }

  /// `Calculator:`
  String get calculator {
    return Intl.message(
      'Calculator:',
      name: 'calculator',
      desc: '',
      args: [],
    );
  }

  /// `Dashboard`
  String get dashBoard {
    return Intl.message(
      'Dashboard',
      name: 'dashBoard',
      desc: '',
      args: [],
    );
  }

  /// `Invoice:`
  String get invoices {
    return Intl.message(
      'Invoice:',
      name: 'invoices',
      desc: '',
      args: [],
    );
  }

  /// `Search Serial No or Category`
  String get searchSerailNumberorCategory {
    return Intl.message(
      'Search Serial No or Category',
      name: 'searchSerailNumberorCategory',
      desc: '',
      args: [],
    );
  }

  /// `Service/Shipping`
  String get serviceorshiping {
    return Intl.message(
      'Service/Shipping',
      name: 'serviceorshiping',
      desc: '',
      args: [],
    );
  }

  /// `CGST`
  String get csgst {
    return Intl.message(
      'CGST',
      name: 'csgst',
      desc: '',
      args: [],
    );
  }

  /// `SGST`
  String get sgst {
    return Intl.message(
      'SGST',
      name: 'sgst',
      desc: '',
      args: [],
    );
  }

  /// `IGST`
  String get igst {
    return Intl.message(
      'IGST',
      name: 'igst',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid Discount`
  String get enterValidDiscount {
    return Intl.message(
      'Enter a valid Discount',
      name: 'enterValidDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Please Add Some Product first`
  String get pleaseaddSomeProductFirst {
    return Intl.message(
      'Please Add Some Product first',
      name: 'pleaseaddSomeProductFirst',
      desc: '',
      args: [],
    );
  }

  /// `Are you want to create this Quotation?`
  String get areYouWantToCreateThisQuantition {
    return Intl.message(
      'Are you want to create this Quotation?',
      name: 'areYouWantToCreateThisQuantition',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get create {
    return Intl.message(
      'Create',
      name: 'create',
      desc: '',
      args: [],
    );
  }

  /// `Update your plan first\nSale Limit is over.`
  String get updateYourPlanFirstSaleLimitIsOver {
    return Intl.message(
      'Update your plan first\\nSale Limit is over.',
      name: 'updateYourPlanFirstSaleLimitIsOver',
      desc: '',
      args: [],
    );
  }

  /// `Add Product`
  String get addProduct {
    return Intl.message(
      'Add Product',
      name: 'addProduct',
      desc: '',
      args: [],
    );
  }

  /// `Are you want to delete this Product?`
  String get areyourSureYourWantToDeleteTheProduct {
    return Intl.message(
      'Are you want to delete this Product?',
      name: 'areyourSureYourWantToDeleteTheProduct',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get price {
    return Intl.message(
      'Price',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `Discount`
  String get discount {
    return Intl.message(
      'Discount',
      name: 'discount',
      desc: '',
      args: [],
    );
  }

  /// `Quotation`
  String get quotation {
    return Intl.message(
      'Quotation',
      name: 'quotation',
      desc: '',
      args: [],
    );
  }

  /// `Payment`
  String get payment {
    return Intl.message(
      'Payment',
      name: 'payment',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categorys {
    return Intl.message(
      'Categories',
      name: 'categorys',
      desc: '',
      args: [],
    );
  }

  /// `NEFT Number`
  String get nEFTNumber {
    return Intl.message(
      'NEFT Number',
      name: 'nEFTNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter NEFT Number`
  String get enterNEFTNumber {
    return Intl.message(
      'Enter NEFT Number',
      name: 'enterNEFTNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter Paid Amounts`
  String get enterPaidAmonts {
    return Intl.message(
      'Enter Paid Amounts',
      name: 'enterPaidAmonts',
      desc: '',
      args: [],
    );
  }

  /// `Total Product`
  String get totalProduct {
    return Intl.message(
      'Total Product',
      name: 'totalProduct',
      desc: '',
      args: [],
    );
  }

  /// `Add Item Category`
  String get addItemCategory {
    return Intl.message(
      'Add Item Category',
      name: 'addItemCategory',
      desc: '',
      args: [],
    );
  }

  /// `Select Variations:`
  String get selectVariations {
    return Intl.message(
      'Select Variations:',
      name: 'selectVariations',
      desc: '',
      args: [],
    );
  }

  /// `Size`
  String get size {
    return Intl.message(
      'Size',
      name: 'size',
      desc: '',
      args: [],
    );
  }

  /// `Color`
  String get color {
    return Intl.message(
      'Color',
      name: 'color',
      desc: '',
      args: [],
    );
  }

  /// `Weight`
  String get weight {
    return Intl.message(
      'Weight',
      name: 'weight',
      desc: '',
      args: [],
    );
  }

  /// `Capacity`
  String get capacity {
    return Intl.message(
      'Capacity',
      name: 'capacity',
      desc: '',
      args: [],
    );
  }

  /// `Warranty`
  String get warranty {
    return Intl.message(
      'Warranty',
      name: 'warranty',
      desc: '',
      args: [],
    );
  }

  /// `Add Brand`
  String get addBrand {
    return Intl.message(
      'Add Brand',
      name: 'addBrand',
      desc: '',
      args: [],
    );
  }

  /// `Brand Name`
  String get brandName {
    return Intl.message(
      'Brand Name',
      name: 'brandName',
      desc: '',
      args: [],
    );
  }

  /// `Enter Brand Name`
  String get enterbrandName {
    return Intl.message(
      'Enter Brand Name',
      name: 'enterbrandName',
      desc: '',
      args: [],
    );
  }

  /// `Add Unit`
  String get addUnit {
    return Intl.message(
      'Add Unit',
      name: 'addUnit',
      desc: '',
      args: [],
    );
  }

  /// `Unit Name`
  String get unitName {
    return Intl.message(
      'Unit Name',
      name: 'unitName',
      desc: '',
      args: [],
    );
  }

  /// `Enter Unit Name`
  String get enterUnitName {
    return Intl.message(
      'Enter Unit Name',
      name: 'enterUnitName',
      desc: '',
      args: [],
    );
  }

  /// `Product Name`
  String get productNam {
    return Intl.message(
      'Product Name',
      name: 'productNam',
      desc: '',
      args: [],
    );
  }

  /// `Enter Product Name`
  String get enterProductName {
    return Intl.message(
      'Enter Product Name',
      name: 'enterProductName',
      desc: '',
      args: [],
    );
  }

  /// `Product Size`
  String get productSize {
    return Intl.message(
      'Product Size',
      name: 'productSize',
      desc: '',
      args: [],
    );
  }

  /// `Enter Product Size`
  String get enterProductSize {
    return Intl.message(
      'Enter Product Size',
      name: 'enterProductSize',
      desc: '',
      args: [],
    );
  }

  /// `Product Color`
  String get productColor {
    return Intl.message(
      'Product Color',
      name: 'productColor',
      desc: '',
      args: [],
    );
  }

  /// `Enter Product Color`
  String get enterProductColor {
    return Intl.message(
      'Enter Product Color',
      name: 'enterProductColor',
      desc: '',
      args: [],
    );
  }

  /// `Enter Product Weight`
  String get enterProductWeight {
    return Intl.message(
      'Enter Product Weight',
      name: 'enterProductWeight',
      desc: '',
      args: [],
    );
  }

  /// `Product Weight`
  String get productWeight {
    return Intl.message(
      'Product Weight',
      name: 'productWeight',
      desc: '',
      args: [],
    );
  }

  /// `Product Capacity`
  String get productCapacity {
    return Intl.message(
      'Product Capacity',
      name: 'productCapacity',
      desc: '',
      args: [],
    );
  }

  /// `Enter Product Capacity`
  String get enterProductCapacity {
    return Intl.message(
      'Enter Product Capacity',
      name: 'enterProductCapacity',
      desc: '',
      args: [],
    );
  }

  /// `Product Type`
  String get productType {
    return Intl.message(
      'Product Type',
      name: 'productType',
      desc: '',
      args: [],
    );
  }

  /// `Enter Product Type`
  String get enterProductType {
    return Intl.message(
      'Enter Product Type',
      name: 'enterProductType',
      desc: '',
      args: [],
    );
  }

  /// `Product Warranty`
  String get productWarranty {
    return Intl.message(
      'Product Warranty',
      name: 'productWarranty',
      desc: '',
      args: [],
    );
  }

  /// `Enter Warranty`
  String get enterWarranty {
    return Intl.message(
      'Enter Warranty',
      name: 'enterWarranty',
      desc: '',
      args: [],
    );
  }

  /// `Select Warranty Time`
  String get selectWarrantyTime {
    return Intl.message(
      'Select Warranty Time',
      name: 'selectWarrantyTime',
      desc: '',
      args: [],
    );
  }

  /// `Brand`
  String get brand {
    return Intl.message(
      'Brand',
      name: 'brand',
      desc: '',
      args: [],
    );
  }

  /// `Select Product Brand`
  String get selectProductBrand {
    return Intl.message(
      'Select Product Brand',
      name: 'selectProductBrand',
      desc: '',
      args: [],
    );
  }

  /// `Product Code`
  String get productCodes {
    return Intl.message(
      'Product Code',
      name: 'productCodes',
      desc: '',
      args: [],
    );
  }

  /// `Enter Product Code`
  String get enterProductCode {
    return Intl.message(
      'Enter Product Code',
      name: 'enterProductCode',
      desc: '',
      args: [],
    );
  }

  /// `Quantity*`
  String get quantitys {
    return Intl.message(
      'Quantity*',
      name: 'quantitys',
      desc: '',
      args: [],
    );
  }

  /// `Enter Quantity`
  String get enterQuantity {
    return Intl.message(
      'Enter Quantity',
      name: 'enterQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Product Unit`
  String get productUnit {
    return Intl.message(
      'Product Unit',
      name: 'productUnit',
      desc: '',
      args: [],
    );
  }

  /// `Purchase Price*`
  String get purchasePrices {
    return Intl.message(
      'Purchase Price*',
      name: 'purchasePrices',
      desc: '',
      args: [],
    );
  }

  /// `Enter Purchase Price`
  String get enterPurchasePrice {
    return Intl.message(
      'Enter Purchase Price',
      name: 'enterPurchasePrice',
      desc: '',
      args: [],
    );
  }

  /// `Sale Price*`
  String get salePrices {
    return Intl.message(
      'Sale Price*',
      name: 'salePrices',
      desc: '',
      args: [],
    );
  }

  /// `Enter Sale Price`
  String get enterSalePrice {
    return Intl.message(
      'Enter Sale Price',
      name: 'enterSalePrice',
      desc: '',
      args: [],
    );
  }

  /// `Dealer Price`
  String get dealerPice {
    return Intl.message(
      'Dealer Price',
      name: 'dealerPice',
      desc: '',
      args: [],
    );
  }

  /// `Enter Dealer Price`
  String get enterDealerPrice {
    return Intl.message(
      'Enter Dealer Price',
      name: 'enterDealerPrice',
      desc: '',
      args: [],
    );
  }

  /// `WholeSale Price`
  String get wholeSalePrice {
    return Intl.message(
      'WholeSale Price',
      name: 'wholeSalePrice',
      desc: '',
      args: [],
    );
  }

  /// `Manufacturer`
  String get menufetather {
    return Intl.message(
      'Manufacturer',
      name: 'menufetather',
      desc: '',
      args: [],
    );
  }

  /// `Enter Manufacturer Name`
  String get enterMenuFeatherName {
    return Intl.message(
      'Enter Manufacturer Name',
      name: 'enterMenuFeatherName',
      desc: '',
      args: [],
    );
  }

  /// `NSN/SAC`
  String get nsnorsac {
    return Intl.message(
      'NSN/SAC',
      name: 'nsnorsac',
      desc: '',
      args: [],
    );
  }

  /// `Enter NSN/SAC`
  String get enternanorSac {
    return Intl.message(
      'Enter NSN/SAC',
      name: 'enternanorSac',
      desc: '',
      args: [],
    );
  }

  /// `Serial Number`
  String get serialNumber {
    return Intl.message(
      'Serial Number',
      name: 'serialNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter Serial Number`
  String get enterserialNumber {
    return Intl.message(
      'Enter Serial Number',
      name: 'enterserialNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter Product Serial Number :`
  String get enterProductSerialNumber {
    return Intl.message(
      'Enter Product Serial Number :',
      name: 'enterProductSerialNumber',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `No Serial Number Found`
  String get noSerialNumberFound {
    return Intl.message(
      'No Serial Number Found',
      name: 'noSerialNumberFound',
      desc: '',
      args: [],
    );
  }

  /// `Enter Price`
  String get enterPrice {
    return Intl.message(
      'Enter Price',
      name: 'enterPrice',
      desc: '',
      args: [],
    );
  }

  /// `ProductCategory`
  String get productCategory {
    return Intl.message(
      'ProductCategory',
      name: 'productCategory',
      desc: '',
      args: [],
    );
  }

  /// `Enter Product Quantity`
  String get enterProductQuantity {
    return Intl.message(
      'Enter Product Quantity',
      name: 'enterProductQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Unit`
  String get unit {
    return Intl.message(
      'Unit',
      name: 'unit',
      desc: '',
      args: [],
    );
  }

  /// `Product List`
  String get productList {
    return Intl.message(
      'Product List',
      name: 'productList',
      desc: '',
      args: [],
    );
  }

  /// `SearchCustomer`
  String get searchCustomer {
    return Intl.message(
      'SearchCustomer',
      name: 'searchCustomer',
      desc: '',
      args: [],
    );
  }

  /// `Product Name`
  String get productName {
    return Intl.message(
      'Product Name',
      name: 'productName',
      desc: '',
      args: [],
    );
  }

  /// `Dealer`
  String get dealer {
    return Intl.message(
      'Dealer',
      name: 'dealer',
      desc: '',
      args: [],
    );
  }

  /// `Retailer`
  String get reTailer {
    return Intl.message(
      'Retailer',
      name: 'reTailer',
      desc: '',
      args: [],
    );
  }

  /// `No Product Found`
  String get noProductFound {
    return Intl.message(
      'No Product Found',
      name: 'noProductFound',
      desc: '',
      args: [],
    );
  }

  /// `Stock`
  String get stock {
    return Intl.message(
      'Stock',
      name: 'stock',
      desc: '',
      args: [],
    );
  }

  /// `Enter Stock Amount`
  String get enterStockAmount {
    return Intl.message(
      'Enter Stock Amount',
      name: 'enterStockAmount',
      desc: '',
      args: [],
    );
  }

  /// `Discount Price`
  String get discountPrice {
    return Intl.message(
      'Discount Price',
      name: 'discountPrice',
      desc: '',
      args: [],
    );
  }

  /// `Enter Discount Price`
  String get enterDiscountPrice {
    return Intl.message(
      'Enter Discount Price',
      name: 'enterDiscountPrice',
      desc: '',
      args: [],
    );
  }

  /// `Price/unit`
  String get priceorUnit {
    return Intl.message(
      'Price/unit',
      name: 'priceorUnit',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message(
      'Status',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Preview`
  String get preview {
    return Intl.message(
      'Preview',
      name: 'preview',
      desc: '',
      args: [],
    );
  }

  /// `Enter Wholesale Price`
  String get enterWholeSalePrice {
    return Intl.message(
      'Enter Wholesale Price',
      name: 'enterWholeSalePrice',
      desc: '',
      args: [],
    );
  }

  /// `Adding Serial Number? `
  String get addingSerialNumber {
    return Intl.message(
      'Adding Serial Number? ',
      name: 'addingSerialNumber',
      desc: '',
      args: [],
    );
  }

  /// `Name or Code or Category`
  String get nameorcodeorCategory {
    return Intl.message(
      'Name or Code or Category',
      name: 'nameorcodeorCategory',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message(
      'Total',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `Edit/Add Serial:`
  String get editAddorSerial {
    return Intl.message(
      'Edit/Add Serial:',
      name: 'editAddorSerial',
      desc: '',
      args: [],
    );
  }

  /// `Quotation`
  String get quatation {
    return Intl.message(
      'Quotation',
      name: 'quatation',
      desc: '',
      args: [],
    );
  }

  /// `Purchase List`
  String get purchaseList {
    return Intl.message(
      'Purchase List',
      name: 'purchaseList',
      desc: '',
      args: [],
    );
  }

  /// `Print`
  String get print {
    return Intl.message(
      'Print',
      name: 'print',
      desc: '',
      args: [],
    );
  }

  /// `No Purchase Transaction Found`
  String get noPurchaseTransactionFound {
    return Intl.message(
      'No Purchase Transaction Found',
      name: 'noPurchaseTransactionFound',
      desc: '',
      args: [],
    );
  }

  /// `Quotation List`
  String get quotationList {
    return Intl.message(
      'Quotation List',
      name: 'quotationList',
      desc: '',
      args: [],
    );
  }

  /// `Are you want to delete this Quotation?`
  String get areyouwanttodeletethisQuotation {
    return Intl.message(
      'Are you want to delete this Quotation?',
      name: 'areyouwanttodeletethisQuotation',
      desc: '',
      args: [],
    );
  }

  /// `Convert to sale`
  String get convertToSale {
    return Intl.message(
      'Convert to sale',
      name: 'convertToSale',
      desc: '',
      args: [],
    );
  }

  /// `No Quotation Found`
  String get noQuotationFound {
    return Intl.message(
      'No Quotation Found',
      name: 'noQuotationFound',
      desc: '',
      args: [],
    );
  }

  /// `Stock Report`
  String get stockReport {
    return Intl.message(
      'Stock Report',
      name: 'stockReport',
      desc: '',
      args: [],
    );
  }

  /// `PRODUCT NAME`
  String get PRODUCTNAME {
    return Intl.message(
      'PRODUCT NAME',
      name: 'PRODUCTNAME',
      desc: '',
      args: [],
    );
  }

  /// `CATEGORY`
  String get CATEGORY {
    return Intl.message(
      'CATEGORY',
      name: 'CATEGORY',
      desc: '',
      args: [],
    );
  }

  /// `PRICE`
  String get PRICE {
    return Intl.message(
      'PRICE',
      name: 'PRICE',
      desc: '',
      args: [],
    );
  }

  /// `QTY`
  String get QTY {
    return Intl.message(
      'QTY',
      name: 'QTY',
      desc: '',
      args: [],
    );
  }

  /// `STATUS`
  String get STATUS {
    return Intl.message(
      'STATUS',
      name: 'STATUS',
      desc: '',
      args: [],
    );
  }

  /// `TOTAL VALUE`
  String get TOTALVALUE {
    return Intl.message(
      'TOTAL VALUE',
      name: 'TOTALVALUE',
      desc: '',
      args: [],
    );
  }

  /// `No Report Found`
  String get noReportFound {
    return Intl.message(
      'No Report Found',
      name: 'noReportFound',
      desc: '',
      args: [],
    );
  }

  /// `Remaining Balance`
  String get remainingBalance {
    return Intl.message(
      'Remaining Balance',
      name: 'remainingBalance',
      desc: '',
      args: [],
    );
  }

  /// `Total Payment Out`
  String get totalPaymentOut {
    return Intl.message(
      'Total Payment Out',
      name: 'totalPaymentOut',
      desc: '',
      args: [],
    );
  }

  /// `Total Payment In`
  String get totalPaymentIn {
    return Intl.message(
      'Total Payment In',
      name: 'totalPaymentIn',
      desc: '',
      args: [],
    );
  }

  /// `Payment In`
  String get paymentIn {
    return Intl.message(
      'Payment In',
      name: 'paymentIn',
      desc: '',
      args: [],
    );
  }

  /// `Payment Out`
  String get paymentout {
    return Intl.message(
      'Payment Out',
      name: 'paymentout',
      desc: '',
      args: [],
    );
  }

  /// `Balance`
  String get balance {
    return Intl.message(
      'Balance',
      name: 'balance',
      desc: '',
      args: [],
    );
  }

  /// `Daily Transaction`
  String get dailyTransantion {
    return Intl.message(
      'Daily Transaction',
      name: 'dailyTransantion',
      desc: '',
      args: [],
    );
  }

  /// `Total Collected`
  String get totalCollected {
    return Intl.message(
      'Total Collected',
      name: 'totalCollected',
      desc: '',
      args: [],
    );
  }

  /// `Total Receive`
  String get totalRecive {
    return Intl.message(
      'Total Receive',
      name: 'totalRecive',
      desc: '',
      args: [],
    );
  }

  /// `Due Transaction`
  String get dueTransaction {
    return Intl.message(
      'Due Transaction',
      name: 'dueTransaction',
      desc: '',
      args: [],
    );
  }

  /// `Add Due`
  String get addDue {
    return Intl.message(
      'Add Due',
      name: 'addDue',
      desc: '',
      args: [],
    );
  }

  /// `Select Practise`
  String get selectParctise {
    return Intl.message(
      'Select Practise',
      name: 'selectParctise',
      desc: '',
      args: [],
    );
  }

  /// `Customer Type`
  String get customerType {
    return Intl.message(
      'Customer Type',
      name: 'customerType',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get details {
    return Intl.message(
      'Details',
      name: 'details',
      desc: '',
      args: [],
    );
  }

  /// `Please Add Customer.`
  String get pleaseAddCusotmer {
    return Intl.message(
      'Please Add Customer.',
      name: 'pleaseAddCusotmer',
      desc: '',
      args: [],
    );
  }

  /// `TRANSACTION`
  String get TRANSACTION {
    return Intl.message(
      'TRANSACTION',
      name: 'TRANSACTION',
      desc: '',
      args: [],
    );
  }

  /// `Add Purchase`
  String get addPurchase {
    return Intl.message(
      'Add Purchase',
      name: 'addPurchase',
      desc: '',
      args: [],
    );
  }

  /// `Sale Transactions (Quotation Sale History)`
  String get saleTransactionquationSaleHistory {
    return Intl.message(
      'Sale Transactions (Quotation Sale History)',
      name: 'saleTransactionquationSaleHistory',
      desc: '',
      args: [],
    );
  }

  /// `ADD SALE`
  String get ADDSALE {
    return Intl.message(
      'ADD SALE',
      name: 'ADDSALE',
      desc: '',
      args: [],
    );
  }

  /// `Transaction Report`
  String get transactionReport {
    return Intl.message(
      'Transaction Report',
      name: 'transactionReport',
      desc: '',
      args: [],
    );
  }

  /// `Sale Transaction`
  String get saleTransantion {
    return Intl.message(
      'Sale Transaction',
      name: 'saleTransantion',
      desc: '',
      args: [],
    );
  }

  /// `Sale List`
  String get saleList {
    return Intl.message(
      'Sale List',
      name: 'saleList',
      desc: '',
      args: [],
    );
  }

  /// `No Sale Transaction Found`
  String get noSaleTransactionFound {
    return Intl.message(
      'No Sale Transaction Found',
      name: 'noSaleTransactionFound',
      desc: '',
      args: [],
    );
  }

  /// `Shipping/Service`
  String get shipingorServices {
    return Intl.message(
      'Shipping/Service',
      name: 'shipingorServices',
      desc: '',
      args: [],
    );
  }

  /// `Vat/GST`
  String get vatGST {
    return Intl.message(
      'Vat/GST',
      name: 'vatGST',
      desc: '',
      args: [],
    );
  }

  /// `Supplier List`
  String get suplaierList {
    return Intl.message(
      'Supplier List',
      name: 'suplaierList',
      desc: '',
      args: [],
    );
  }

  /// `ADD Supplier`
  String get addSupplaier {
    return Intl.message(
      'ADD Supplier',
      name: 'addSupplaier',
      desc: '',
      args: [],
    );
  }

  /// `Add User Role`
  String get addUserRole {
    return Intl.message(
      'Add User Role',
      name: 'addUserRole',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Ledger`
  String get ledger {
    return Intl.message(
      'Ledger',
      name: 'ledger',
      desc: '',
      args: [],
    );
  }

  /// `Profile Edit`
  String get profileEdit {
    return Intl.message(
      'Profile Edit',
      name: 'profileEdit',
      desc: '',
      args: [],
    );
  }

  /// `Sales`
  String get sales {
    return Intl.message(
      'Sales',
      name: 'sales',
      desc: '',
      args: [],
    );
  }

  /// `Practise`
  String get practise {
    return Intl.message(
      'Practise',
      name: 'practise',
      desc: '',
      args: [],
    );
  }

  /// `Stocks`
  String get stocks {
    return Intl.message(
      'Stocks',
      name: 'stocks',
      desc: '',
      args: [],
    );
  }

  /// `Reports`
  String get reports {
    return Intl.message(
      'Reports',
      name: 'reports',
      desc: '',
      args: [],
    );
  }

  /// `Due List`
  String get dueList {
    return Intl.message(
      'Due List',
      name: 'dueList',
      desc: '',
      args: [],
    );
  }

  /// `Sales List`
  String get salesList {
    return Intl.message(
      'Sales List',
      name: 'salesList',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Confirm Password`
  String get enterYourConfirmPassord {
    return Intl.message(
      'Enter Your Confirm Password',
      name: 'enterYourConfirmPassord',
      desc: '',
      args: [],
    );
  }

  /// `User Title`
  String get userTitle {
    return Intl.message(
      'User Title',
      name: 'userTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your User Title`
  String get enterYourUserTitle {
    return Intl.message(
      'Enter Your User Title',
      name: 'enterYourUserTitle',
      desc: '',
      args: [],
    );
  }

  /// `User Role Name`
  String get userRoleName {
    return Intl.message(
      'User Role Name',
      name: 'userRoleName',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your User Role Name`
  String get enterYourUserRoleName {
    return Intl.message(
      'Enter Your User Role Name',
      name: 'enterYourUserRoleName',
      desc: '',
      args: [],
    );
  }

  /// `User Role Details`
  String get userRoleDetails {
    return Intl.message(
      'User Role Details',
      name: 'userRoleDetails',
      desc: '',
      args: [],
    );
  }

  /// `User Role`
  String get userRole {
    return Intl.message(
      'User Role',
      name: 'userRole',
      desc: '',
      args: [],
    );
  }

  /// `Enter User Role`
  String get enterUserRole {
    return Intl.message(
      'Enter User Role',
      name: 'enterUserRole',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Delete Successful`
  String get deleteSuccessful {
    return Intl.message(
      'Delete Successful',
      name: 'deleteSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `You have to RE-LOGIN on your account.`
  String get youhaveRELOGINonyouraccount {
    return Intl.message(
      'You have to RE-LOGIN on your account.',
      name: 'youhaveRELOGINonyouraccount',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get ok {
    return Intl.message(
      'Ok',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Add New User`
  String get addNewUser {
    return Intl.message(
      'Add New User',
      name: 'addNewUser',
      desc: '',
      args: [],
    );
  }

  /// `User Name`
  String get userName {
    return Intl.message(
      'User Name',
      name: 'userName',
      desc: '',
      args: [],
    );
  }

  /// `No User Found`
  String get noUserFound {
    return Intl.message(
      'No User Found',
      name: 'noUserFound',
      desc: '',
      args: [],
    );
  }

  /// `Your Due Sales`
  String get yourDueSales {
    return Intl.message(
      'Your Due Sales',
      name: 'yourDueSales',
      desc: '',
      args: [],
    );
  }

  /// `Date Time`
  String get dateTime {
    return Intl.message(
      'Date Time',
      name: 'dateTime',
      desc: '',
      args: [],
    );
  }

  /// `Sale Details`
  String get saleDetails {
    return Intl.message(
      'Sale Details',
      name: 'saleDetails',
      desc: '',
      args: [],
    );
  }

  /// `Walk-in Customer`
  String get walkInCustomer {
    return Intl.message(
      'Walk-in Customer',
      name: 'walkInCustomer',
      desc: '',
      args: [],
    );
  }

  /// `Item`
  String get item {
    return Intl.message(
      'Item',
      name: 'item',
      desc: '',
      args: [],
    );
  }

  /// `Qty`
  String get qty {
    return Intl.message(
      'Qty',
      name: 'qty',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message(
      'Camera',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `Your All Sales`
  String get yourAllSales {
    return Intl.message(
      'Your All Sales',
      name: 'yourAllSales',
      desc: '',
      args: [],
    );
  }

  /// `Shipping/Other`
  String get shipingorother {
    return Intl.message(
      'Shipping/Other',
      name: 'shipingorother',
      desc: '',
      args: [],
    );
  }

  /// `Add Item`
  String get addItem {
    return Intl.message(
      'Add Item',
      name: 'addItem',
      desc: '',
      args: [],
    );
  }

  /// `This customer has no due`
  String get thisCustomerHasnoDue {
    return Intl.message(
      'This customer has no due',
      name: 'thisCustomerHasnoDue',
      desc: '',
      args: [],
    );
  }

  /// `Please select a customer`
  String get pleaseSelectACustomer {
    return Intl.message(
      'Please select a customer',
      name: 'pleaseSelectACustomer',
      desc: '',
      args: [],
    );
  }

  /// `Please add a sale`
  String get pleaseAddaSale {
    return Intl.message(
      'Please add a sale',
      name: 'pleaseAddaSale',
      desc: '',
      args: [],
    );
  }

  /// `Due amount will show here`
  String get dueamountWillshowHere {
    return Intl.message(
      'Due amount will show here',
      name: 'dueamountWillshowHere',
      desc: '',
      args: [],
    );
  }

  /// `Your all sale list`
  String get yourAllSaleList {
    return Intl.message(
      'Your all sale list',
      name: 'yourAllSaleList',
      desc: '',
      args: [],
    );
  }

  /// `POS Sale`
  String get posSale {
    return Intl.message(
      'POS Sale',
      name: 'posSale',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get logOut {
    return Intl.message(
      'Log out',
      name: 'logOut',
      desc: '',
      args: [],
    );
  }

  /// `Cash & Bank`
  String get cashandBank {
    return Intl.message(
      'Cash & Bank',
      name: 'cashandBank',
      desc: '',
      args: [],
    );
  }

  /// `Cash in Hand`
  String get cashInHand {
    return Intl.message(
      'Cash in Hand',
      name: 'cashInHand',
      desc: '',
      args: [],
    );
  }

  /// `Bank Account's`
  String get bankAccounts {
    return Intl.message(
      'Bank Account\'s',
      name: 'bankAccounts',
      desc: '',
      args: [],
    );
  }

  /// `Creative Hub`
  String get creativeHub {
    return Intl.message(
      'Creative Hub',
      name: 'creativeHub',
      desc: '',
      args: [],
    );
  }

  /// `Open Cheques`
  String get openCheques {
    return Intl.message(
      'Open Cheques',
      name: 'openCheques',
      desc: '',
      args: [],
    );
  }

  /// `Loan Accounts`
  String get loanAccounts {
    return Intl.message(
      'Loan Accounts',
      name: 'loanAccounts',
      desc: '',
      args: [],
    );
  }

  /// `Due Collection`
  String get dueCollection {
    return Intl.message(
      'Due Collection',
      name: 'dueCollection',
      desc: '',
      args: [],
    );
  }

  /// `Customer of the month`
  String get customerOfTheMonth {
    return Intl.message(
      'Customer of the month',
      name: 'customerOfTheMonth',
      desc: '',
      args: [],
    );
  }

  /// `Top Selling Product`
  String get topSellingProduct {
    return Intl.message(
      'Top Selling Product',
      name: 'topSellingProduct',
      desc: '',
      args: [],
    );
  }

  /// `Your Current Package Will Expire in 5 Day`
  String get yourCurrentPackageWillExpireIn5days {
    return Intl.message(
      'Your Current Package Will Expire in 5 Day',
      name: 'yourCurrentPackageWillExpireIn5days',
      desc: '',
      args: [],
    );
  }

  /// `Your Package Will Expire Today`
  String get yourPackageWillBeExpireToday {
    return Intl.message(
      'Your Package Will Expire Today',
      name: 'yourPackageWillBeExpireToday',
      desc: '',
      args: [],
    );
  }

  /// `Please Purchase Again`
  String get pleasePurchaseAgain {
    return Intl.message(
      'Please Purchase Again',
      name: 'pleasePurchaseAgain',
      desc: '',
      args: [],
    );
  }

  /// `INVOICE`
  String get INVOICE {
    return Intl.message(
      'INVOICE',
      name: 'INVOICE',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'af'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'az'),
      Locale.fromSubtags(languageCode: 'bn'),
      Locale.fromSubtags(languageCode: 'bs'),
      Locale.fromSubtags(languageCode: 'cs'),
      Locale.fromSubtags(languageCode: 'da'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'el'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fa'),
      Locale.fromSubtags(languageCode: 'fi'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'he'),
      Locale.fromSubtags(languageCode: 'hi'),
      Locale.fromSubtags(languageCode: 'hr'),
      Locale.fromSubtags(languageCode: 'hu'),
      Locale.fromSubtags(languageCode: 'id'),
      Locale.fromSubtags(languageCode: 'it'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'kk'),
      Locale.fromSubtags(languageCode: 'km'),
      Locale.fromSubtags(languageCode: 'kn'),
      Locale.fromSubtags(languageCode: 'ko'),
      Locale.fromSubtags(languageCode: 'lo'),
      Locale.fromSubtags(languageCode: 'mr'),
      Locale.fromSubtags(languageCode: 'ms'),
      Locale.fromSubtags(languageCode: 'my'),
      Locale.fromSubtags(languageCode: 'ne'),
      Locale.fromSubtags(languageCode: 'nl'),
      Locale.fromSubtags(languageCode: 'pl'),
      Locale.fromSubtags(languageCode: 'pt'),
      Locale.fromSubtags(languageCode: 'ro'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'si'),
      Locale.fromSubtags(languageCode: 'sk'),
      Locale.fromSubtags(languageCode: 'sq'),
      Locale.fromSubtags(languageCode: 'sr'),
      Locale.fromSubtags(languageCode: 'sv'),
      Locale.fromSubtags(languageCode: 'sw'),
      Locale.fromSubtags(languageCode: 'ta'),
      Locale.fromSubtags(languageCode: 'th'),
      Locale.fromSubtags(languageCode: 'tr'),
      Locale.fromSubtags(languageCode: 'uk'),
      Locale.fromSubtags(languageCode: 'ur'),
      Locale.fromSubtags(languageCode: 'vi'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
