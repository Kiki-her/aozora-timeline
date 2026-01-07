import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/book_model.dart';

class SheetsDatasource {
  static const String _sheetUrl =
      'https://docs.google.com/spreadsheets/d/1pnmGuHwSTYkpMAmXmw7KHT4Cs7dYDqdl3ab1BnIeRos/export?format=csv';

  /// Googleスプレッドシートから青空文庫データを取得
  Future<List<BookModel>> fetchAozoraBooks() async {
    try {
      final response = await http.get(Uri.parse(_sheetUrl));

      if (response.statusCode == 200) {
        final csvData = utf8.decode(response.bodyBytes);
        return _parseCsvData(csvData);
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching Aozora books: $e');
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

    // 必須フィールドチェック（作品名、著者名が必要）
    if (fields.length < 3 || fields[0].isEmpty || fields[1].isEmpty) {
      return null;
    }

    // フィールドマッピング
    // 仕様書に基づく想定カラム構造:
    // 0: 作品名, 1: 著者名, 2: 書き出し/概要, 3: 青空文庫URL, 4: その他...
    final title = fields[0].trim();
    final authorName = fields[1].trim();
    final excerpt = fields.length > 2 ? fields[2].trim() : '';
    final url = fields.length > 3 && fields[3].isNotEmpty
        ? fields[3].trim()
        : 'https://www.aozora.gr.jp/';

    // BookModel生成
    return BookModel(
      id: _generateBookId(title, authorName),
      title: title,
      authorName: authorName,
      authorId: _generateBookId('', authorName), // 著者IDを生成
      excerpt: excerpt.isNotEmpty ? excerpt : '書き出し情報がありません。',
      url: url,
      publicationYear: 0, // スプレッドシートに年情報がない場合は0
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
