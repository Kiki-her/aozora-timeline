import 'dart:math';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/book_model.dart';

/// Hive データベース初期化・管理サービス
class HiveService {
  static const String booksBoxName = 'books';
  static const String likesBoxName = 'user_likes';
  static const String readsBoxName = 'user_reads';
  static const String settingsBoxName = 'settings';

  /// Hive初期化
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // TypeAdapter登録
    Hive.registerAdapter(BookModelAdapter());
    
    // Box開く
    await Hive.openBox<BookModel>(booksBoxName);
    await Hive.openBox<String>(likesBoxName);
    await Hive.openBox<String>(readsBoxName);
    await Hive.openBox(settingsBoxName);
  }

  /// Booksボックス取得
  static Box<BookModel> get booksBox => Hive.box<BookModel>(booksBoxName);
  
  /// いいねボックス取得
  static Box<String> get likesBox => Hive.box<String>(likesBoxName);
  
  /// 読了ボックス取得
  static Box<String> get readsBox => Hive.box<String>(readsBoxName);
  
  /// 設定ボックス取得
  static Box get settingsBox => Hive.box(settingsBoxName);

  // ==================== 書籍データ管理 ====================

  /// 書籍リストを保存
  Future<void> saveBooks(List<BookModel> books) async {
    final box = booksBox;
    for (final book in books) {
      await box.put(book.id, book);
    }
  }

  /// 書籍リストを取得（ページング対応）
  Future<List<BookModel>> getBooks({int? limit, int offset = 0}) async {
    final box = booksBox;
    final allBooks = box.values.toList();

    if (limit == null) {
      return allBooks.skip(offset).toList();
    }

    return allBooks.skip(offset).take(limit).toList();
  }

  /// ランダムな書籍を取得
  Future<List<BookModel>> getRandomBooks(int count) async {
    final box = booksBox;
    final allBooks = box.values.toList();

    if (allBooks.isEmpty) return [];
    if (allBooks.length <= count) return allBooks;

    // ランダムにシャッフルして取得
    final shuffled = List<BookModel>.from(allBooks);
    shuffled.shuffle(Random());
    return shuffled.take(count).toList();
  }

  /// 著者名で書籍を検索
  Future<List<BookModel>> getBooksByAuthor(String author) async {
    final box = booksBox;
    return box.values.where((book) => book.authorName == author).toList();
  }

  /// 書籍IDで取得
  Future<BookModel?> getBookById(String id) async {
    final box = booksBox;
    return box.get(id);
  }

  /// 全著者リストを取得
  Future<List<String>> getAllAuthors() async {
    final box = booksBox;
    final authors = box.values.map((book) => book.authorName).toSet().toList();
    authors.sort();
    return authors;
  }

  /// 書籍データをクリア
  Future<void> clearBooks() async {
    final box = booksBox;
    await box.clear();
  }

  /// 書籍データの総数を取得
  int getBooksCount() {
    return booksBox.length;
  }
}
