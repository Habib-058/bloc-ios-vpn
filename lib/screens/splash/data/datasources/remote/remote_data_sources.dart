import 'package:bloc_vpn_ios/screens/server/data/models/server_response_model.dart';
import 'package:bloc_vpn_ios/screens/splash/data/models/subscription_status_model.dart';
import 'package:bloc_vpn_ios/screens/splash/domain/entities/subscription_status_entity.dart';

import '../../../../../core/cache_repositories/auth_preferences_repository.dart';
import '../../../../../core/exceptions/api_exception.dart';
import '../../../../../core/network/api_service.dart';
import '../../../../../core/network/url_service.dart';
import '../../../../server/domain/entities/server_response_entity.dart';

abstract class SplashScreenRemoteDataSource {
  Future<SubscriptionStatus> getSubscriptionStatus();
  Future<ServerResponse> fetchPremiumServers();
  Future<ServerResponse> fetchFreeServers();
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
        message: 'Failed to fetch subscription status: ${e.toString()}',
      );
    }
  }

  @override
  Future<ServerResponse> fetchPremiumServers() async {
    try {
      final response = await apiService.get(
        UrlHelper.getPremiumServers,
        authToken: true,
        fromJson: (json) => ServerResponseModel.fromJson(json),
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

  @override
  Future<ServerResponse> fetchFreeServers() async {
    try {
      final response = await apiService.get(
        UrlHelper.getFreeServers,
        authToken: true,
        fromJson: (json) => ServerResponseModel.fromJson(json),
      );
      return response;
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(
        message: 'Failed to fetch free servers: ${e.toString()}',
      );
    }
  }

}