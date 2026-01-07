import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../domain/entities/book.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../providers/interaction_provider.dart';
import '../../author/author_detail_screen.dart';

/// 書籍カード (X のツイートカード風)
class BookCard extends StatefulWidget {
  final Book book;

  const BookCard({super.key, required this.book});

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        // カードを展開/折りたたみ
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space12,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isDark ? AppColors.borderGrayDark : AppColors.borderGray,
              width: 1,
            ),
          ),
        ),
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
                  widget.book.authorName[0],
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.space12),
            // コンテンツ
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 著者名と公開年
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // 著者詳細画面へ遷移
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AuthorDetailScreen(
                                authorName: widget.book.authorName,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          widget.book.authorName,
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.space8),
                      Text(
                        '${widget.book.publicationYear}年',
                        style: textTheme.labelSmall?.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.space4),
                  // 書き出し (展開可能)
                  Text(
                    widget.book.excerpt,
                    style: textTheme.bodyLarge?.copyWith(height: 1.5),
                    maxLines: _isExpanded ? null : 3,
                    overflow: _isExpanded ? null : TextOverflow.ellipsis,
                  ),
                  // 「続きを読む」「折りたたむ」テキスト
                  if (!_isExpanded && widget.book.excerpt.length > 100)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '続きを読む',
                        style: textTheme.labelSmall?.copyWith(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  if (_isExpanded)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '折りたたむ',
                        style: textTheme.labelSmall?.copyWith(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  const SizedBox(height: AppDimensions.space8),
                  // 書籍タイトル
                  InkWell(
                    onTap: () => _launchUrl(widget.book.url),
                    child: Text(
                      widget.book.title,
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.linkBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space12),
                  // インタラクションバー
                  _InteractionBar(book: widget.book),
                ],
              ),
            ),
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

/// インタラクションバー (いいね・読了・続きを読む)
class _InteractionBar extends StatelessWidget {
  final Book book;

  const _InteractionBar({required this.book});

  @override
  Widget build(BuildContext context) {
    final interactionProvider = context.watch<InteractionProvider>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // いいねボタン
        _ActionButton(
          icon: book.isLiked ? Icons.favorite : Icons.favorite_border,
          label: book.likeCount.toString(),
          color: book.isLiked ? AppColors.likeRed : null,
          onTap: () => interactionProvider.toggleLike(book),
        ),
        // 読了ボタン
        _ActionButton(
          icon: book.isRead ? Icons.check_circle : Icons.check_circle_outline,
          label: book.readCount.toString(),
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
          horizontal: AppDimensions.space8,
          vertical: AppDimensions.space4,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: AppDimensions.iconMedium,
              color: color ?? defaultColor,
            ),
            const SizedBox(width: AppDimensions.space4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color ?? defaultColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
