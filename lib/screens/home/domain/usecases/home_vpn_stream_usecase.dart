import 'dart:async';

import 'package:bloc_vpn_ios/core/vpn/vpn_connection_stage.dart';
import 'package:bloc_vpn_ios/core/vpn/vpn_connection_status.dart';
import 'package:bloc_vpn_ios/core/vpn/vpn_service.dart';

class HomeVpnStreamUseCase {
  StreamSubscription<CapVPNConnectionStage>? _stageSubscription;
  StreamSubscription<CapVPNConnectionStatus>? _statusSubscription;
  
  final _stageController = StreamController<CapVPNConnectionStage>.broadcast();
  final _statusController = StreamController<CapVPNConnectionStatus>.broadcast();

  /// Get stream of VPN stage changes
  Stream<CapVPNConnectionStage> get stageStream => _stageController.stream;

  /// Get stream of VPN status changes
  Stream<CapVPNConnectionStatus> get statusStream => _statusController.stream;

  /// Initialize stream listeners
  void initializeStreams() {
    // Cancel existing subscriptions if any
    _stageSubscription?.cancel();
    _statusSubscription?.cancel();

    // Listen to VPN stage stream
    _stageSubscription = VpnService().stageStream.listen((stage) {
      print("stageStream event: $stage");
      _stageController.add(stage);
    });

    // Listen to VPN status stream
    _statusSubscription = VpnService().statusStream.listen((status) {
      _statusController.add(status);
    });
  }

  /// Dispose resources
  void dispose() {
    _stageSubscription?.cancel();
    _statusSubscription?.cancel();
    _stageController.close();
    _statusController.close();
  }
}

