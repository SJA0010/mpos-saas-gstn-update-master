import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Repository/transactions_repo.dart';
import '../model/due_transaction_model.dart';

DueTransitionRepo dueTransitionRepo = DueTransitionRepo();
final dueTransactionProvider = FutureProvider<List<DueTransactionModel>>((ref) => dueTransitionRepo.getAllTransition());
