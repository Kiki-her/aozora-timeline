# 青空文庫リーダー - Aozora Timeline

X (Twitter) UIをベースにした青空文庫作品発見PWAアプリ

![App Preview](https://img.shields.io/badge/Platform-Web%20%7C%20PWA%20%7C%20iOS%20%7C%20Android-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.38.6-02569B?logo=flutter)
![License](https://img.shields.io/badge/License-MIT-green)
![PWA](https://img.shields.io/badge/PWA-Ready-purple)

## 🌐 デモ

**GitHub Pages**: https://kiki-her.github.io/aozora-timeline/

## 📱 アプリ概要

**「文字中毒者のための、SNS疲れしない読書発見アプリ」**

X (Twitter) UIを完全再現しながら、青空文庫の書籍情報をタイムライン形式で表示するProgressive Web App（PWA）。ユーザー同士の交流はなく、作品との出会いと読書記録に特化。

### 🎯 ターゲットユーザー
- SNSが苦手だが、タイムライン形式の情報流入は好き
- 青空文庫を読みたいが、作品が多すぎて選べない
- 偶然の出会いから読書を始めたい文学愛好者

---

## ✨ 主な機能

### 📚 **タイムライン機能**
- **18,558作品の完全データベース** (青空文庫公式データ使用)
- **13,569作品で冒頭テキスト表示** (作品の冒頭100文字以上)
- 青空文庫の書籍をランダム表示
- Pull to Refresh で新しい書籍を読み込み
- 無限スクロール対応
- タップでカード展開・全文表示 (X UI準拠)

### 📖 **冒頭テキスト表示**
- **データソース**: 青空文庫公式CSVデータ（`冒頭（XHTML）`フィールド）
- **表示内容**: 作品の冒頭部分（100文字以上）を表示
- **全作品対応**: 冒頭テキストがある作品のみを表示（13,569作品）
- **デフォルト非表示**: 冒頭テキストが空の作品は表示から除外

### 🔗 **青空文庫リンク**
- **青空 in Browsers URL**: 青空文庫のブラウザビューアで作品を閲覧
- **URL形式**: `https://aozora.binb.jp/reader/main.html?cid=作品ID`
- **ワンタップで読書開始**: 各作品カードから直接リーダーへアクセス

### ❤️ **インタラクション**
- **いいね機能**: ローカル保存（カウント表示なし、アイコンのみ）
- **読了マーク**: 読み終わった作品を記録（カウント表示なし、アイコンのみ）
- **いいね一覧・読了一覧**: 保存した作品を一覧表示
- **SNS共有機能**: 
  - X (Twitter) に共有
  - Facebook に共有
  - LINE に共有
  - リンクをコピー
  - **共有内容**: 「作品名」著者名著 + 冒頭文（100文字） + 青空文庫URL

### 📱 **PWA対応** (New!)
- **ホーム画面に追加**: iOS（Safari）とAndroid（Chrome）でアプリのようにインストール可能
- **オフライン対応**: Service Workerによるキャッシュ戦略で、オフライン時も閲覧可能
- **フルスクリーン表示**: ブラウザUIを非表示にしてネイティブアプリ風に動作
- **ローディング画面**: X Blueテーマのスプラッシュスクリーン
- **SEO・共有対応**: Open Graph Protocol、Twitter Cardによる充実したメタデータ

### 🎨 **デザイン**
- X (Twitter) 2025年版UI完全再現
- ダークモード完全対応
- レスポンシブデザイン (GOJO UI風)
  - モバイル: フル幅表示
  - デスクトップ: 中央配置 + 装飾背景

### 🎯 **UX改善** (New!)
- **ホームアイコンタップで最上部へスクロール**: X (Twitter) 風のスムーズスクロール（300msアニメーション）
- **作品カード展開**: 冒頭文が100文字以上の場合、「続きを読む」で全文表示

### 📖 **収録作品** (一部紹介)
- 夏目漱石: 吾輩は猫である、坊っちゃん、こころ
- 太宰治: 走れメロス、人間失格、斜陽
- 芥川龍之介: 羅生門、蜘蛛の糸
- 宮沢賢治: 銀河鉄道の夜、注文の多い料理店
- **その他、18,558作品を収録**

---

## 🛠️ 技術スタック

### フレームワーク
- **Flutter**: 3.38.6
- **Dart**: 3.9.2

### 状態管理
- **Provider**: 6.1.5+1

### データ管理
- **Hive**: 2.2.3 (ローカルDB - Web対応)
- **hive_flutter**: 1.1.0
- **shared_preferences**: 2.5.3 (設定保存)

### ネットワーク
- **http**: 1.5.0 (API通信)
- **url_launcher**: ^6.3.0 (外部リンク)

### PWA対応
- **Service Worker**: オフライン対応・キャッシュ戦略
- **Web Manifest**: ホーム画面追加対応
- **Cache-First Strategy**: 高速な起動とオフライン対応

### Firebase (オプション)
- **firebase_core**: 3.6.0
- **cloud_firestore**: 5.4.3 (カウント同期用)

---

## 🎨 デザインシステム

### カラーパレット
X (Twitter) 完全準拠:
- **Primary**: #1D9BF0 (X Blue)
- **Like**: #F91880 (Pink)
- **Read**: #00BA7C (Green)
- **Light Mode**: White backgrounds
- **Dark Mode**: True black backgrounds (#000000)

### タイポグラフィ
- **フォント**: Noto Sans JP
- **サイズ**: 11px〜20px (X UI準拠)
- **ウェイト**: 400 (Regular) / 600 (SemiBold) / 700 (Bold)

### スペーシング
8pt Grid System採用

---

## 📂 プロジェクト構成 (Clean Architecture)

```
lib/
├── core/
│   ├── theme/                    # グローバルテーマ
│   │   ├── app_theme.dart
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   └── app_dimensions.dart
│   └── widgets/                  # 共通Widget
│       ├── responsive_wrapper.dart
│       └── x_divider.dart
│
├── data/
│   ├── datasources/
│   │   ├── local/                # Hive DB
│   │   └── remote/               # CSV読み込み（青空文庫データ）
│   ├── models/                   # データモデル
│   └── repositories/             # Repository実装
│
├── domain/
│   ├── entities/                 # エンティティ
│   ├── repositories/             # Repository Interface
│   └── usecases/                 # ビジネスロジック
│
└── presentation/
    ├── providers/                # Provider (状態管理)
    ├── screens/                  # 画面
    │   ├── timeline/
    │   ├── likes/
    │   ├── reads/
    │   ├── settings/
    │   └── book_detail/
    └── navigation/               # ナビゲーション

assets/
└── data/
    └── aozora_books.csv         # 青空文庫公式データ（18,558作品）

web/
├── index.html                    # PWA設定・メタタグ
├── manifest.json                 # PWA Manifest
├── service-worker.js             # Service Worker（オフライン対応）
└── icons/                        # アプリアイコン
```

---

## 📊 データ構造

### CSVデータ
- **データソース**: 青空文庫公式スプレッドシート
- **データURL**: https://docs.google.com/spreadsheets/d/1-JtNfn7BIUTkw_XAEjXEno703w4qlB3fy0qR6u_JCPE/edit
- **データ形式**: CSV（30カラム）
- **配置場所**: `assets/data/aozora_books.csv`
- **作品数**: 18,558作品

### 主なフィールド
| カラム番号 | フィールド名 | 説明 |
|-----------|--------------|------|
| 0 | 作品ID | 青空文庫の公式作品ID |
| 1 | 作品名 | 作品のタイトル |
| 2 | 作品名読み | タイトルの読み仮名 |
| 3 | 作家名 | 著者名 |
| 4 | 作家名読み | 著者名の読み仮名 |
| 5 | 作家生年 | 著者の生年月日 |
| 6 | 作家没年 | 著者の没年月日 |
| 16 | **冒頭（XHTML）** | **作品の冒頭部分（100文字以上）** |
| 26 | 図書カードURL | 青空文庫の図書カード |
| 27 | XHTML/HTMLファイルURL | 作品の全文HTML |
| 29 | **青空 in Browsers URL** | **青空文庫ブラウザビューアURL** |

---

## 🚀 セットアップ

### 前提条件
- Flutter SDK 3.38.6以上
- Dart SDK 3.9.2以上

### インストール

```bash
# リポジトリをクローン
git clone https://github.com/Kiki-her/aozora-timeline.git
cd aozora-timeline

# 依存関係をインストール
flutter pub get

# Web版を実行
flutter run -d chrome

# または、リリースビルド
flutter build web --release
```

---

## 🌐 デプロイ

### GitHub Pages (自動デプロイ設定済み)
このプロジェクトは GitHub Actions により自動的にビルド＆デプロイされます。

```yaml
# .github/workflows/deploy-gh-pages.yml
# mainブランチへのpushで自動デプロイ
```

**公開URL**: https://kiki-her.github.io/aozora-timeline/

### Web版 (その他のホスティング)
```bash
# ビルド
flutter build web --release

# 配信 (例: Cloudflare Pages, Netlify, Vercel)
# build/web ディレクトリをアップロード
```

### Android版
```bash
# APKビルド
flutter build apk --release

# App Bundle (Google Play Store用)
flutter build appbundle --release
```

### iOS版
```bash
# macOS + Xcode環境で実行
flutter build ios --release
```

---

## 📱 PWAとして使用する方法

### iOS (Safari)
1. Safari で https://kiki-her.github.io/aozora-timeline/ を開く
2. 共有ボタン（□↑）をタップ
3. 「ホーム画面に追加」を選択
4. 「追加」をタップ
5. ホーム画面にアイコンが追加され、アプリのように起動可能

### Android (Chrome)
1. Chrome で https://kiki-her.github.io/aozora-timeline/ を開く
2. 右上のメニュー（⋮）をタップ
3. 「アプリをインストール」または「ホーム画面に追加」を選択
4. 「インストール」をタップ
5. アプリとしてインストールされ、ホーム画面に追加

### PWAの特徴
- ✅ オフライン対応（Service Workerによるキャッシュ）
- ✅ フルスクリーン表示（ブラウザUIを非表示）
- ✅ ローディング画面（スプラッシュスクリーン）
- ✅ ホーム画面アイコン
- ✅ アプリライクなUX

---

## 📄 ライセンス

MIT License

---

## 🙏 クレジット

### データソース
- **青空文庫**: https://www.aozora.gr.jp/
- 日本文学の名作を無償で提供する素晴らしいプロジェクト
- **青空文庫公式CSVデータ**: https://docs.google.com/spreadsheets/d/1-JtNfn7BIUTkw_XAEjXEno703w4qlB3fy0qR6u_JCPE/edit

### デザイン
- **X (Twitter)**: UI/UXデザインの参考
- **GOJO**: レスポンシブデザインの参考

---

## 📞 お問い合わせ

Issue報告・機能リクエスト: [GitHub Issues](https://github.com/Kiki-her/aozora-timeline/issues)

---

## 📝 更新履歴

### v2.0.0 (2024-01-10)
- ✨ **PWA対応**: ホーム画面追加、オフライン対応、Service Worker実装
- ✨ **SNS共有機能**: X (Twitter)、Facebook、LINE、リンクコピー
- ✨ **データソース更新**: 青空文庫公式CSVデータ（18,558作品）
- ✨ **冒頭テキスト表示**: 13,569作品で冒頭文を表示
- ✨ **青空 in Browsers URL**: 青空文庫ブラウザビューアへのリンク
- 🎨 **UI改善**: いいね・読了カウント削除、アイコンのみ表示
- 🎨 **UX改善**: ホームアイコンタップで最上部へスクロール
- 🚀 **GitHub Actions**: 自動ビルド＆デプロイ設定

### v1.0.0 (2024-01-09)
- 🎉 初回リリース
- 📚 タイムライン機能実装
- ❤️ いいね・読了機能実装
- 🎨 X (Twitter) UI完全再現
- 🌓 ダークモード対応

---

**Made with ❤️ for 文学愛好者**

**Powered by 青空文庫 & Flutter**
