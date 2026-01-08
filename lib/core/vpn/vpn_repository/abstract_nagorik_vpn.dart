import 'package:bloc_vpn_ios/core/vpn/vpn_connection_status.dart';

import '../vpn_connection_stage.dart';

abstract class NagorikVpn {
  void createInstance({
    Function(CapVPNConnectionStatus? data)? onConnectionStatusChanged,
    Function(CapVPNConnectionStage stage, String rawStage)?
    onConnectionStageChanged,
  });

  Future<void> initialize({
    String? providerBundleIdentifier,
    String? localizedDescription,
    String? groupIdentifier,
    Function(CapVPNConnectionStatus status)? onLastStatusChanged,
    Function(CapVPNConnectionStage stage)? onLastStageChanged,
  });

  Future<void> connect(
      String configString,
      String name, {
        String? ip,
        String? username,
        String? myBalance,
        String? isPremium,
        String? password,
        String? accessToken,
        String? deviceId,
        String? code,
        String? configId,
        String? port,
        String? method,
        String? host,
        String? passwordShadow,
        List<String>? bypassPackages,
        bool certIsRequired = false,
        String? endTime,
        List<String>? dnsList,
        required int balance,
      });

  Future<void> disconnect();

  Future<bool> get isConnected;

  Future<bool> requestPermissionAndroid();

  // Future<String> get oldHistory;

  Future<CapVPNConnectionStatus> getConnectionStatus();

  // Future<NagorikVpnConnectionStage> getConnectionStage();

  // Future<void> applyManagedAppConfiguration();

  // Future<void> updateVPNSettingsUI();

  Stream<CapVPNConnectionStage> vpnStageSnapshot();

  Stream<CapVPNConnectionStatus> vpnStatusSnapshot();

  bool get isInitialized;

// void initializeMethodCallHandler();
}