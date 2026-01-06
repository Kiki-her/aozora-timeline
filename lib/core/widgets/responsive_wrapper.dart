import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// レスポンシブラッパー (GOJO UI風)
/// - モバイル: フル幅表示
/// - デスクトップ: 中央に最大幅で表示 + 背景装飾
class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  static const double maxMobileWidth = 600.0;

  const ResponsiveWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = screenWidth > maxMobileWidth;

    if (!isDesktop) {
      // モバイル: フル幅表示
      return child;
    }

    // デスクトップ: 中央に配置 + 背景装飾
    return Stack(
      children: [
        // 背景装飾
        _DesktopBackground(isDark: isDark),
        
        // 中央のアプリコンテンツ
        Center(
          child: Container(
            width: maxMobileWidth,
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundBlack : AppColors.backgroundWhite,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}

/// デスクトップ背景装飾
class _DesktopBackground extends StatelessWidget {
  final bool isDark;

  const _DesktopBackground({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF1a1a2e),
                  const Color(0xFF16213e),
                  const Color(0xFF0f3460),
                ]
              : [
                  const Color(0xFFe3f2fd),
                  const Color(0xFFbbdefb),
                  const Color(0xFF90caf9),
                ],
        ),
      ),
      child: Stack(
        children: [
          // 装飾的な円形パターン
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.03)
                    : Colors.white.withValues(alpha: 0.5),
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            left: -150,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.03)
                    : Colors.white.withValues(alpha: 0.5),
              ),
            ),
          ),
          
          // 本のアイコンパターン (青空文庫テーマ)
          ...List.generate(5, (index) {
            return Positioned(
              top: 100.0 + (index * 150),
              left: 50.0 + (index % 2 == 0 ? 0 : 100),
              child: Icon(
                Icons.menu_book_outlined,
                size: 80,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.02)
                    : Colors.white.withValues(alpha: 0.3),
              ),
            );
          }),
          
          ...List.generate(5, (index) {
            return Positioned(
              top: 50.0 + (index * 150),
              right: 50.0 + (index % 2 == 0 ? 0 : 100),
              child: Icon(
                Icons.auto_stories_outlined,
                size: 80,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.02)
                    : Colors.white.withValues(alpha: 0.3),
              ),
            );
          }),
        ],
      ),
    );
  }
}
