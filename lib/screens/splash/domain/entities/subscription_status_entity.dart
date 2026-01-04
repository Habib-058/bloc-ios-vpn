import 'package:bloc_vpn_ios/screens/splash/data/models/app_user_model.dart';

class SubscriptionStatus {
  final bool isSuccess;
  final AppUserModel? user;
  final String? errorMessage;

  const SubscriptionStatus({
    required this.isSuccess,
    this.user,
    this.errorMessage,
  });
}


