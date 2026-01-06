import 'package:flutter/foundation.dart';
import '../../data/datasources/local/interaction_local_datasource.dart';
import '../../domain/entities/book.dart';

/// インタラクション(いいね・読了)Provider
class InteractionProvider with ChangeNotifier {
  final InteractionLocalDataSource _dataSource = InteractionLocalDataSource();

  /// いいねトグル
  Future<void> toggleLike(Book book) async {
    if (book.isLiked) {
      await _dataSource.removeLike(book.id);
      book.isLiked = false;
      book.likeCount = (book.likeCount - 1).clamp(0, double.infinity).toInt();
    } else {
      await _dataSource.addLike(book.id);
      book.isLiked = true;
      book.likeCount++;
    }
    notifyListeners();
  }

  /// 読了トグル
  Future<void> toggleRead(Book book) async {
    if (book.isRead) {
      await _dataSource.removeRead(book.id);
      book.isRead = false;
      book.readCount = (book.readCount - 1).clamp(0, double.infinity).toInt();
    } else {
      await _dataSource.addRead(book.id);
      book.isRead = true;
      book.readCount++;
    }
    notifyListeners();
  }

  /// いいね済みかチェック
  bool isLiked(String bookId) {
    return _dataSource.isLiked(bookId);
  }

  /// 読了済みかチェック
  bool isRead(String bookId) {
    return _dataSource.isRead(bookId);
  }

  /// いいね数取得
  int get likesCount => _dataSource.likesCount;

  /// 読了数取得
  int get readsCount => _dataSource.readsCount;
}
