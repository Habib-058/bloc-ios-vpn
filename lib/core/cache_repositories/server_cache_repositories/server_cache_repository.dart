import '../../utils/strings.dart';
import '../shared_preferences_repository.dart';

class ServerCacheRepository {
  static ServerCacheRepository? _instance;
  // static Box<ServerListResponseModel>? _box;

  ServerCacheRepository._();

  static ServerCacheRepository get instance {
    _instance ??= ServerCacheRepository._();
    return _instance!;
  }

  static const String _boxName = 'server_cache_box';
  static const String _freeServersKey = 'free_servers';
  static const String _premiumServersKey = 'premium_servers';

  // SharedPreferences keys for last refresh timestamps
  static const String _freeServersLastRefreshKey = 'free_servers_last_refresh';
  static const String _premiumServersLastRefreshKey = 'premium_servers_last_refresh';
  static const String _subscriptionStatusLastChecked = 'subscription_status_last_checked';
  static const String _subscriptionStatus = 'subscription_status';
  static const String _userToken = 'user_token';

  // Cache refresh interval: 6 hours
  static const Duration _cacheRefreshInterval = Duration(hours: 6);



}