// GENERATED CODE - DO NOT MODIFY BY HAND
// Run `flutter pub run build_runner build` to regenerate.

part of 'resource.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ResourceAdapter extends TypeAdapter<Resource> {
  @override
  final int typeId = 0;

  @override
  Resource read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Resource(
      id: fields[0] as String,
      stateId: fields[1] as String,
      countyId: fields[2] as String?,
      name: fields[3] as String,
      category: fields[4] as String,
      subCategory: fields[5] as String?,
      description: fields[6] as String?,
      addressLine1: fields[7] as String?,
      city: fields[8] as String?,
      zipCode: fields[9] as String?,
      phone: fields[10] as String?,
      website: fields[11] as String?,
      email: fields[12] as String?,
      latitude: fields[13] as double?,
      longitude: fields[14] as double?,
      status: fields[15] as String,
      hoursJson: fields[16] as String?,
      mealSchedulesJson: fields[17] as String?,
      lastVerifiedAt: fields[18] as DateTime?,
      updatedAt: fields[19] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Resource obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.stateId)
      ..writeByte(2)
      ..write(obj.countyId)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.subCategory)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.addressLine1)
      ..writeByte(8)
      ..write(obj.city)
      ..writeByte(9)
      ..write(obj.zipCode)
      ..writeByte(10)
      ..write(obj.phone)
      ..writeByte(11)
      ..write(obj.website)
      ..writeByte(12)
      ..write(obj.email)
      ..writeByte(13)
      ..write(obj.latitude)
      ..writeByte(14)
      ..write(obj.longitude)
      ..writeByte(15)
      ..write(obj.status)
      ..writeByte(16)
      ..write(obj.hoursJson)
      ..writeByte(17)
      ..write(obj.mealSchedulesJson)
      ..writeByte(18)
      ..write(obj.lastVerifiedAt)
      ..writeByte(19)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResourceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
