import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../domain/entities/book.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../providers/interaction_provider.dart';

/// 書籍詳細画面 (投稿内容全文表示)
class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final interactionProvider = context.watch<InteractionProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '投稿',
          style: textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 著者情報ヘッダー
            Padding(
              padding: const EdgeInsets.all(AppDimensions.space16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 著者アイコン
                  Container(
                    width: AppDimensions.avatarMedium,
                    height: AppDimensions.avatarMedium,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceGray : AppColors.hoverGray,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        book.authorName[0],
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.space12),
                  // 著者名と公開年
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.authorName,
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${book.publicationYear}年',
                          style: textTheme.labelSmall?.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // 書き出し全文
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.space16,
              ),
              child: Text(
                book.excerpt,
                style: textTheme.bodyLarge?.copyWith(height: 1.6),
              ),
            ),
            
            const SizedBox(height: AppDimensions.space16),
            
            // 書籍タイトル (リンク)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.space16,
              ),
              child: InkWell(
                onTap: () => _launchUrl(book.url),
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.space12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isDark
                          ? AppColors.borderGrayDark
                          : AppColors.borderGray,
                    ),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusMedium,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.title,
                              style: textTheme.bodyLarge?.copyWith(
                                color: AppColors.linkBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '青空文庫で続きを読む',
                              style: textTheme.labelSmall?.copyWith(
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.open_in_new,
                        size: AppDimensions.iconMedium,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: AppDimensions.space20),
            
            // Divider
            Divider(
              height: 1,
              thickness: 1,
              color: isDark ? AppColors.borderGrayDark : AppColors.borderGray,
            ),
            
            // インタラクションバー
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.space16,
                vertical: AppDimensions.space12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // いいねボタン
                  _ActionButton(
                    icon: book.isLiked ? Icons.favorite : Icons.favorite_border,
                    label: '${book.likeCount}',
                    color: book.isLiked ? AppColors.likeRed : null,
                    onTap: () => interactionProvider.toggleLike(book),
                  ),
                  // 読了ボタン
                  _ActionButton(
                    icon: book.isRead
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    label: '${book.readCount}',
                    color: book.isRead ? AppColors.retweetGreen : null,
                    onTap: () => interactionProvider.toggleRead(book),
                  ),
                  // 続きを読むボタン
                  _ActionButton(
                    icon: Icons.link,
                    label: '続きを読む',
                    onTap: () => _launchUrl(book.url),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppDimensions.space20),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

/// アクションボタン
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor =
        isDark ? AppColors.textTertiaryDark : AppColors.textTertiary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space12,
          vertical: AppDimensions.space8,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: AppDimensions.iconLarge,
              color: color ?? defaultColor,
            ),
            const SizedBox(width: AppDimensions.space8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: color ?? defaultColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
