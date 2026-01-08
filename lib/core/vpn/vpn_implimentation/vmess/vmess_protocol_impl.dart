import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_v2ray/flutter_v2ray.dart';
import 'package:flutter_v2ray/model/v2ray_status.dart';

import '../../vpn_connection_stage.dart';
import '../../vpn_connection_status.dart';
import '../../vpn_repository/abstract_nagorik_vpn.dart';

class NagorikVpnVmessRepository implements NagorikVpn {
  late Function(CapVPNConnectionStatus? data) onConnectionStatusChanged;
  late Function(CapVPNConnectionStage stage, String rawStage)
  onConnectionStageChanged;

  var methodChannel = MethodChannel('enova_v2ray/shadowsocks');
  StreamSubscription<dynamic>? _dataSubscription;
  static const EventChannel _eventChannelAppDelegate =
  EventChannel('vpn_data_usage_stream');

  FlutterV2ray? _engine;
  bool _initialized = false;
  Timer? _statusCheckTimer;
  final _vpnStatusStreamController =
  StreamController<CapVPNConnectionStatus>.broadcast();
  final _vpnStageStreamController =
  StreamController<CapVPNConnectionStage>.broadcast();
  CapVPNConnectionStage _currentStage = CapVPNConnectionStage.disconnected;
  String _currentRawStage = "DISCONNECTED";

  @override
  void createInstance({
    Function(CapVPNConnectionStatus? data)? onConnectionStatusChanged,
    Function(CapVPNConnectionStage stage, String rawStage)?
    onConnectionStageChanged,
  }) {
    this.onConnectionStatusChanged = onConnectionStatusChanged ?? (_) {};
    this.onConnectionStageChanged = onConnectionStageChanged ?? (_, __) {};

    _engine = FlutterV2ray(
      onStatusChanged: _handleStatusChange,
    );
    _startListening();
  }

  void _handleStatusChange(V2RayStatus status) {
    // Convert upload/download to MB
    final downloadMb = (status.download / (1024 * 1024)).toStringAsFixed(2);
    final uploadMb = (status.upload / (1024 * 1024)).toStringAsFixed(2);
    // final NagorikVpnConnectionStage stage = _mapStateToStage(status.state);
    // print("Current connection stage is: $stage");
    // if (_currentStage != stage) {
    //   _currentStage = stage;
    //   _currentRawStage = status.state;
    //   _vpnStageStreamController.add(_currentStage);
    //   onConnectionStageChanged(_currentStage, _currentRawStage);
    // }
  }

  Future<void> _startListening() async {
    // Cancel any existing subscription
    _dataSubscription?.cancel();

    _dataSubscription?.cancel();

    // Start a new subscription to the event channel
    _dataSubscription =
        _eventChannelAppDelegate.receiveBroadcastStream().listen(
              (event) {
            final Map<String, dynamic> data = Map<String, dynamic>.from(event);
            print("Received data VMess: $data");
            final status = _mapStatus(data);
            _vpnStatusStreamController.add(status);
            onConnectionStatusChanged(status);

            // _handleStatusChange(data['status']);

            final CapVPNConnectionStage stage = _mapStateToStage(data['status']);
            print("stage inside repooooooooo: $stage");
            print("_currentStage inside repooooooooo: $_currentStage");
            if (_currentStage != stage) {
              if (stage == CapVPNConnectionStage.disconnected &&
                  _currentStage == CapVPNConnectionStage.connecting) {
                _currentStage = CapVPNConnectionStage.connecting;
                _currentRawStage = data['status'];
                _vpnStageStreamController.add(_currentStage);
                onConnectionStageChanged(_currentStage, _currentRawStage);
              } else {
                _currentStage = stage;
                _currentRawStage = data['status'];
                _vpnStageStreamController.add(_currentStage);
                onConnectionStageChanged(_currentStage, _currentRawStage);
              }
            }
          },
          onError: (error) {
            print("Error receiving data: $error");
          },
          onDone: () {
            print("Stream closed");
          },
        );
  }

  CapVPNConnectionStatus _mapStatus(dynamic data) {
    final Map<String, dynamic> result = Map<String, dynamic>.from(data);

    // The sent and received values are already in MB
    String mbIn = result['received'].toString() ?? "0.00";
    String mbOut = result['sent'].toString() ?? "0.00";
    String duration = result['duration'].toString() ?? "0";

    //process the mb with division 8
    mbIn = (double.parse(mbIn) / 8).toStringAsFixed(2);
    mbOut = (double.parse(mbOut) / 8).toStringAsFixed(2);

    int durationSec = int.tryParse(duration) ?? 0;
    int hours = durationSec ~/ 3600;
    int minutes = (durationSec % 3600) ~/ 60;
    int seconds = durationSec % 60;
    String formattedDuration =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    // Create the NagorikVpnConnectionStatus object with the received values
    return CapVPNConnectionStatus(
      mbIn: "$mbIn MB",
      mbOut: "$mbOut MB",
      duration: formattedDuration,
    );
  }

  void _handleStageChange(String status) {
    print("hit _handleStageChange ${status}");
    final CapVPNConnectionStage stage = _mapStateToStage(status);
    print("Current connection stage is: $stage");
    print("Current _currentStage stage is: $_currentStage");
    if (stage == CapVPNConnectionStage.disconnected) {
      print("hit normal");
      _currentStage = CapVPNConnectionStage.disconnected;
      _currentRawStage = "DISCONNECTED";
      _vpnStageStreamController.add(_currentStage);
      onConnectionStageChanged(_currentStage, _currentRawStage);
      return;
    }
    if (_currentStage != stage) {
      print("hit special");
      _currentStage = stage;
      _currentRawStage = status;
      onConnectionStageChanged(_currentStage, _currentRawStage);
      _vpnStageStreamController.add(_currentStage);
    }
  }

  CapVPNConnectionStage _mapStateToStage(String state) {
    print("The connection string is: $state");
    switch (state.toUpperCase()) {
      case "CONNECTED":
        return CapVPNConnectionStage.connected;
      case "CONNECTING":
        return CapVPNConnectionStage.connecting;
      case "DISCONNECTED":
        return CapVPNConnectionStage.disconnected;
      case "DISCONNECTING":
        return CapVPNConnectionStage.disconnecting;
      case "ERROR":
        return CapVPNConnectionStage.error;
      default:
        return CapVPNConnectionStage.unknown;
    }
  }

  @override
  Future<void> initialize({
    String? providerBundleIdentifier,
    String? localizedDescription,
    String? groupIdentifier,
    Function(CapVPNConnectionStatus status)? onLastStatusChanged,
    Function(CapVPNConnectionStage stage)? onLastStageChanged,
  }) async {
    try {
      await _engine?.initializeV2Ray(
        notificationIconResourceType: "mipmap",
        notificationIconResourceName: "ic_launcher",
        providerBundleIdentifier: "com.capvpn.capp",
        groupIdentifier: groupIdentifier ?? "",
      );

      _initialized = true;

      // Call the last status and stage if provided
      // if (onLastStatusChanged != null) {
      //   onLastStatusChanged(_currentStatus);
      // }

      if (onLastStageChanged != null) {
        onLastStageChanged(_currentStage);
      }
    } catch (e) {
      print("Failed to initialize V2Ray: $e");
      _initialized = false;
      throw Exception("Failed to initialize VPN: $e");
    }
  }

  @override
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
      }) async {
    // print("Connecting to VPN with config: $configString");
    if (!_initialized) {
      throw Exception("VPN engine not initialized. Call initialize() first.");
    }

    bool permissionGranted = await _engine?.requestPermission() ?? false;
    if (!permissionGranted) {
      print("Permission not granted for VPN connection.");
      // Reset connection stage to disconnected when permission is denied
      _currentStage = CapVPNConnectionStage.disconnected;
      _currentRawStage = "DISCONNECTED";
      _vpnStageStreamController.add(_currentStage);
      onConnectionStageChanged(_currentStage, _currentRawStage);
      // Throw an exception so the caller can handle it
      throw Exception("VPN permission denied by user");
    }

    try {
      // Set the connection stage to connecting
      _currentStage = CapVPNConnectionStage.connecting;
      _currentRawStage = "CONNECTING";
      _vpnStageStreamController.add(_currentStage);
      onConnectionStageChanged(_currentStage, _currentRawStage);
      // print("gotEndTime : ${endTime.toString()} and isPremium: ${isPremium.toString()}");
      print("configString start: $configString configString end");

      await _engine?.startV2Ray(
        remark: name,
        config: configString,
        blockedApps: bypassPackages,
        proxyOnly: false,
        notificationDisconnectButtonName: "Disconnect",
        endTime: endTime,
        isPremium: isPremium,
        vpnBlocked: false,
        dnsList: dnsList,
        balance: balance,
      );
    } catch (e) {
      print("Failed to connect VPN: $e");
      // Set stage to error
      _currentStage = CapVPNConnectionStage.error;
      _currentRawStage = "ERROR";
      _vpnStageStreamController.add(_currentStage);
      onConnectionStageChanged(_currentStage, _currentRawStage);
      throw Exception("Failed to connect VPN: $e");
    }
  }

  @override
  Future<void> disconnect() async {
    if (!_initialized) return;

    try {
      // Set the connection stage to disconnecting
      _currentStage = CapVPNConnectionStage.disconnecting;
      _currentRawStage = "DISCONNECTING";
      _vpnStageStreamController.add(_currentStage);
      onConnectionStageChanged(_currentStage, _currentRawStage);

      await _engine?.stopV2Ray();

      _currentStage = CapVPNConnectionStage.disconnected;
      _currentRawStage = "DISCONNECTED";
      _vpnStageStreamController.add(_currentStage);
      onConnectionStageChanged(_currentStage, _currentRawStage);
    } catch (e) {
      print("Failed to disconnect VPN: $e");
    }
  }

  @override
  Future<bool> get isConnected async {
    if (!_initialized || _engine == null) return false;

    // There's no direct isConnected method in FlutterV2ray
    // Use the current stage to determine if connected
    return _currentStage == CapVPNConnectionStage.connected;
  }

  @override
  Future<bool> requestPermissionAndroid() async {
    if (_engine == null) return false;
    return await _engine!.requestPermission();
  }

  @override
  Stream<CapVPNConnectionStage> vpnStageSnapshot() {
    return _vpnStageStreamController.stream;
  }

  @override
  Stream<CapVPNConnectionStatus> vpnStatusSnapshot() {
    return _vpnStatusStreamController.stream;
  }

  @override
  bool get isInitialized => _initialized;

  // Dispose method to clean up resources when the repositories is no longer needed
  void dispose() {
    _statusCheckTimer?.cancel();
    _vpnStatusStreamController.close();
    _vpnStageStreamController.close();
  }

  @override
  Future<CapVPNConnectionStatus> getConnectionStatus() {
    // TODO: implement getConnectionStatus
    throw UnimplementedError();
  }
}