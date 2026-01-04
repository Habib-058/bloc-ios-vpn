import 'package:bloc_vpn_ios/screens/splash/data/models/subscription_status_model.dart';
import 'package:bloc_vpn_ios/screens/splash/domain/entities/subscription_status_entity.dart';

import '../../../../../core/cache_repositories/auth_preferences_repository.dart';
import '../../../../../core/cache_repositories/server_cache_repositories/server_cache_repository.dart';
import '../../../../../core/exceptions/api_exception.dart';
import '../../../../../core/network/api_service.dart';
import '../../../../../core/network/url_service.dart';

abstract class SplashScreenRemoteDataSource {
  Future<SubscriptionStatus> getSubscriptionStatus();
}



class SplashScreenRemoteDataSourceImpl extends SplashScreenRemoteDataSource{
  final ApiService apiService;

  SplashScreenRemoteDataSourceImpl({required this.apiService});

  @override
  Future<SubscriptionStatus> getSubscriptionStatus() async {
    final socialToken = await AuthPreferencesRepository.getUserSocialToken() ?? "";

    try {
      final response = await apiService.get(
        UrlHelper.checkSubStatus(socialToken),
        authToken: true,
        fromJson: (json) => SubscriptionStatusModel.fromJson(json),
      );
      return response;
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(
        message: 'Failed to fetch premium servers: ${e.toString()}',
      );
    }
  }

}