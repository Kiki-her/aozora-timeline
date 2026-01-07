import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/local/hive_service.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/providers/book_provider.dart';
import 'presentation/providers/interaction_provider.dart';
import 'presentation/navigation/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Hive 初期化
  await HiveService.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => BookProvider()),
        ChangeNotifierProvider(create: (_) => InteractionProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: '青空文庫リーダー',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const _AppInitializer(),
          );
        },
      ),
    );
  }
}

/// アプリ初期化ラッパー（データ読み込み）
class _AppInitializer extends StatefulWidget {
  const _AppInitializer();

  @override
  State<_AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<_AppInitializer> {
  @override
  void initState() {
    super.initState();
    // 初回データ読み込み（非同期で実行）
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const MainNavigation();
  }
}
