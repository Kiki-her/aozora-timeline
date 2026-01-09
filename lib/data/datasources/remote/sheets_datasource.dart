import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/book_model.dart';

class SheetsDatasource {
  static const String _sheetUrl =
      'https://docs.google.com/spreadsheets/d/1-JtNfn7BIUTkw_XAEjXEno703w4qlB3fy0qR6u_JCPE/export?format=csv';

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

    if (lines.isEmpty) return books;

    // ヘッダー行を解析してカラムインデックスを取得
    final headerFields = _parseCsvLine(lines[0]);
    final columnIndices = _getColumnIndices(headerFields);

    // データ行を処理（2行目以降）
    for (var i = 1; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;

      try {
        final book = _parseBookLine(line, columnIndices);
        if (book != null) {
          books.add(book);
        }
      } catch (e) {
        // パースエラーは個別にスキップ（ログ記録のみ）
        // if (kDebugMode) {
        //   print('Error parsing line $i: $e');
        // }
      }
    }

    return books;
  }

  /// ヘッダー行からカラムインデックスを取得
  Map<String, int> _getColumnIndices(List<String> headers) {
    final indices = <String, int>{};
    
    for (var i = 0; i < headers.length; i++) {
      final header = headers[i].trim().toLowerCase();
      
      // 作品名カラムの検出
      if (header.contains('作品名') || header.contains('title') || header.contains('タイトル')) {
        indices['title'] = i;
      }
      // 著者名カラムの検出
      else if (header.contains('著者') || header.contains('author') || header.contains('作者')) {
        indices['author'] = i;
      }
      // 青空 in Browsers URLカラムの検出
      else if (header.contains('青空') && header.contains('url')) {
        indices['url'] = i;
      }
      // 書き出し・概要カラムの検出
      else if (header.contains('書き出し') || header.contains('概要') || header.contains('excerpt')) {
        indices['excerpt'] = i;
      }
    }
    
    return indices;
  }

  /// CSV行を1冊の書籍データにパース（新しいスプレッドシート形式対応）
  BookModel? _parseBookLine(String line, Map<String, int> columnIndices) {
    // CSVパース（カンマ区切り、ダブルクォート対応）
    final fields = _parseCsvLine(line);

    if (fields.isEmpty) {
      return null;
    }

    // カラムインデックスに基づいてデータを取得
    String title = '';
    String authorName = '';
    String url = '';
    String excerpt = '';

    // 作品名を取得
    if (columnIndices.containsKey('title') && 
        columnIndices['title']! < fields.length) {
      title = fields[columnIndices['title']!].trim();
    } else if (fields.isNotEmpty) {
      // フォールバック: 最初のカラムを作品名とする
      title = fields[0].trim();
    }

    // 著者名を取得
    if (columnIndices.containsKey('author') && 
        columnIndices['author']! < fields.length) {
      authorName = fields[columnIndices['author']!].trim();
    } else if (fields.length > 1) {
      // フォールバック: 2番目のカラムを著者名とする
      authorName = fields[1].trim();
    }

    // 青空 in Browsers URLを取得
    if (columnIndices.containsKey('url') && 
        columnIndices['url']! < fields.length) {
      url = fields[columnIndices['url']!].trim();
    } else {
      // フォールバック: URLっぽいフィールドを探す
      for (var i = 0; i < fields.length; i++) {
        final field = fields[i].trim();
        if (field.contains('http') && field.contains('aozora')) {
          url = field;
          break;
        }
      }
    }

    // 書き出し情報を取得（オプション）
    if (columnIndices.containsKey('excerpt') && 
        columnIndices['excerpt']! < fields.length) {
      excerpt = fields[columnIndices['excerpt']!].trim();
    }

    // 必須情報の検証
    if (title.isEmpty || authorName.isEmpty) {
      return null;
    }

    // URLが見つからない場合はデフォルト
    if (url.isEmpty) {
      url = 'https://www.aozora.gr.jp/';
    }

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
