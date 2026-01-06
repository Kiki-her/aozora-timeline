/// 著者エンティティ
class Author {
  final String id;
  final String name;
  final String? birthDate;
  final String? deathDate;
  final int bookCount;

  Author({
    required this.id,
    required this.name,
    this.birthDate,
    this.deathDate,
    this.bookCount = 0,
  });

  String get lifeSpan {
    if (birthDate == null && deathDate == null) {
      return '生没年不詳';
    }
    final birth = birthDate ?? '?';
    final death = deathDate ?? '?';
    return '$birth - $death';
  }
}
