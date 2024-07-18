import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salespro_admin/Repository/expense_category_repo.dart';
import 'package:salespro_admin/model/expense_category_model.dart';
import 'package:salespro_admin/model/income_catehory_model.dart';

ExpenseCategoryRepo expenseCategoryRepo = ExpenseCategoryRepo();
final expenseCategoryProvider = FutureProvider.autoDispose<List<ExpenseCategoryModel>>((ref) => expenseCategoryRepo.getAllExpenseCategory());

IncomeCategoryRepo incomeCategoryRepo = IncomeCategoryRepo();
final incomeCategoryProvider = FutureProvider.autoDispose<List<IncomeCategoryModel>>((ref) => incomeCategoryRepo.getAllIncomeCategory());
