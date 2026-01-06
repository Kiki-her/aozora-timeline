// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookModelAdapter extends TypeAdapter<BookModel> {
  @override
  final int typeId = 0;

  @override
  BookModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookModel(
      id: fields[0] as String,
      title: fields[1] as String,
      authorName: fields[2] as String,
      authorId: fields[3] as String,
      excerpt: fields[4] as String,
      url: fields[5] as String,
      publicationYear: fields[6] as int,
      authorBirthDate: fields[7] as String?,
      authorDeathDate: fields[8] as String?,
      likeCount: fields[9] as int,
      readCount: fields[10] as int,
    );
  }

  @override
  void write(BinaryWriter writer, BookModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.authorName)
      ..writeByte(3)
      ..write(obj.authorId)
      ..writeByte(4)
      ..write(obj.excerpt)
      ..writeByte(5)
      ..write(obj.url)
      ..writeByte(6)
      ..write(obj.publicationYear)
      ..writeByte(7)
      ..write(obj.authorBirthDate)
      ..writeByte(8)
      ..write(obj.authorDeathDate)
      ..writeByte(9)
      ..write(obj.likeCount)
      ..writeByte(10)
      ..write(obj.readCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
