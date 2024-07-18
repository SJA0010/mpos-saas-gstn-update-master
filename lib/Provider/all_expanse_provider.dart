import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salespro_admin/Repository/get_expanse.dart';
import 'package:salespro_admin/model/expense_model.dart';

ExpenseRepo expanseRepo = ExpenseRepo();
final expenseProvider = FutureProvider.autoDispose<List<ExpenseModel>>((ref) => expanseRepo.getAllExpense());
