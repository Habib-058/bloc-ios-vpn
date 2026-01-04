import 'package:bloc_vpn_ios/screens/server/data/models/server_list_model.dart';
import 'package:bloc_vpn_ios/screens/server/domain/entities/server_list_entity.dart';
import 'package:bloc_vpn_ios/screens/server/domain/entities/server_response_entity.dart';

class ServerResponseModel extends ServerResponse {
  ServerResponseModel({
    super.isSuccess,
    super.response,
    super.errMessage,
  });

  ServerResponseModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['response'] != null) {
      response = <ServerListModel>[];
      json['response'].forEach((v) {
        response!.add(ServerListModel.fromJson(v));
      });
    }
    errMessage = json['errMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    if (response != null) {
      data['response'] = response!.map((v) => v.toJson()).toList();
    }
    data['errMessage'] = errMessage;
    return data;
  }
}