import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/book_model.dart';

/// 青空文庫データ取得データソース
class AozoraDatasource {
  // Googleスプレッドシート公開CSV URL
  static const String spreadsheetUrl =
      'https://docs.google.com/spreadsheets/d/1n04e6POI04TBt-3HJUH10-T5cxhPZHcBWmFA4tSHjqE/export?format=csv';

  /// スプレッドシートから書籍データ取得
  Future<List<BookModel>> fetchBooksFromSpreadsheet() async {
    try {
      final response = await http.get(Uri.parse(spreadsheetUrl));
      
      if (response.statusCode == 200) {
        // CSV パース (簡易実装)
        final csvData = const Utf8Decoder().convert(response.bodyBytes);
        final lines = csvData.split('\n');
        
        // ヘッダー行スキップ
        final books = <BookModel>[];
        for (var i = 1; i < lines.length; i++) {
          if (lines[i].trim().isEmpty) continue;
          
          final fields = lines[i].split(',');
          if (fields.length < 6) continue;
          
          books.add(BookModel.fromCsv({
            'id': fields[0],
            'title': fields[1],
            'author': fields[2],
            'author_id': fields[3],
            'excerpt': fields[4],
            'url': fields[5],
            'year': fields.length > 6 ? fields[6] : '0',
          }));
        }
        
        return books;
      } else {
        throw Exception('Failed to load books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching books: $e');
    }
  }

  /// サンプルデータ生成 (開発・テスト用)
  List<BookModel> getSampleBooks() {
    return [
      BookModel(
        id: '1',
        title: '吾輩は猫である',
        authorName: '夏目漱石',
        authorId: 'natsume_soseki',
        excerpt: '吾輩は猫である。名前はまだ無い。どこで生れたかとんと見当がつかぬ。何でも薄暗いじめじめした所でニャーニャー泣いていた事だけは記憶している。',
        url: 'https://www.aozora.gr.jp/cards/000148/card789.html',
        publicationYear: 1905,
        authorBirthDate: '1867-02-09',
        authorDeathDate: '1916-12-09',
      ),
      BookModel(
        id: '2',
        title: '坊っちゃん',
        authorName: '夏目漱石',
        authorId: 'natsume_soseki',
        excerpt: '親譲りの無鉄砲で小供の時から損ばかりしている。小学校に居る時分学校の二階から飛び降りて一週間ほど腰を抜かした事がある。',
        url: 'https://www.aozora.gr.jp/cards/000148/card752.html',
        publicationYear: 1906,
        authorBirthDate: '1867-02-09',
        authorDeathDate: '1916-12-09',
      ),
      BookModel(
        id: '3',
        title: '走れメロス',
        authorName: '太宰治',
        authorId: 'dazai_osamu',
        excerpt: 'メロスは激怒した。必ず、かの邪智暴虐の王を除かなければならぬと決意した。メロスには政治がわからぬ。メロスは、村の牧人である。',
        url: 'https://www.aozora.gr.jp/cards/000035/card1567.html',
        publicationYear: 1940,
        authorBirthDate: '1909-06-19',
        authorDeathDate: '1948-06-13',
      ),
      BookModel(
        id: '4',
        title: '人間失格',
        authorName: '太宰治',
        authorId: 'dazai_osamu',
        excerpt: '私は、その男の写真を三葉、見たことがある。一葉は、その男の、幼年時代、とでも言うべきであろうか、十歳前後かと推定される頃の写真。',
        url: 'https://www.aozora.gr.jp/cards/000035/card301.html',
        publicationYear: 1948,
        authorBirthDate: '1909-06-19',
        authorDeathDate: '1948-06-13',
      ),
      BookModel(
        id: '5',
        title: '羅生門',
        authorName: '芥川龍之介',
        authorId: 'akutagawa_ryunosuke',
        excerpt: 'ある日の暮方の事である。一人の下人が、羅生門の下で雨やみを待っていた。広い門の下には、この男のほかに誰もいない。',
        url: 'https://www.aozora.gr.jp/cards/000879/card127.html',
        publicationYear: 1915,
        authorBirthDate: '1892-03-01',
        authorDeathDate: '1927-07-24',
      ),
      BookModel(
        id: '6',
        title: '蜘蛛の糸',
        authorName: '芥川龍之介',
        authorId: 'akutagawa_ryunosuke',
        excerpt: 'ある日の事でございます。御釈迦様は極楽の蓮池のふちを、独りでぶらぶら御歩きになっていらっしゃいました。',
        url: 'https://www.aozora.gr.jp/cards/000879/card92.html',
        publicationYear: 1918,
        authorBirthDate: '1892-03-01',
        authorDeathDate: '1927-07-24',
      ),
      BookModel(
        id: '7',
        title: '銀河鉄道の夜',
        authorName: '宮沢賢治',
        authorId: 'miyazawa_kenji',
        excerpt: '「ではみなさんは、そういうふうに川だと云われたり、乳の流れたあとだと云われたりしていたこのぼんやりと白いものがほんとうは何かご承知ですか。」',
        url: 'https://www.aozora.gr.jp/cards/000081/card456.html',
        publicationYear: 1934,
        authorBirthDate: '1896-08-27',
        authorDeathDate: '1933-09-21',
      ),
      BookModel(
        id: '8',
        title: '注文の多い料理店',
        authorName: '宮沢賢治',
        authorId: 'miyazawa_kenji',
        excerpt: '二人の若い紳士が、すっかりイギリスの兵隊のかたちをして、ぴかぴかする鉄砲をかついで、白熊のような犬を二疋つれて、だいぶ山奥の、木の葉のかさかさしたところを、こんなことを云いながら、あるいておりました。',
        url: 'https://www.aozora.gr.jp/cards/000081/card43754.html',
        publicationYear: 1924,
        authorBirthDate: '1896-08-27',
        authorDeathDate: '1933-09-21',
      ),
      BookModel(
        id: '9',
        title: 'こころ',
        authorName: '夏目漱石',
        authorId: 'natsume_soseki',
        excerpt: '私はその人を常に先生と呼んでいた。だからここでもただ先生と書くだけで本名は打ち明けない。これは世間を憚かる遠慮というよりも、その方が私にとって自然だからである。',
        url: 'https://www.aozora.gr.jp/cards/000148/card773.html',
        publicationYear: 1914,
        authorBirthDate: '1867-02-09',
        authorDeathDate: '1916-12-09',
      ),
      BookModel(
        id: '10',
        title: '斜陽',
        authorName: '太宰治',
        authorId: 'dazai_osamu',
        excerpt: '私の母は、私の郷里の太平洋に面した伊豆の田舎で、お母さまは優雅でしたと、近所の人に言われているような老婦人でしたが、晩年に幾つかの事件があって、伊豆の家を売って、甲府へ移りました。',
        url: 'https://www.aozora.gr.jp/cards/000035/card1565.html',
        publicationYear: 1947,
        authorBirthDate: '1909-06-19',
        authorDeathDate: '1948-06-13',
      ),
      BookModel(
        id: '11',
        title: '山月記',
        authorName: '中島敦',
        authorId: 'nakajima_atsushi',
        excerpt: '隴西の李徴は博学才穎、天宝の末年、若くして名を虎榜に連ね、ついで江南尉に補せられたが、性、狷介、自ら恃むところ頗る厚く、賤吏に甘んずるを潔しとしなかった。',
        url: 'https://www.aozora.gr.jp/cards/000119/card624.html',
        publicationYear: 1942,
        authorBirthDate: '1909-05-05',
        authorDeathDate: '1942-12-04',
      ),
      BookModel(
        id: '12',
        title: '檸檬',
        authorName: '梶井基次郎',
        authorId: 'kajii_motojiro',
        excerpt: 'えたいの知れない不吉な塊が私の心を始終圧えつけていた。焦躁と言おうか、嫌悪と言おうか――酒を飲んだあとに宿酔があるように、酒を毎日飲んでいると宿酔に相当した時期がやって来る。',
        url: 'https://www.aozora.gr.jp/cards/000074/card427.html',
        publicationYear: 1925,
        authorBirthDate: '1901-02-17',
        authorDeathDate: '1932-03-24',
      ),
      BookModel(
        id: '13',
        title: '舞姫',
        authorName: '森鴎外',
        authorId: 'mori_ogai',
        excerpt: '石炭をば早や積み果てつ。中等室の卓のほとりはいと靜にて、熾熱燈の光の晴れがましきも徒なり。',
        url: 'https://www.aozora.gr.jp/cards/000129/card682.html',
        publicationYear: 1890,
        authorBirthDate: '1862-02-17',
        authorDeathDate: '1922-07-09',
      ),
      BookModel(
        id: '14',
        title: '高瀬舟',
        authorName: '森鴎外',
        authorId: 'mori_ogai',
        excerpt: '高瀬舟は京都の高瀬川を上下する小舟である。徳川時代に京都の罪人が遠島を申しつけられると、本人の親類が牢屋敷へ呼び出されて、そこで暇乞をすることを許された。',
        url: 'https://www.aozora.gr.jp/cards/000129/card45245.html',
        publicationYear: 1916,
        authorBirthDate: '1862-02-17',
        authorDeathDate: '1922-07-09',
      ),
      BookModel(
        id: '15',
        title: '蒲団',
        authorName: '田山花袋',
        authorId: 'tayama_katai',
        excerpt: '竹中時雄は、机に向って、厚い独逸の原書を開いて見たが、一行も読むことが出来なかった。',
        url: 'https://www.aozora.gr.jp/cards/000214/card1264.html',
        publicationYear: 1907,
        authorBirthDate: '1872-01-22',
        authorDeathDate: '1930-05-13',
      ),
    ];
  }
}
