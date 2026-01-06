/// 書籍エンティティ (ビジネスロジック層)
class Book {
  final String id;
  final String title;
  final String authorName;
  final String authorId;
  final String excerpt;
  final String url;
  final int publicationYear;
  final String? authorBirthDate;
  final String? authorDeathDate;
  
  // カウント (Firestore同期)
  int likeCount;
  int readCount;
  
  // ユーザーの状態 (ローカル管理)
  bool isLiked;
  bool isRead;

  Book({
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
    this.isLiked = false,
    this.isRead = false,
  });

  Book copyWith({
    String? id,
    String? title,
    String? authorName,
    String? authorId,
    String? excerpt,
    String? url,
    int? publicationYear,
    String? authorBirthDate,
    String? authorDeathDate,
    int? likeCount,
    int? readCount,
    bool? isLiked,
    bool? isRead,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      authorName: authorName ?? this.authorName,
      authorId: authorId ?? this.authorId,
      excerpt: excerpt ?? this.excerpt,
      url: url ?? this.url,
      publicationYear: publicationYear ?? this.publicationYear,
      authorBirthDate: authorBirthDate ?? this.authorBirthDate,
      authorDeathDate: authorDeathDate ?? this.authorDeathDate,
      likeCount: likeCount ?? this.likeCount,
      readCount: readCount ?? this.readCount,
      isLiked: isLiked ?? this.isLiked,
      isRead: isRead ?? this.isRead,
    );
  }
}
