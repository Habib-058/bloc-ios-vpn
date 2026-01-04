import 'package:bloc_vpn_ios/screens/server/data/models/server_model.dart';
import 'package:bloc_vpn_ios/screens/server/domain/entities/server_list_entity.dart';

class ServerListModel extends ServerList {
  ServerListModel({
    super.id,
    super.name,
    super.flagUrl,
    super.briefName,
    super.isExpanded,
    super.type,
    super.servers,
  });

  ServerListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    flagUrl = json['flagUrl'] ?? json['flag_url'];
    briefName = json['briefName'] ?? json['brief_name'];
    isExpanded = json['isExpanded'] ?? json['is_expanded'];
    type = json['type'];
    if (json['servers'] != null) {
      servers = <ServerModel>[];
      json['servers'].forEach((v) {
        servers!.add(ServerModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['flagUrl'] = flagUrl;
    data['briefName'] = briefName;
    data['isExpanded'] = isExpanded;
    data['type'] = type;
    if (servers != null) {
      data['servers'] = servers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
