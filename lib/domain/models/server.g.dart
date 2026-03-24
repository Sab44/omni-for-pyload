// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServerAdapter extends TypeAdapter<Server> {
  @override
  final int typeId = 0;

  @override
  Server read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Server(
      ip: fields[0] as String,
      port: fields[1] as int,
      apiKey: fields[2] as String,
      protocol: fields[3] as String,
      name: fields[4] as String,
      allowInsecure: fields[5] as bool,
      clickNLoadIp: fields[6] as String?,
      clickNLoadPort: fields[7] as int?,
      clickNLoadProtocol: fields[8] as String?,
      clickNLoadAllowInsecure: fields[9] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Server obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.ip)
      ..writeByte(1)
      ..write(obj.port)
      ..writeByte(2)
      ..write(obj.apiKey)
      ..writeByte(3)
      ..write(obj.protocol)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.allowInsecure)
      ..writeByte(6)
      ..write(obj.clickNLoadIp)
      ..writeByte(7)
      ..write(obj.clickNLoadPort)
      ..writeByte(8)
      ..write(obj.clickNLoadProtocol)
      ..writeByte(9)
      ..write(obj.clickNLoadAllowInsecure);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
