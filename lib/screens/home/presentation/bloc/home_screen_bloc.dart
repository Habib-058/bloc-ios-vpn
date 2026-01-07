import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../domain/usecases/initialize_home_vpn_location_usecase.dart';
import 'home_screen_event.dart';
import 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  InitializeHomeVpnLocationUseCase initializeHomeVpnLocationUseCase;

  HomeScreenBloc({required this.initializeHomeVpnLocationUseCase})
    : super(HomeScreenState()) {
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
  }
}
