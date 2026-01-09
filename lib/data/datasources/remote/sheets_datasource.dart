import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/book_model.dart';

class SheetsDatasource {
  /// ローカルアセットから青空文庫データを取得
  Future<List<BookModel>> fetchAozoraBooks() async {
    try {
      // アセットからCSVを読み込み
      final csvData = await rootBundle.loadString('assets/data/aozora_books.csv');
      return _parseCsvData(csvData);
    } catch (e) {
      throw Exception('Error loading Aozora books from assets: $e');
    }
  }

  /// CSVデータをBookModelリストにパース
  List<BookModel> _parseCsvData(String csvData) {
    final lines = csvData.split('\n');
    final books = <BookModel>[];

    // ヘッダー行をスキップ（1行目）
    for (var i = 1; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;

      try {
        final book = _parseBookLine(line);
        if (book != null) {
          books.add(book);
        }
      } catch (e) {
        // パースエラーは個別にスキップ（ログ記録のみ）
        // Flutterの kDebugMode を使用する場合はこちら
        // if (kDebugMode) {
        //   print('Error parsing line $i: $e');
        // }
      }
    }

    return books;
  }

  /// CSV行を1冊の書籍データにパース
  BookModel? _parseBookLine(String line) {
    // CSVパース（カンマ区切り、ダブルクォート対応）
    final fields = _parseCsvLine(line);

    // 最低限のフィールド数チェック（30カラム想定）
    if (fields.length < 10) {
      return null;
    }

    // フィールドマッピング（新しいCSV構造）
    // 0: 作品ID, 1: 作品名, 2: 作品名読み, 3: 作家名, 4: 作家名読み,
    // 5: 作家生年, 6: 作家没年, 7: 翻訳者名, 8: 翻訳者名読み,
    // 9: 翻訳者生年, 10: 翻訳者没年, 11: 分類, 12: 文字遣い種別,
    // 13: 文字数, 14: 読了目安時間, 15: 書き出し, 16: 冒頭（XHTML）← これを使用,
    // 17: 底本, 18: 出版社, 19: 初版発行日, 20: 入力者, 21: 校正者,
    // 22: 公開日, 23: 最終更新日, 24: 累計アクセス数, 25: カテゴリ,
    // 26: 図書カードURL, 27: XHTML/HTMLファイルURL, 28: テキストファイルURL, 29: 青空 in Browsers URL ← これを使用
    
    final workId = fields[0].trim();
    final title = fields[1].trim();
    final titleReading = fields.length > 2 ? fields[2].trim() : '';
    final authorName = fields.length > 3 ? fields[3].trim() : '';
    final authorReading = fields.length > 4 ? fields[4].trim() : '';
    final birthDate = fields.length > 5 ? fields[5].trim() : '';
    final deathDate = fields.length > 6 ? fields[6].trim() : '';
    // 冒頭（XHTML）から取得（16列目 = インデックス16）
    final excerptXhtml = fields.length > 16 ? fields[16].trim() : '';
    final category = fields.length > 25 ? fields[25].trim() : '';
    // 青空 in Browsers URLを使用（29列目 = インデックス29）
    final browsersUrl = fields.length > 29 ? fields[29].trim() : '';
    
    // 必須フィールドチェック
    if (title.isEmpty || authorName.isEmpty) {
      return null;
    }

    // URLの決定（青空 in Browsers URLを優先使用）
    final url = browsersUrl.isNotEmpty
        ? browsersUrl
        : 'https://www.aozora.gr.jp/';

    // 出版年を推定（生年から適当な値を設定、なければ0）
    int publicationYear = 0;
    if (birthDate.isNotEmpty) {
      try {
        final year = int.parse(birthDate.split('-')[0]);
        publicationYear = year + 30; // 著者の30歳頃を仮の出版年とする
      } catch (e) {
        // パースエラーは無視
      }
    }

    // BookModel生成
    return BookModel(
      id: workId.isNotEmpty ? workId : _generateBookId(title, authorName),
      title: title,
      authorName: authorName,
      authorId: _generateBookId('', authorName),
      // 冒頭（XHTML）を使用、なければデフォルトテキスト
      excerpt: excerptXhtml.isNotEmpty ? excerptXhtml : '「${title}」${authorName}著。青空文庫にて公開中。',
      url: url,
      publicationYear: publicationYear,
      authorBirthDate: birthDate.isNotEmpty ? birthDate : null,
      authorDeathDate: deathDate.isNotEmpty ? deathDate : null,
    );
  }

  /// CSV行をフィールドリストに分解（ダブルクォート対応）
  List<String> _parseCsvLine(String line) {
    final fields = <String>[];
    final buffer = StringBuffer();
    var insideQuotes = false;

    for (var i = 0; i < line.length; i++) {
      final char = line[i];

      if (char == '"') {
        insideQuotes = !insideQuotes;
      } else if (char == ',' && !insideQuotes) {
        fields.add(buffer.toString());
        buffer.clear();
      } else {
        buffer.write(char);
      }
    }

    // 最後のフィールドを追加
    fields.add(buffer.toString());

    return fields;
  }

  /// 書籍IDを生成（タイトル+著者のハッシュ）
  String _generateBookId(String title, String author) {
    final combined = '$title-$author';
    return combined.hashCode.abs().toString();
  }
}
