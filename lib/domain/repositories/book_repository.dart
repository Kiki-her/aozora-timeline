import '../entities/book.dart';

/// 書籍リポジトリインターフェース
abstract class BookRepository {
  Future<List<Book>> getRandomBooks(int count);
  Future<List<Book>> getBooksByAuthor(String authorId);
  Future<void> syncBookDataFromRemote();
  Future<Book?> getBookById(String id);
  Future<List<Book>> getLikedBooks();
  Future<List<Book>> getReadBooks();
  int getBooksCount();
}
