import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'app_logger.dart';




/// Structured model for routing log entries
class RouteLogData {
  final String? routeName;
  final String action; // push, pop, replace, remove, unknown
  final String? previousRouteName;
  final Map<String, String>? argumentsTypes;
  final DateTime timestamp;

  RouteLogData({
    this.routeName,
    required this.action,
    this.previousRouteName,
    this.argumentsTypes,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    final json = {
      'action': action,
      'previousRoute': previousRouteName,
      'argumentsTypes': argumentsTypes,
      'timestamp': timestamp.toIso8601String(),
    };
    // Only include route when it is known
    if (routeName != null && routeName!.isNotEmpty) {
      json['route'] = routeName;
    }
    return json;
  }

  @override
  String toString() => jsonEncode(toJson());
}

/// A [RouteObserver] that emits ROUTING_INFO logs through a provided sink
class LoggingRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  final void Function(AppLogger log) onLog;

  LoggingRouteObserver({required this.onLog});

  String? _routeName(Route<dynamic>? route) {
    if (route == null) return null;
    return route.settings.name ?? route.settings.runtimeType.toString();
  }

  Map<String, String>? _argTypes(Object? arguments) {
    if (arguments == null) return null;
    if (arguments is Map) {
      final map = <String, String>{};
      arguments.forEach((key, value) {
        // Capture type only, never the value
        map['$key'] = value.runtimeType.toString();
      });
      return map;
    }
    return {'_': arguments.runtimeType.toString()};
  }

  void _emit(
    String action,
    Route<dynamic>? route,
    Route<dynamic>? previousRoute,
  ) {
    final data = RouteLogData(
      // If route name is unknown/null, omit it from the payload
      routeName: _routeName(route),
      action: action,
      previousRouteName: _routeName(previousRoute),
      argumentsTypes: _argTypes(route?.settings.arguments),
    );

    onLog(AppLogger(logType: LogType.ROUTING_INFO, data: data.toJson()));
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _emit('push', route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _emit('pop', previousRoute, route);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _emit('remove', previousRoute, route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _emit('replace', newRoute, oldRoute);
  }
}
