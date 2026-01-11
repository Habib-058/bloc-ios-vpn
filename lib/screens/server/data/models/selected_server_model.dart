import 'package:bloc_vpn_ios/screens/server/data/models/server_model.dart';
import 'package:bloc_vpn_ios/screens/server/domain/entities/selected_server_entity.dart';

class SelectedServerModel extends SelectedServer {
  SelectedServerModel({
    super.countryName,
    super.server,
    super.flagUrl,
});

  Map<String, dynamic> toJson() {
    return {
      'countryName': countryName,
      'server': server?.toJson(),
      'flagUrl': flagUrl,
    };
  }

  factory SelectedServerModel.fromJson(Map<String, dynamic> json) {
    return SelectedServerModel(
      countryName: json['countryName'] ?? '',
      server: ServerModel.fromJson(json['server']),
      flagUrl: json['flagUrl'] ?? '',
    );
  }
}