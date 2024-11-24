// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'songs_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SongsModelAdapter extends TypeAdapter<SongsModel> {
  @override
  final int typeId = 1;

  @override
  SongsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SongsModel(
      name: fields[1] as String?,
      path: fields[2] as String?,
      selected: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SongsModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.path)
      ..writeByte(3)
      ..write(obj.selected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
