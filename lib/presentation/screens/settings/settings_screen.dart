import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/theme_provider.dart';
import '../../providers/book_provider.dart';

/// 設定画面
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final bookProvider = context.watch<BookProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '設定',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: ListView(
        children: [
          // ダークモード切替
          SwitchListTile(
            title: const Text('ダークモード'),
            subtitle: const Text('アプリのテーマを切り替えます'),
            value: themeProvider.isDarkMode,
            onChanged: (value) => themeProvider.toggleTheme(),
            activeTrackColor: AppColors.primaryBlue,
          ),
          const Divider(),
          
          // データ再取得
          ListTile(
            leading: const Icon(Icons.refresh),
            title: const Text('データ再取得'),
            subtitle: const Text('青空文庫データを再度取得します'),
            onTap: () async {
              final messenger = ScaffoldMessenger.of(context);
              await bookProvider.refreshFromRemote();
              messenger.showSnackBar(
                const SnackBar(
                  content: Text('データを更新しました'),
                  backgroundColor: AppColors.primaryBlue,
                ),
              );
            },
          ),
          const Divider(),
          
          // アプリ情報
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('アプリ情報'),
            subtitle: const Text('青空文庫リーダー - Aozora Timeline'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: '青空文庫リーダー',
                applicationVersion: '1.0.0',
                applicationIcon: Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.book,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                children: [
                  const Text('X (Twitter) UIをベースにした青空文庫作品発見アプリ'),
                  const SizedBox(height: 16),
                  const Text('データソース:'),
                  const Text('青空文庫 (https://www.aozora.gr.jp/)'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
