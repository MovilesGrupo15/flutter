// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recycling_point_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecyclingPointHiveAdapter extends TypeAdapter<RecyclingPointHive> {
  @override
  final int typeId = 0;

  @override
  RecyclingPointHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecyclingPointHive(
      id: fields[0] as String,
      name: fields[1] as String,
      latitude: fields[2] as double,
      longitude: fields[3] as double,
      address: fields[4] as String,
      residuoNombre: fields[5] as String,
      horario: fields[6] as String,
      fecha: fields[7] as String?,
      imagenUrl: fields[8] as String?,
      localidadId: fields[9] as int?,
      localidadNombre: fields[10] as String?,
      residuoId: (fields[11] as List?)?.cast<int>(),
      resourceUri: fields[12] as String?,
      sectorcatastralId: fields[13] as int?,
      sectorcatastralNombre: fields[14] as String?,
      telefono: fields[15] as String?,
      distanceMeters: fields[16] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, RecyclingPointHive obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.latitude)
      ..writeByte(3)
      ..write(obj.longitude)
      ..writeByte(4)
      ..write(obj.address)
      ..writeByte(5)
      ..write(obj.residuoNombre)
      ..writeByte(6)
      ..write(obj.horario)
      ..writeByte(7)
      ..write(obj.fecha)
      ..writeByte(8)
      ..write(obj.imagenUrl)
      ..writeByte(9)
      ..write(obj.localidadId)
      ..writeByte(10)
      ..write(obj.localidadNombre)
      ..writeByte(11)
      ..write(obj.residuoId)
      ..writeByte(12)
      ..write(obj.resourceUri)
      ..writeByte(13)
      ..write(obj.sectorcatastralId)
      ..writeByte(14)
      ..write(obj.sectorcatastralNombre)
      ..writeByte(15)
      ..write(obj.telefono)
      ..writeByte(16)
      ..write(obj.distanceMeters);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecyclingPointHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
