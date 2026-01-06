import 'dart:math';
import '../../models/book_model.dart';
import 'hive_service.dart';

/// 書籍ローカルデータソース
class BookLocalDataSource {
  final _booksBox = HiveService.booksBox;
  final _random = Random();

  /// 書籍をローカルに保存
  Future<void> saveBooks(List<BookModel> books) async {
    for (var book in books) {
      await _booksBox.put(book.id, book);
    }
  }

  /// 書籍を取得 (ID指定)
  BookModel? getBook(String id) {
    return _booksBox.get(id);
  }

  /// 全書籍取得
  List<BookModel> getAllBooks() {
    return _booksBox.values.toList();
  }

  /// ランダムに書籍を取得
  List<BookModel> getRandomBooks(int count) {
    final allBooks = _booksBox.values.toList();
    if (allBooks.isEmpty) return [];
    
    // シャッフル
    allBooks.shuffle(_random);
    
    return allBooks.take(count).toList();
  }

  /// 著者IDで書籍を取得
  List<BookModel> getBooksByAuthor(String authorId) {
    return _booksBox.values
        .where((book) => book.authorId == authorId)
        .toList();
  }

  /// 書籍数取得
  int get booksCount => _booksBox.length;

  /// 全書籍削除 (デバッグ用)
  Future<void> clearAllBooks() async {
    await _booksBox.clear();
  }
}
