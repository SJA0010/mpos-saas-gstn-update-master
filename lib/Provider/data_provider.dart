import 'package:flutter_riverpod/flutter_riverpod.dart';

final testProvider = StateProvider((ref) => UserRoleData());

class UserRoleData {
  String test = 'This is a data';
}
