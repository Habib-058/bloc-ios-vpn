import 'dart:async';

import 'package:bloc_vpn_ios/core/vpn/vpn_connection_stage.dart';
import 'package:bloc_vpn_ios/core/vpn/vpn_connection_status.dart';
import 'package:bloc_vpn_ios/core/vpn/vpn_implimentation/vmess/vmess_protocol_impl.dart';

import 'enums/supported_protocol_list.dart';
import 'vpn_repository/abstract_nagorik_vpn.dart';

class VpnService {
  NagorikVpn? _engine;
  SupportedVpnProtocol? _currentProtocol;

  final _stageController =
  StreamController<CapVPNConnectionStage>.broadcast();
  final _statusController =
  StreamController<CapVPNConnectionStatus>.broadcast();

  NagorikVpn? get engine => _engine;
  SupportedVpnProtocol? get currentProtocol => _currentProtocol;

  Stream<CapVPNConnectionStage> get stageStream =>
      _stageController.stream;

  Stream<CapVPNConnectionStatus> get statusStream =>
      _statusController.stream;

  Future<void> switchProtocol(SupportedVpnProtocol protocol) async {
    try {
      await _engine?.disconnect();
    } catch (_) {}

    _engine = _createEngine(protocol);
    _currentProtocol = protocol;

    _engine?.createInstance(
      onConnectionStatusChanged: (status) {
        if (status != null) _statusController.add(status);
      },
      onConnectionStageChanged: (stage, _) {
        _stageController.add(stage);
      },
    );
  }

  NagorikVpn _createEngine(SupportedVpnProtocol protocol) {
    switch (protocol) {
      case SupportedVpnProtocol.vmess:
      case SupportedVpnProtocol.shadowsocks:
      case SupportedVpnProtocol.vless:
      default:
        return NagorikVpnVmessRepository();
    }
  }

  Future<void> initialize({
    String? providerBundleIdentifier,
    String? localizedDescription,
    String? groupIdentifier,
  }) async {
    await _engine?.initialize(
      providerBundleIdentifier: providerBundleIdentifier,
      localizedDescription: localizedDescription,
      groupIdentifier: groupIdentifier,
      onLastStageChanged: _stageController.add,
      onLastStatusChanged: _statusController.add,
    );
  }

  Future<void> connect(
      String configString,
      String name, {
        required int balance,
        List<String>? bypassPackages,
        List<String>? dnsList,
        bool certIsRequired = false,
        String? endTime,
      }) async {
    await _engine!.connect(
      configString,
      name,
      balance: balance,
      bypassPackages: bypassPackages,
      dnsList: dnsList,
      certIsRequired: certIsRequired,
      endTime: endTime,
    );
  }

  Future<void> disconnect() async {
    await _engine?.disconnect();
  }

  void dispose() {
    _stageController.close();
    _statusController.close();
  }
}
