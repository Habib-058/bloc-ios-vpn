import 'package:equatable/equatable.dart';

import '../../../../core/vpn/vpn_connection_stage.dart';
import '../../../../core/vpn/vpn_connection_status.dart';
import '../../../server/data/models/server_model.dart';

class HomeScreenState extends Equatable {
  final bool isLoading;
  final String selectedServerName;
  final String selectedServerFlag;
  final ServerModel? vpnLocation;
  final CapVPNConnectionStage vpnStage;
  final CapVPNConnectionStatus? vpnStatus;
  final bool showTimer;

  const HomeScreenState({
    this.isLoading = false,
    this.selectedServerName = "",
    this.selectedServerFlag = "",
    this.vpnLocation,
    this.vpnStage = CapVPNConnectionStage.disconnected,
    this.vpnStatus,
    this.showTimer = false,
  });

  HomeScreenState copyWith({
    bool? isLoading,
    String? selectedServerName,
    String? selectedServerFlag,
    ServerModel? vpnLocation,
    CapVPNConnectionStage? vpnStage,
    CapVPNConnectionStatus? vpnStatus,
    bool? showTimer,
  }) {
    return HomeScreenState(
      isLoading: isLoading ?? this.isLoading,
      selectedServerName: selectedServerName ?? this.selectedServerName,
      selectedServerFlag: selectedServerFlag ?? this.selectedServerFlag,
      vpnLocation: vpnLocation ?? this.vpnLocation,
      vpnStage: vpnStage ?? this.vpnStage,
      vpnStatus: vpnStatus ?? this.vpnStatus,
      showTimer: showTimer ?? this.showTimer,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        selectedServerName,
        selectedServerFlag,
        vpnLocation,
        vpnStage,
        vpnStatus,
        showTimer,
      ];
}
