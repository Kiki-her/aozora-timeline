import 'package:flutter/foundation.dart' show ChangeNotifier, kDebugMode;
import '../../domain/entities/book.dart';
import '../../domain/entities/author.dart';
import '../../data/repositories/book_repository.dart';
import '../../data/datasources/local/hive_service.dart';
import '../../data/datasources/remote/sheets_datasource.dart';

/// 書籍Provider
class BookProvider with ChangeNotifier {
  late final BookRepository _repository;
  bool _isInitialized = false;

  List<Book> _books = [];
  bool _isLoading = false;
  String? _error;

  List<Book> get books => _books;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasBooks => _books.isNotEmpty;
  bool get isInitialized => _isInitialized;

  BookProvider() {
    _repository = BookRepository(
      HiveService(),
      SheetsDatasource(),
    );
  }

  /// 初期化（アプリ起動時に1度だけ実行）
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _isLoading = true;
      notifyListeners();

      // データがない場合は初回取得
      await _repository.initializeBooks();

      // 初回ランダム表示
      await loadRandomBooks();

      _isInitialized = true;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'データの初期化に失敗しました: $e';
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

  /// リフレッシュ（Pull to Refresh）
  Future<void> refresh() async {
    await loadRandomBooks();
  }

  /// 手動データ更新（スプレッドシートから再取得）
  Future<void> refreshFromRemote() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _repository.refreshBooks();
      await loadRandomBooks();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'データの更新に失敗しました: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 著者名で書籍を検索
  Future<List<Book>> getBooksByAuthor(String author) async {
    try {
      return await _repository.getBooksByAuthor(author);
    } catch (e) {
      if (kDebugMode) {
        print('著者検索失敗: $e');
      }
      return [];
    }
  }

  /// 全著者リストを取得
  Future<List<String>> getAllAuthors() async {
    try {
      return await _repository.getAllAuthors();
    } catch (e) {
      if (kDebugMode) {
        print('著者リスト取得失敗: $e');
      }
      return [];
    }
  }

  /// 著者情報を取得
  Future<Author?> getAuthorInfo(String authorName) async {
    try {
      return await _repository.getAuthorInfo(authorName);
    } catch (e) {
      if (kDebugMode) {
        print('著者情報取得失敗: $e');
      }
      return null;
    }
  }

  /// ローカルデータ件数を取得
  int getBooksCount() {
    return HiveService.booksBox.length;
  }
}
