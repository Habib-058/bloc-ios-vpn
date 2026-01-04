import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

class ConnectivityHelper {
  static final Connectivity _connectivity = Connectivity();
  static StreamSubscription<List<ConnectivityResult>>? _subscription;
  static bool _isDialogShowing = false;
  static BuildContext? _dialogContext;

  /// Check current connection status (one-time)
  static Future<bool> hasInternetConnection() async {
    List<ConnectivityResult> results = await _connectivity.checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }

  /// Initialize listener (should be called in main or home screen)
  static void initialize() {
    // Cancel old subscription if exists
    _subscription?.cancel();

    _subscription = _connectivity.onConnectivityChanged.listen(
          (List<ConnectivityResult> results) async {
        bool isOnline = !results.contains(ConnectivityResult.none);

        if (!isOnline && !_isDialogShowing) {
          _isDialogShowing = true;

          // Show No Internet Dialog
          // showCupertinoDialog(
          //   context: navigatorKey.currentContext!,
          //   barrierDismissible: false,
          //   builder: (BuildContext context) {
          //     _dialogContext = context;
          //     return CupertinoAlertDialog(
          //       title: const Text('No Internet Connection'),
          //       content: const Text('Please check your internet settings.'),
          //       actions: <Widget>[
          //         CupertinoDialogAction(
          //           isDefaultAction: true,
          //           onPressed: () {
          //             // Keep the dialog open
          //           },
          //           child: const Text('OK'),
          //         ),
          //       ],
          //     );
          //   },
          // );
        } else if (isOnline && _isDialogShowing) {
          // Close dialog automatically when reconnected
          if (_dialogContext != null) {
            Navigator.of(_dialogContext!, rootNavigator: true).pop();
            _dialogContext = null;
          }
          _isDialogShowing = false;
        }
      },
    );
  }

  /// Stop listening to connectivity changes
  static void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}