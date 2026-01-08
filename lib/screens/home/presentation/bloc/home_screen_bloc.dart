import 'package:bloc/bloc.dart';
import 'package:bloc_vpn_ios/screens/home/domain/usecases/home_switch_protocol_usecase.dart';

import '../../../../core/vpn/enums/supported_protocol_list.dart';
import '../../domain/usecases/initialize_home_vpn_location_usecase.dart';
import 'home_screen_event.dart';
import 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  InitializeHomeVpnLocationUseCase initializeHomeVpnLocationUseCase;
  HomeSwitchProtocolUseCase homeSwitchProtocolUseCase;

  HomeScreenBloc({
    required this.initializeHomeVpnLocationUseCase,
    required this.homeSwitchProtocolUseCase,
  }) : super(HomeScreenState()) {
    on<OnInitHomeEvent>(_onInitHomeEvent);
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

  }
}
