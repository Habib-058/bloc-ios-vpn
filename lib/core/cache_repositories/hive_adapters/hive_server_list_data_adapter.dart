import 'package:bloc_vpn_ios/screens/server/data/models/server_model.dart';
import 'package:bloc_vpn_ios/screens/server/domain/entities/server_entity.dart';
import 'package:bloc_vpn_ios/screens/server/domain/entities/server_list_entity.dart';
import 'package:hive/hive.dart';


class ServerListResponseDataAdapter extends TypeAdapter<ServerList> {
  @override
  final int typeId = 1;

  @override
  ServerList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServerList(
      id: fields[0] as String?,
      name: fields[1] as String?,
      flagUrl: fields[2] as String?,
      briefName: fields[3] as String?,
      isExpanded: fields[4] as String?,
      type: fields[5] as String?,
      servers: (fields[6] as List?)?.cast<ServerModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, ServerList obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.flagUrl)
      ..writeByte(3)
      ..write(obj.briefName)
      ..writeByte(4)
      ..write(obj.isExpanded)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.servers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ServerListResponseDataAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}