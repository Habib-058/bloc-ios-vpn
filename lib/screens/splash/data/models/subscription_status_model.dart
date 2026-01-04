import 'package:bloc_vpn_ios/screens/splash/data/models/app_user_model.dart';
import 'package:bloc_vpn_ios/screens/splash/domain/entities/subscription_status_entity.dart';

class SubscriptionStatusModel extends SubscriptionStatus {
  const SubscriptionStatusModel({
    required super.isSuccess,
    required super.user,
    required super.errorMessage,
});

  factory SubscriptionStatusModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionStatusModel(
      isSuccess: json['isSuccess'] ?? false,
      user: json['response'] != null
          ? AppUserModel.fromJson(json['response'])
          : null,
      errorMessage: json['errMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isSuccess': isSuccess,
      'response': user?.toJson(),
      'errMessage': errorMessage,
    };
  }

}