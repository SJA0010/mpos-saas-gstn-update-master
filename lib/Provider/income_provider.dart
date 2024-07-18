import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salespro_admin/Repository/income_repo.dart';

import '../model/income_modle.dart';

IncomeRepo incomeRepo = IncomeRepo();
final incomeProvider = FutureProvider.autoDispose<List<IncomeModel>>((ref) => incomeRepo.getAllIncome());
