

import 'package:equatable/equatable.dart';

import '../../domain/entities/server_list_entity.dart';

class ServerScreenState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final ServerList? freeServers;
  final ServerList? premiumServers;

  const ServerScreenState({
    this.isLoading = false,
    this.errorMessage,
    this.freeServers,
    this.premiumServers,
  });

  ServerScreenState copyWith({
    bool? isLoading,
    String? errorMessage,
    ServerList? freeServers,
    ServerList? premiumServers,
  }) {
    return ServerScreenState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      freeServers: freeServers ?? this.freeServers,
      premiumServers: premiumServers ?? this.premiumServers,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, freeServers, premiumServers];

}
