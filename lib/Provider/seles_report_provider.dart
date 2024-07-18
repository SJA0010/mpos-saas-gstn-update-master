import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Repository/sales_report_repo.dart';
import '../model/sales_report.dart';

SalesReportRepo salesReportRepo = SalesReportRepo();
final salesReportProvider = FutureProvider.autoDispose<List<SalesReport>>((ref) => salesReportRepo.getAllSalesReport());
