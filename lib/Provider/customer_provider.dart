import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Repository/customer_repo.dart';
import '../model/customer_model.dart';

CustomerRepo customerRepo = CustomerRepo();
final buyerCustomerProvider = FutureProvider.autoDispose<List<CustomerModel>>((ref) => customerRepo.getAllBuyer());
final allCustomerProvider = FutureProvider.autoDispose<List<CustomerModel>>((ref) => customerRepo.getAllCustomer());

final supplierProvider = FutureProvider.autoDispose<List<CustomerModel>>((ref) => customerRepo.getAllSupplier());
