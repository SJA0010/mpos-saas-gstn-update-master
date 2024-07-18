import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Repository/get_user_role_repo.dart';
import '../model/user_role_model.dart';

UserRoleRepo repo = UserRoleRepo();
final userRoleProvider = FutureProvider.autoDispose<List<UserRoleModel>>((ref) => repo.getAllUserRole());
final allUserRoleProvider = FutureProvider.autoDispose<List<UserRoleModel>>((ref) => repo.getAllUserRoleFromAdmin());
