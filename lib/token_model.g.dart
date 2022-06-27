// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class tokenModelAdapter extends TypeAdapter<tokenModel> {
  @override
  final int typeId = 1;

  @override
  tokenModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return tokenModel(
      token: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, tokenModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.token);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is tokenModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
