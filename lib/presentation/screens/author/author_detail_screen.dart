import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/book.dart';
import '../../providers/book_provider.dart';
import '../timeline/widgets/book_card.dart';

class AuthorDetailScreen extends StatefulWidget {
  final String authorName;

  const AuthorDetailScreen({
    super.key,
    required this.authorName,
  });

  @override
  State<AuthorDetailScreen> createState() => _AuthorDetailScreenState();
}

class _AuthorDetailScreenState extends State<AuthorDetailScreen> {
  List<Book> _authorBooks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAuthorBooks();
  }

  Future<void> _loadAuthorBooks() async {
    setState(() => _isLoading = true);

    final bookProvider = context.read<BookProvider>();
    final books = await bookProvider.getBooksByAuthor(widget.authorName);

    setState(() {
      _authorBooks = books;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundBlack : AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surfaceGray : AppColors.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.authorName,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomScrollView(
      slivers: [
        // 著者プロフィールヘッダー
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceGray : AppColors.backgroundWhite,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.borderGrayDark : AppColors.borderGray,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 著者名
                Text(
                  widget.authorName,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),

                // 作品数
                Text(
                  '${_authorBooks.length}作品',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),

                // 青空文庫リンク
                InkWell(
                  onTap: () {
                    // 著者検索URLを開く（将来的にWebView統合）
                    // https://www.aozora.gr.jp/index_pages/person_search.html
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.open_in_new,
                        size: 18,
                        color: AppColors.primaryBlue,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '青空文庫で著者を見る',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryBlue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // 作品一覧セクション
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '作品一覧',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
            ),
          ),
        ),

        // 作品リスト
        _authorBooks.isEmpty
            ? SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      '作品が見つかりませんでした',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              )
            : SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return BookCard(book: _authorBooks[index]);
                  },
                  childCount: _authorBooks.length,
                ),
              ),
      ],
    );
  }
}
