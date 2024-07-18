import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Repository/seller_info_repo.dart';
import '../model/seller_info_model.dart';

SellerInfoRepo profileRepo = SellerInfoRepo();
final sellerInfoProvider = FutureProvider<List<SellerInfoModel>>((ref) => profileRepo.getAllSeller());
