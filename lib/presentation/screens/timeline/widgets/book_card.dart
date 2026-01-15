import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
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
            // 著者アイコン（タップで著者詳細画面へ遷移）
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AuthorDetailScreen(
                      authorName: widget.book.authorName,
                    ),
                  ),
                );
              },
              child: Container(
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
                  // 書籍タイトル（青空 in Browsers URLへリンク）
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

  /// 青空文庫のURLを外部ブラウザで開く
  /// book.urlには青空 in Browsers URL (https://aozora.binb.jp/reader/main.html?cid=作品ID) が格納されている
  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

/// インタラクションバー (いいね・読了・共有・続きを読む)
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
          color: book.isLiked ? AppColors.likeRed : null,
          onTap: () => interactionProvider.toggleLike(book),
        ),
        // 読了ボタン
        _ActionButton(
          icon: book.isRead ? Icons.check_circle : Icons.check_circle_outline,
          color: book.isRead ? AppColors.retweetGreen : null,
          onTap: () => interactionProvider.toggleRead(book),
        ),
        // 共有ボタン
        _ActionButton(
          icon: Icons.share_outlined,
          onTap: () => _showShareDialog(context, book),
        ),
        // 続きを読むボタン（青空 in Browsers URLへリンク）
        _ActionButton(
          icon: Icons.link,
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

  void _showShareDialog(BuildContext context, Book book) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _ShareBottomSheet(book: book),
    );
  }
}

/// アクションボタン
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
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
        child: Icon(
          icon,
          size: AppDimensions.iconMedium,
          color: color ?? defaultColor,
        ),
      ),
    );
  }
}

/// 共有ボトムシート
class _ShareBottomSheet extends StatelessWidget {
  final Book book;

  const _ShareBottomSheet({required this.book});

  @override
  Widget build(BuildContext context) {
    final shareText = '「${book.title}」${book.authorName}著\n${book.excerpt.substring(0, book.excerpt.length > 100 ? 100 : book.excerpt.length)}...\n\n${book.url}';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '共有',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppDimensions.space16),
          // X (Twitter)
          _ShareOption(
            icon: Icons.close,
            label: 'X (Twitter)で共有',
            onTap: () {
              final encodedText = Uri.encodeComponent(shareText);
              final url = 'https://twitter.com/intent/tweet?text=$encodedText';
              _launchUrl(url);
              Navigator.pop(context);
            },
          ),
          const Divider(),
          // Facebook
          _ShareOption(
            icon: Icons.facebook,
            label: 'Facebookで共有',
            onTap: () {
              final encodedUrl = Uri.encodeComponent(book.url);
              final url = 'https://www.facebook.com/sharer/sharer.php?u=$encodedUrl';
              _launchUrl(url);
              Navigator.pop(context);
            },
          ),
          const Divider(),
          // LINE
          _ShareOption(
            icon: Icons.chat_bubble_outline,
            label: 'LINEで共有',
            onTap: () {
              final encodedText = Uri.encodeComponent(shareText);
              final url = 'https://line.me/R/share?text=$encodedText';
              _launchUrl(url);
              Navigator.pop(context);
            },
          ),
          const Divider(),
          // リンクをコピー
          _ShareOption(
            icon: Icons.content_copy,
            label: 'リンクをコピー',
            onTap: () {
              Clipboard.setData(ClipboardData(text: shareText));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('クリップボードにコピーしました'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
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

/// 共有オプション
class _ShareOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ShareOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.space12),
        child: Row(
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: AppDimensions.space16),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}