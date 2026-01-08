import 'package:equatable/equatable.dart';

import '../../../../core/vpn/vpn_connection_stage.dart';
import '../../../../core/vpn/vpn_connection_status.dart';

abstract class HomeScreenEvent extends Equatable {
  const HomeScreenEvent();

  @override
  List<Object?> get props => [];
}

class OnInitHomeEvent extends HomeScreenEvent {
  const OnInitHomeEvent();
}

class OnVpnStageChangedEvent extends HomeScreenEvent {
  final CapVPNConnectionStage stage;

  const OnVpnStageChangedEvent(this.stage);

  @override
  List<Object?> get props => [stage];
}

class OnVpnStatusChangedEvent extends HomeScreenEvent {
  final CapVPNConnectionStatus status;

  const OnVpnStatusChangedEvent(this.status);

  @override
  List<Object?> get props => [status];
}
