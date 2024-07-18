import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Repository/transactions_repo.dart';
import '../model/transition_model.dart';

TransitionRepo transitionRepo = TransitionRepo();
final transitionProvider = FutureProvider.autoDispose<List<SaleTransactionModel>>((ref) => transitionRepo.getAllTransition());

QuotationRepo quotationRepo = QuotationRepo();

final quotationProvider = FutureProvider.autoDispose<List<SaleTransactionModel>>((ref) => quotationRepo.getAllQuotation());

PurchaseTransitionRepo purchaseTransitionRepo = PurchaseTransitionRepo();
final purchaseTransitionProvider = FutureProvider.autoDispose<List<dynamic>>((ref) => purchaseTransitionRepo.getAllTransition());

QuotationHistoryRepo quotationHistoryRepo = QuotationHistoryRepo();
final quotationHistoryProvider = FutureProvider.autoDispose<List<SaleTransactionModel>>((ref) => quotationHistoryRepo.getAllQuotationHistory());
