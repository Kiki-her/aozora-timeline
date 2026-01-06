import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';
import '../datasources/local/book_local_datasource.dart';
import '../datasources/local/interaction_local_datasource.dart';
import '../datasources/remote/aozora_datasource.dart';

/// 書籍リポジトリ実装
class BookRepositoryImpl implements BookRepository {
  final BookLocalDataSource _localDataSource;
  final InteractionLocalDataSource _interactionDataSource;
  final AozoraDatasource _remoteDataSource;

  BookRepositoryImpl({
    required BookLocalDataSource localDataSource,
    required InteractionLocalDataSource interactionDataSource,
    required AozoraDatasource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _interactionDataSource = interactionDataSource,
        _remoteDataSource = remoteDataSource;

  @override
  Future<List<Book>> getRandomBooks(int count) async {
    final bookModels = _localDataSource.getRandomBooks(count);
    return bookModels.map((model) {
      return model.toEntity(
        isLiked: _interactionDataSource.isLiked(model.id),
        isRead: _interactionDataSource.isRead(model.id),
      );
    }).toList();
  }

  @override
  Future<List<Book>> getBooksByAuthor(String authorId) async {
    final bookModels = _localDataSource.getBooksByAuthor(authorId);
    return bookModels.map((model) {
      return model.toEntity(
        isLiked: _interactionDataSource.isLiked(model.id),
        isRead: _interactionDataSource.isRead(model.id),
      );
    }).toList();
  }

  @override
  Future<void> syncBookDataFromRemote() async {
    // まずサンプルデータを使用 (実際のスプレッドシート取得は後で実装)
    final books = _remoteDataSource.getSampleBooks();
    await _localDataSource.saveBooks(books);
  }

  @override
  Future<Book?> getBookById(String id) async {
    final model = _localDataSource.getBook(id);
    if (model == null) return null;
    
    return model.toEntity(
      isLiked: _interactionDataSource.isLiked(model.id),
      isRead: _interactionDataSource.isRead(model.id),
    );
  }

  @override
  Future<List<Book>> getLikedBooks() async {
    final likedIds = _interactionDataSource.getLikedBookIds();
    final books = <Book>[];
    
    for (final id in likedIds) {
      final model = _localDataSource.getBook(id);
      if (model != null) {
        books.add(model.toEntity(
          isLiked: true,
          isRead: _interactionDataSource.isRead(model.id),
        ));
      }
    }
    
    return books.reversed.toList(); // 新しい順
  }

  @override
  Future<List<Book>> getReadBooks() async {
    final readIds = _interactionDataSource.getReadBookIds();
    final books = <Book>[];
    
    for (final id in readIds) {
      final model = _localDataSource.getBook(id);
      if (model != null) {
        books.add(model.toEntity(
          isLiked: _interactionDataSource.isLiked(model.id),
          isRead: true,
        ));
      }
    }
    
    return books.reversed.toList(); // 新しい順
  }

  @override
  int getBooksCount() {
    return _localDataSource.booksCount;
  }
}
