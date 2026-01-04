import 'package:bloc_vpn_ios/screens/server/data/models/server_model.dart';
import 'package:bloc_vpn_ios/screens/server/domain/entities/server_entity.dart';

class ServerList {
  String? id;
  String? name;
  String? flagUrl;
  String? briefName;
  String? isExpanded;
  String? type;
  List<ServerModel>? servers;

  ServerList({
    this.id,
    this.name,
    this.flagUrl,
    this.briefName,
    this.isExpanded,
    this.type,
    this.servers,
  });
}
