import 'package:flutter/foundation.dart';
import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';
import '../../data/repositories/book_repository_impl.dart';
import '../../data/datasources/local/book_local_datasource.dart';
import '../../data/datasources/local/interaction_local_datasource.dart';
import '../../data/datasources/remote/aozora_datasource.dart';

/// 書籍Provider
class BookProvider with ChangeNotifier {
  final BookRepository _repository = BookRepositoryImpl(
    localDataSource: BookLocalDataSource(),
    interactionDataSource: InteractionLocalDataSource(),
    remoteDataSource: AozoraDatasource(),
  );

  List<Book> _books = [];
  bool _isLoading = false;
  String? _error;

  List<Book> get books => _books;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasBooks => _books.isNotEmpty;

  /// 初期データ同期
  Future<void> syncDataIfNeeded() async {
    final count = _repository.getBooksCount();
    if (count == 0) {
      await syncData();
    }
  }

  /// データ同期 (リモートから取得)
  Future<void> syncData() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _repository.syncBookDataFromRemote();
      await loadRandomBooks();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'データの取得に失敗しました: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ランダムに書籍を読み込み
  Future<void> loadRandomBooks({int count = 20}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _books = await _repository.getRandomBooks(count);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = '書籍の読み込みに失敗しました: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// さらに読み込み (無限スクロール用)
  Future<void> loadMore({int count = 20}) async {
    try {
      final newBooks = await _repository.getRandomBooks(count);
      _books.addAll(newBooks);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('追加読み込み失敗: $e');
      }
    }
  }

  /// リフレッシュ
  Future<void> refresh() async {
    await loadRandomBooks();
  }
}
