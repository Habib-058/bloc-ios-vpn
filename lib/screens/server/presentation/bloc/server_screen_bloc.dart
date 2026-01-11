import 'package:bloc/bloc.dart';

import '../../../../screens/home/domain/usecases/get_subscription_status_usecase.dart';
import '../../domain/usecases/fetch_free_servers_use_case.dart';
import '../../domain/usecases/fetch_premium_servers_use_case.dart';
import 'server_screen_event.dart';
import 'server_screen_state.dart';

class ServerScreenBloc extends Bloc<ServerScreenEvent, ServerScreenState> {
  final GetSubscriptionStatusUseCase getSubscriptionStatusUseCase;
  final FetchFreeServersUseCase fetchFreeServersUseCase;
  final FetchPremiumServersUseCase fetchPremiumServersUseCase;

  ServerScreenBloc({
    required this.getSubscriptionStatusUseCase,
    required this.fetchFreeServersUseCase,
    required this.fetchPremiumServersUseCase,
  }) : super(ServerScreenState()) {
    // on<OnInitServerScreenEvent>(_onInitServerScreen);
    on<FetchServersEvent>(_fetchServers);
  }

  Future<void> _fetchServers(
    FetchServersEvent event,
    Emitter<ServerScreenState> emit,
  ) async {
    // This can be used for refreshing servers
    emit(state.copyWith(isLoading: true));

    try {
      final freeServers = await fetchFreeServersUseCase();
      final premiumServers = await fetchPremiumServersUseCase();

      emit(
        state.copyWith(
          isLoading: false,
          freeServers: freeServers,
          premiumServers: premiumServers,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
