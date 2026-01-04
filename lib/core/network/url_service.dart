import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'env_config.dart';


abstract class UrlHelper {
  static final Map<String, String> envConfig = ConfigEnvironments.getEnvironments();
  static final String? baseUrlProduction = envConfig['url'];

  static void _init() {
    log("Current Environment from urlHelper: ${envConfig['env']}");
    log("Current URL from urlHelper: ${envConfig['url']}");
  }

  static final init = _init();

  static final String baseurl = kDebugMode
      ? "https://capvpn.site/api/"
      : "https://capvpn.site/api/";

  static final String getPremiumServers = "get_locations_ispremiumV2.php";
  static final String getFreeServers = "get_locationsV2.php";
  static final String contactUs = "send_email.php";
  // TODO: Replace with your actual list items endpoint
  static final String getListItems = "get_list_items.php";
}