import 'package:bloc_vpn_ios/screens/splash/domain/entities/user_entity.dart';

class AppUserModel extends AppUser {

   AppUserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.password,
    required super.googleId,
    required super.isSubscriptionStatus,
  });

   factory AppUserModel.fromJson(Map<String, dynamic> json) {
     return AppUserModel(
       id: json['id'] ?? 0,
       googleId: json['google_id'] ?? '',
       username: json['username'],
       password: json['password'],
       email: json['email'],
       isSubscriptionStatus: (json['isSubscriptionStatus'] ?? false) == 0 ? false:true ,
     );
   }

   Map<String, dynamic> toJson() {
     return {
       'id': id,
       'google_id': googleId,
       'username': username,
       'password': password,
       'email': email,
       'isSubscriptionStatus': isSubscriptionStatus,
     };
   }

}