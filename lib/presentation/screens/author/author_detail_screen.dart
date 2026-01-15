import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/responsive_wrapper.dart';
import '../../../domain/entities/book.dart';
import '../../../domain/entities/author.dart';
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
  Author? _authorInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAuthorData();
  }

  Future<void> _loadAuthorData() async {
    setState(() => _isLoading = true);

    final bookProvider = context.read<BookProvider>();
    
    // 著者情報と作品リストを並行して取得
    final results = await Future.wait([
      bookProvider.getAuthorInfo(widget.authorName),
      bookProvider.getBooksByAuthor(widget.authorName),
    ]);

    setState(() {
      _authorInfo = results[0] as Author?;
      _authorBooks = results[1] as List<Book>;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ResponsiveWrapper(
      child: Scaffold(
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
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomScrollView(
      slivers: [
        // 著者プロフィールヘッダー
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(24),
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
                // 著者アバター
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.borderGrayDark : AppColors.hoverGray,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        widget.authorName[0],
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 著者名
                Center(
                  child: Text(
                    widget.authorName,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // 生没年
                if (_authorInfo != null)
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _authorInfo!.lifeSpan,
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 12),

                // 作品数
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.borderGrayDark : AppColors.hoverGray,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_authorBooks.length}作品',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 作品一覧セクション
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(16),
            color: isDark ? AppColors.backgroundBlack : AppColors.backgroundWhite,
            child: Row(
              children: [
                Icon(
                  Icons.book_outlined,
                  size: 20,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  '作品一覧',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),

        // 作品リスト
        _authorBooks.isEmpty
            ? SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 48,
                          color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '作品が見つかりませんでした',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                          ),
                        ),
                      ],
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
