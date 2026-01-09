import 'package:flutter/material.dart';
import '../screens/timeline/timeline_screen.dart';
import '../screens/likes/likes_screen.dart';
import '../screens/reads/reads_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../../core/widgets/responsive_wrapper.dart';

/// メインナビゲーション (ボトムナビゲーションバー)
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final GlobalKey<TimelineScreenState> _timelineKey = GlobalKey<TimelineScreenState>();

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    // スクリーンリストを初期化（TimelineScreenにKeyを渡す）
    _screens.addAll([
      TimelineScreen(key: _timelineKey),
      const LikesScreen(),
      const ReadsScreen(),
      const SettingsScreen(),
    ]);
  }

  void _onTabTapped(int index) {
    if (index == 0 && _currentIndex == 0) {
      // 既にホーム画面にいる場合、タイムラインを最上部にスクロール
      _timelineKey.currentState?.scrollToTop();
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'ホーム',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(Icons.favorite),
              label: 'いいね',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline),
              activeIcon: Icon(Icons.check_circle),
              label: '読了',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: '設定',
            ),
          ],
        ),
      ),
    );
  }
}
