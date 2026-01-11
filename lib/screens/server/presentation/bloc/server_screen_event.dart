import 'package:equatable/equatable.dart';

abstract class ServerScreenEvent extends Equatable {
  const ServerScreenEvent();

  @override
  List<Object?> get props => [];
}

class OnInitServerScreenEvent extends ServerScreenEvent {
  const OnInitServerScreenEvent();
}

class FetchServersEvent extends ServerScreenEvent {
  const FetchServersEvent();
}
