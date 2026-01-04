import 'package:bloc_vpn_ios/screens/server/domain/entities/server_entity.dart';

class ServerModel extends Server {
  ServerModel({
    super.id,
    super.name,
    super.ip,
    super.address,
    super.ping,
    super.count,
    super.isSelected,
    super.locationId,
    super.type
});

  ServerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    ping = json['ping'];
    count = json['count'];
    ip = json['ip'];
    isSelected = json['is_selected'];
    address = json['address'];
    locationId = json['location_id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['ping'] = ping;
    data['count'] = count;
    data['ip'] = ip;
    data['is_selected'] = isSelected;
    data['address'] = address;
    data['location_id'] = locationId;
    data['type'] = type;
    return data;
  }

}