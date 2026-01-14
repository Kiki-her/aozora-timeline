import '../../domain/entities/book.dart';
import '../../domain/entities/author.dart';
import '../datasources/local/hive_service.dart';
import '../datasources/remote/sheets_datasource.dart';

class BookRepository {
  final HiveService _hiveService;
  final SheetsDatasource _sheetsDatasource;

  BookRepository(this._hiveService, this._sheetsDatasource);

  /// 初回データ取得・保存
  /// Googleスプレッドシートから全書籍データを取得してローカルに保存
  Future<void> initializeBooks() async {
    // ローカルに既にデータがあるかチェック
    final localBooks = await getBooks(limit: 1);
    if (localBooks.isNotEmpty) {
      // 既にデータがある場合はスキップ
      return;
    }

    // スプレッドシートからデータ取得
    final books = await _sheetsDatasource.fetchAozoraBooks();

    // Hiveに保存
    await _hiveService.saveBooks(books);
  }

  /// 書籍リストを取得（ページング対応）
  Future<List<Book>> getBooks({int? limit, int offset = 0}) async {
    final bookModels = await _hiveService.getBooks(limit: limit, offset: offset);
    return bookModels.map((model) => model.toEntity()).toList();
  }

  /// ランダムな書籍を取得
  Future<List<Book>> getRandomBooks(int count) async {
    final bookModels = await _hiveService.getRandomBooks(count);
    return bookModels.map((model) => model.toEntity()).toList();
  }

  /// 著者名で書籍を検索
  Future<List<Book>> getBooksByAuthor(String author) async {
    final bookModels = await _hiveService.getBooksByAuthor(author);
    return bookModels.map((model) => model.toEntity()).toList();
  }

  /// 書籍IDで取得
  Future<Book?> getBookById(String id) async {
    final bookModel = await _hiveService.getBookById(id);
    return bookModel?.toEntity();
  }

  /// 全著者リストを取得
  Future<List<String>> getAllAuthors() async {
    return await _hiveService.getAllAuthors();
  }

  /// 著者情報を取得
  Future<Author?> getAuthorInfo(String authorName) async {
    final authorInfo = await _hiveService.getAuthorInfo(authorName);
    if (authorInfo == null) return null;
    
    return Author(
      id: authorInfo['id'] as String,
      name: authorInfo['name'] as String,
      birthDate: authorInfo['birthDate'] as String?,
      deathDate: authorInfo['deathDate'] as String?,
      bookCount: authorInfo['bookCount'] as int,
    );
  }

  /// データ更新（手動リフレッシュ）
  Future<void> refreshBooks() async {
    // スプレッドシートから最新データを取得
    final books = await _sheetsDatasource.fetchAozoraBooks();

    // 既存データをクリア
    await _hiveService.clearBooks();

    // 新しいデータを保存
    await _hiveService.saveBooks(books);
  }
}
