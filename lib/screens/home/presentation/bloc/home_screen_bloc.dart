import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_vpn_ios/core/vpn/vpn_connection_stage.dart';
import 'package:bloc_vpn_ios/screens/home/domain/usecases/get_subscription_status_usecase.dart';
import 'package:bloc_vpn_ios/screens/home/domain/usecases/home_initialize_vpn_usecase.dart';
import 'package:bloc_vpn_ios/screens/home/domain/usecases/home_switch_protocol_usecase.dart';
import 'package:bloc_vpn_ios/screens/home/domain/usecases/home_vpn_stream_usecase.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/vpn/enums/supported_protocol_list.dart';
import '../../domain/usecases/initialize_home_vpn_location_usecase.dart';
import 'home_screen_event.dart';
import 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  final InitializeHomeVpnLocationUseCase initializeHomeVpnLocationUseCase;
  final HomeSwitchProtocolUseCase homeSwitchProtocolUseCase;
  final HomeInitializeVpnUseCase homeInitializeVpnUseCase;
  final HomeVpnStreamUseCase homeVpnStreamUseCase;
  final GetSubscriptionStatusUseCase getSubscriptionStatusUseCase;

  StreamSubscription? _vpnStageSubscription;
  StreamSubscription? _vpnStatusSubscription;

  HomeScreenBloc({
    required this.initializeHomeVpnLocationUseCase,
    required this.homeSwitchProtocolUseCase,
    required this.homeInitializeVpnUseCase,
    required this.homeVpnStreamUseCase,
    required this.getSubscriptionStatusUseCase,
  }) : super(HomeScreenState()) {
    on<OnInitHomeEvent>(_onInitHomeEvent);
    on<OnVpnStageChangedEvent>(_onVpnStageChanged);
    on<OnVpnStatusChangedEvent>(_onVpnStatusChanged);
    on<CheckVPNStatusAndTimerEvent>(_onCheckVPNStatusAndTimer);
    _setupVpnStreamListeners();
  }
  void _onInitHomeEvent(OnInitHomeEvent event, Emitter<HomeScreenState> emit) async {
    emit(
        state.copyWith(
          isLoading: true,
        )
    );
    final initialServer = await initializeHomeVpnLocationUseCase();
    emit(
        state.copyWith(
          isLoading: false,
          vpnLocation: initialServer,
        )
    );
    await homeSwitchProtocolUseCase(SupportedVpnProtocol.vmess);
    await homeInitializeVpnUseCase();
    
    // Check VPN status and timer after VPN initialization
    add(const CheckVPNStatusAndTimerEvent());
  }


  void _onVpnStageChanged(
    OnVpnStageChangedEvent event,
    Emitter<HomeScreenState> emit,
  ) {
    emit(state.copyWith(vpnStage: event.stage));
    
    // Check VPN status and timer when stage changes to connected
    if (event.stage == CapVPNConnectionStage.connected) {
      add(const CheckVPNStatusAndTimerEvent());
    }
  }

  void _onVpnStatusChanged(
    OnVpnStatusChangedEvent event,
    Emitter<HomeScreenState> emit,
  ) {
    emit(state.copyWith(vpnStatus: event.status));
  }

  /// Check VPN status and show timer if connected and not subscribed
  Future<void> _onCheckVPNStatusAndTimer(
    CheckVPNStatusAndTimerEvent event,
    Emitter<HomeScreenState> emit,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    
    if (state.vpnStage == CapVPNConnectionStage.connected) {
      debugPrint("Connected, config not null");
      
      // Get subscription status
      final isSubscribed = await getSubscriptionStatusUseCase();
      
      // Show timer only if not subscribed
      if (!isSubscribed) {
        emit(state.copyWith(showTimer: true));
      }
    }
  }

  void _setupVpnStreamListeners() {
    // Initialize stream listeners in use case
    homeVpnStreamUseCase.initializeStreams();

    // Listen to streams from use case
    _vpnStageSubscription = homeVpnStreamUseCase.stageStream.listen((stage) {
      add(OnVpnStageChangedEvent(stage));
    });

    _vpnStatusSubscription = homeVpnStreamUseCase.statusStream.listen((status) {
      add(OnVpnStatusChangedEvent(status));
    });
  }

  @override
  Future<void> close() {
    _vpnStageSubscription?.cancel();
    _vpnStatusSubscription?.cancel();
    homeVpnStreamUseCase.dispose();
    return super.close();
  }
}
