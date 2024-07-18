import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salespro_admin/model/brands_model.dart';
import 'package:salespro_admin/model/category_model.dart';
import 'package:salespro_admin/model/unit_model.dart';

import '../Repository/product_repo.dart';
import '../model/product_model.dart';

ProductRepo productRepo = ProductRepo();
final productProvider = FutureProvider.autoDispose<List<ProductModel>>((ref) => productRepo.getAllProduct());
final categoryProvider = FutureProvider.autoDispose<List<CategoryModel>>((ref) => productRepo.getAllCategory());
final brandProvider = FutureProvider.autoDispose<List<BrandsModel>>((ref) => productRepo.getAllBrands());
final unitProvider = FutureProvider.autoDispose<List<UnitModel>>((ref) => productRepo.getAllUnits());
