// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class settingsModelAdapter extends TypeAdapter<settingsModel> {
  @override
  final int typeId = 2;

  @override
  settingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return settingsModel(
      resolution: fields[0] as String,
      automatic: fields[1] as bool,
      showMap: fields[2] as bool,
      mapType: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, settingsModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.resolution)
      ..writeByte(1)
      ..write(obj.automatic)
      ..writeByte(2)
      ..write(obj.showMap)
      ..writeByte(3)
      ..write(obj.mapType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is settingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
