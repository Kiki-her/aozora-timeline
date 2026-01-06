import 'package:hive/hive.dart';
import '../../domain/entities/book.dart';

part 'book_model.g.dart';

@HiveType(typeId: 0)
class BookModel extends HiveObject {
  @HiveField(0)
  late String id;
  
  @HiveField(1)
  late String title;
  
  @HiveField(2)
  late String authorName;
  
  @HiveField(3)
  late String authorId;
  
  @HiveField(4)
  late String excerpt;
  
  @HiveField(5)
  late String url;
  
  @HiveField(6)
  late int publicationYear;
  
  @HiveField(7)
  String? authorBirthDate;
  
  @HiveField(8)
  String? authorDeathDate;
  
  @HiveField(9)
  late int likeCount;
  
  @HiveField(10)
  late int readCount;

  BookModel({
    required this.id,
    required this.title,
    required this.authorName,
    required this.authorId,
    required this.excerpt,
    required this.url,
    required this.publicationYear,
    this.authorBirthDate,
    this.authorDeathDate,
    this.likeCount = 0,
    this.readCount = 0,
  });

  /// Entityに変換
  Book toEntity({bool isLiked = false, bool isRead = false}) {
    return Book(
      id: id,
      title: title,
      authorName: authorName,
      authorId: authorId,
      excerpt: excerpt,
      url: url,
      publicationYear: publicationYear,
      authorBirthDate: authorBirthDate,
      authorDeathDate: authorDeathDate,
      likeCount: likeCount,
      readCount: readCount,
      isLiked: isLiked,
      isRead: isRead,
    );
  }

  /// Entityから変換
  factory BookModel.fromEntity(Book book) {
    return BookModel(
      id: book.id,
      title: book.title,
      authorName: book.authorName,
      authorId: book.authorId,
      excerpt: book.excerpt,
      url: book.url,
      publicationYear: book.publicationYear,
      authorBirthDate: book.authorBirthDate,
      authorDeathDate: book.authorDeathDate,
      likeCount: book.likeCount,
      readCount: book.readCount,
    );
  }

  /// CSVから変換 (青空文庫データ読み込み用)
  factory BookModel.fromCsv(Map<String, dynamic> csv) {
    return BookModel(
      id: csv['id']?.toString() ?? '',
      title: csv['title']?.toString() ?? '',
      authorName: csv['author']?.toString() ?? '',
      authorId: csv['author_id']?.toString() ?? '',
      excerpt: csv['excerpt']?.toString() ?? '',
      url: csv['url']?.toString() ?? '',
      publicationYear: int.tryParse(csv['year']?.toString() ?? '') ?? 0,
      authorBirthDate: csv['birth_date']?.toString(),
      authorDeathDate: csv['death_date']?.toString(),
    );
  }
}
