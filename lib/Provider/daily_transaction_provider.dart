import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salespro_admin/Repository/daily_transaction_repo.dart';
import 'package:salespro_admin/model/daily_transaction_model.dart';

DailyTransactionRepo dailyTransitionRepo = DailyTransactionRepo();
final dailyTransactionProvider = FutureProvider.autoDispose<List<DailyTransactionModel>>((ref) => dailyTransitionRepo.getAllDailyTransition());
