// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BalanceModelAdapter extends TypeAdapter<BalanceModel> {
  @override
  final int typeId = 2;

  @override
  BalanceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BalanceModel(
      fields[0] as double,
    );
  }

  @override
  void write(BinaryWriter writer, BalanceModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.balance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BalanceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
