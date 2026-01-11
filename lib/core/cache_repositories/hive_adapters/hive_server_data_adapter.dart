import 'package:bloc_vpn_ios/screens/server/domain/entities/server_entity.dart';
import 'package:hive/hive.dart';


class ServerDataAdapter extends TypeAdapter<Server> {
  @override
  final int typeId = 0;

  @override
  Server read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Server(
      id: fields[0] as String?,
      name: fields[1] as String?,
      ping: fields[2] as String?,
      count: fields[3] as String?,
      ip: fields[4] as String?,
      isSelected: fields[5] as String?,
      address: fields[6] as String?,
      locationId: fields[7] as String?,
      type: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Server obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.ping)
      ..writeByte(3)
      ..write(obj.count)
      ..writeByte(4)
      ..write(obj.ip)
      ..writeByte(5)
      ..write(obj.isSelected)
      ..writeByte(6)
      ..write(obj.address)
      ..writeByte(7)
      ..write(obj.locationId)
      ..writeByte(8)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ServerDataAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}