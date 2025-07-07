// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ogg_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OggConfigAdapter extends TypeAdapter<OggConfig> {
  @override
  final int typeId = 0;

  @override
  OggConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OggConfig(
      server: fields[0] as String,
      deployment: fields[1] as String,
      protocol: fields[2] as String,
      port: fields[3] as String,
      username: fields[4] as String,
      password: fields[5] as String,
      active: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, OggConfig obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.server)
      ..writeByte(1)
      ..write(obj.deployment)
      ..writeByte(2)
      ..write(obj.protocol)
      ..writeByte(3)
      ..write(obj.port)
      ..writeByte(4)
      ..write(obj.username)
      ..writeByte(5)
      ..write(obj.password)
      ..writeByte(6)
      ..write(obj.active);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OggConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
