import '../../../../core/vpn/vpn_connection_stage.dart';
import '../../../../core/vpn/vpn_connection_status.dart';

class StageStatusEntity {
  final CapVPNConnectionStage stage;
  final CapVPNConnectionStatus status;

  StageStatusEntity({
    required this.stage,
    required this.status,
  });
}