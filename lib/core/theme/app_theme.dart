import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_dimensions.dart';

/// X (Twitter) UI完全再現グローバルテーマ
class AppTheme {
  /// ライトテーマ
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // カラー
    primaryColor: AppColors.primaryBlue,
    scaffoldBackgroundColor: AppColors.backgroundWhite,
    
    // テキストテーマ
    textTheme: AppTextStyles.lightTextTheme,
    
    // カードテーマ
    cardTheme: CardThemeData(
      color: AppColors.backgroundWhite,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        side: const BorderSide(color: AppColors.borderGray, width: 1),
      ),
    ),
    
    // アイコンテーマ
    iconTheme: const IconThemeData(
      color: AppColors.textSecondary,
      size: 20,
    ),
    
    // AppBarテーマ
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundWhite,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: AppTextStyles.lightTextTheme.headlineMedium,
      surfaceTintColor: Colors.transparent,
    ),
    
    // ボトムナビゲーション
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.backgroundWhite,
      selectedItemColor: AppColors.primaryBlue,
      unselectedItemColor: AppColors.textTertiary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    ),
    
    // ボタンテーマ
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space20,
          vertical: AppDimensions.space12,
        ),
      ),
    ),
    
    // Divider
    dividerTheme: const DividerThemeData(
      color: AppColors.borderGray,
      thickness: 1,
      space: 0,
    ),
  );
  
  /// ダークテーマ
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    primaryColor: AppColors.primaryBlue,
    scaffoldBackgroundColor: AppColors.backgroundBlack,
    
    textTheme: AppTextStyles.darkTextTheme,
    
    cardTheme: CardThemeData(
      color: AppColors.surfaceGray,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        side: const BorderSide(color: AppColors.borderGrayDark, width: 1),
      ),
    ),
    
    iconTheme: const IconThemeData(
      color: AppColors.textSecondaryDark,
      size: 20,
    ),
    
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundBlack,
      foregroundColor: AppColors.textPrimaryDark,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: AppTextStyles.darkTextTheme.headlineMedium,
      surfaceTintColor: Colors.transparent,
    ),
    
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.backgroundBlack,
      selectedItemColor: AppColors.primaryBlue,
      unselectedItemColor: AppColors.textTertiaryDark,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space20,
          vertical: AppDimensions.space12,
        ),
      ),
    ),
    
    dividerTheme: const DividerThemeData(
      color: AppColors.borderGrayDark,
      thickness: 1,
      space: 0,
    ),
  );
}
