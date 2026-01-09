import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/book_provider.dart';
import 'widgets/book_card.dart';

/// タイムライン画面 (ホーム)
class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => TimelineScreenState();
}

class TimelineScreenState extends State<TimelineScreen> {
  final _scrollController = ScrollController();

  /// タイムラインを最上部にスクロール（X/Twitter風）
  void scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // 初回データ読み込み（main.dartで既に実行されているのでスキップ可能）
    // 必要に応じてコメントアウト解除
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<BookProvider>().initialize();
    // });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // 最下部近くで追加読み込み
      context.read<BookProvider>().loadMore();
    }
  }

  Future<void> _onRefresh() async {
    await context.read<BookProvider>().refresh();
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = context.watch<BookProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ホーム',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // 設定画面へ遷移 (後で実装)
            },
          ),
        ],
      ),
      body: _buildBody(bookProvider, isDark),
    );
  }

  Widget _buildBody(BookProvider bookProvider, bool isDark) {
    if (bookProvider.isLoading && !bookProvider.hasBooks) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppColors.primaryBlue,
            ),
            const SizedBox(height: 16),
            Text(
              '書籍データを読み込んでいます...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    if (bookProvider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.errorRed,
            ),
            const SizedBox(height: 16),
            Text(
              bookProvider.error!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => bookProvider.initialize(),
              child: const Text('再試行'),
            ),
          ],
        ),
      );
    }

    if (!bookProvider.hasBooks) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book_outlined,
              size: 64,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              '書籍が見つかりませんでした',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => bookProvider.initialize(),
              child: const Text('データを取得'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppColors.primaryBlue,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: bookProvider.books.length + 1,
        itemBuilder: (context, index) {
          if (index == bookProvider.books.length) {
            // 最下部のローディングインジケーター
            return bookProvider.isLoading
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          }

          final book = bookProvider.books[index];
          return BookCard(book: book);
        },
      ),
    );
  }
}
