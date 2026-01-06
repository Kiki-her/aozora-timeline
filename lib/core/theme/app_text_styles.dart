import 'package:flutter/material.dart';
import 'app_colors.dart';

/// X (Twitter) タイポグラフィシステム
class AppTextStyles {
  // 日本語対応フォント (システムフォント使用)
  static const String _fontFamily = 'Noto Sans JP';
  
  /// Light Mode テキストテーマ
  static TextTheme lightTextTheme = TextTheme(
    displayLarge: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
      fontFamily: _fontFamily,
    ),
    headlineMedium: const TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
      fontFamily: _fontFamily,
    ),
    bodyLarge: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
      height: 1.4,
      fontFamily: _fontFamily,
    ),
    bodyMedium: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary,
      fontFamily: _fontFamily,
    ),
    labelSmall: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary,
      fontFamily: _fontFamily,
    ),
  );
  
  /// Dark Mode テキストテーマ
  static TextTheme darkTextTheme = TextTheme(
    displayLarge: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimaryDark,
      fontFamily: _fontFamily,
    ),
    headlineMedium: const TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimaryDark,
      fontFamily: _fontFamily,
    ),
    bodyLarge: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimaryDark,
      height: 1.4,
      fontFamily: _fontFamily,
    ),
    bodyMedium: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondaryDark,
      fontFamily: _fontFamily,
    ),
    labelSmall: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondaryDark,
      fontFamily: _fontFamily,
    ),
  );
}
