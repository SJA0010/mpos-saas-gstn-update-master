import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Repository/subscription_plan_repo.dart';
import '../model/subscription_plan_model.dart';

SubscriptionPlanRepo subscriptionRepo = SubscriptionPlanRepo();
final subscriptionPlanProvider = FutureProvider<List<SubscriptionPlanModel>>((ref) => subscriptionRepo.getAllSubscriptionPlans());
