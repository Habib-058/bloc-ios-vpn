import 'package:dartz/dartz.dart';

abstract class UseCase<T, P> {
  Future<Either<dynamic, T>> call(P params);
}

// UseCase with no parameters
abstract class UseCaseNoParams<T> {
  Future<Either<dynamic, T>> call();
}

