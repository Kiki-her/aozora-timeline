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
}
