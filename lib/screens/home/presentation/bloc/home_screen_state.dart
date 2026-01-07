import 'package:equatable/equatable.dart';

import '../../../server/data/models/server_model.dart';

class HomeScreenState extends Equatable {
  final bool isLoading;
  final String selectedServerName;
  final String selectedServerFlag;
  final ServerModel? vpnLocation;
  const HomeScreenState({
    this.isLoading = false,
    this.selectedServerName = "",
    this.selectedServerFlag = "",
    this.vpnLocation
  });

  HomeScreenState copyWith({
    bool? isLoading,
    String? selectedServerName,
    String? selectedServerFlag,
    ServerModel? vpnLocation,
  }) {
    return HomeScreenState(
      isLoading: isLoading ?? this.isLoading,
      selectedServerName: selectedServerName ?? this.selectedServerName,
      selectedServerFlag: selectedServerFlag ?? this.selectedServerFlag,
      vpnLocation: vpnLocation ?? this.vpnLocation,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        selectedServerName,
        selectedServerFlag,
        vpnLocation,
      ];
}
