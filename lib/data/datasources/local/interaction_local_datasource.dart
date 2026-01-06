import 'hive_service.dart';

/// いいね・読了ローカルデータソース
class InteractionLocalDataSource {
  final _likesBox = HiveService.likesBox;
  final _readsBox = HiveService.readsBox;

  // ==================== いいね機能 ====================
  
  /// いいね追加
  Future<void> addLike(String bookId) async {
    await _likesBox.put(bookId, bookId);
  }

  /// いいね削除
  Future<void> removeLike(String bookId) async {
    await _likesBox.delete(bookId);
  }

  /// いいね済みかチェック
  bool isLiked(String bookId) {
    return _likesBox.containsKey(bookId);
  }

  /// いいねした書籍ID一覧取得
  List<String> getLikedBookIds() {
    return _likesBox.values.toList();
  }

  /// いいね数取得
  int get likesCount => _likesBox.length;

  // ==================== 読了機能 ====================
  
  /// 読了追加
  Future<void> addRead(String bookId) async {
    await _readsBox.put(bookId, bookId);
  }

  /// 読了削除
  Future<void> removeRead(String bookId) async {
    await _readsBox.delete(bookId);
  }

  /// 読了済みかチェック
  bool isRead(String bookId) {
    return _readsBox.containsKey(bookId);
  }

  /// 読了した書籍ID一覧取得
  List<String> getReadBookIds() {
    return _readsBox.values.toList();
  }

  /// 読了数取得
  int get readsCount => _readsBox.length;

  // ==================== クリア機能 (デバッグ用) ====================
  
  /// 全いいねクリア
  Future<void> clearAllLikes() async {
    await _likesBox.clear();
  }

  /// 全読了クリア
  Future<void> clearAllReads() async {
    await _readsBox.clear();
  }
}
