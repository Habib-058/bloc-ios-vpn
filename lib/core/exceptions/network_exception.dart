import 'api_exception.dart';

class NetworkException extends ApiException {
  NetworkException({required super.message,  super.statusCode});
}