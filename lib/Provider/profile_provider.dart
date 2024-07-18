import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Repository/profile_details_repo.dart';
import '../model/personal_information_model.dart';

ProfileRepo profileRepo = ProfileRepo();
final profileDetailsProvider = FutureProvider.autoDispose<PersonalInformationModel>((ref) => profileRepo.getDetails());
