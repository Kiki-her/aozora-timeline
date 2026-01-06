import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// X (Twitter) スタイルのDivider
class XDivider extends StatelessWidget {
  const XDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Divider(
      height: 1,
      thickness: 1,
      color: isDark ? AppColors.borderGrayDark : AppColors.borderGray,
    );
  }
}
