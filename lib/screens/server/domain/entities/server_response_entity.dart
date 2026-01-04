import 'package:bloc_vpn_ios/screens/server/data/models/server_list_model.dart';
import 'package:bloc_vpn_ios/screens/server/domain/entities/server_list_entity.dart';

class ServerResponse {
  bool? isSuccess;
  List<ServerListModel>? response;
  String? errMessage;

  ServerResponse({this.isSuccess, this.response, this.errMessage});
}