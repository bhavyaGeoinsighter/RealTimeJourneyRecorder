// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class journeyModelAdapter extends TypeAdapter<journeyModel> {
  @override
  final int typeId = 0;

  @override
  journeyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return journeyModel(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      videoPath: fields[3] as String,
      csvPath: fields[4] as String,
      createdOn: fields[5] as String,
      extra: fields[6] as String,
      isCsvUploaded: fields[8] as bool,
      isVideoUploaded: fields[9] as bool,
      modifiedOn: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, journeyModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.videoPath)
      ..writeByte(4)
      ..write(obj.csvPath)
      ..writeByte(5)
      ..write(obj.createdOn)
      ..writeByte(6)
      ..write(obj.extra)
      ..writeByte(7)
      ..write(obj.modifiedOn)
      ..writeByte(8)
      ..write(obj.isCsvUploaded)
      ..writeByte(9)
      ..write(obj.isVideoUploaded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is journeyModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
