import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CustomNavShell extends StatelessWidget {
  final Widget child;

  const CustomNavShell({super.key, required this.child});

  static const tabs = [
    '/discover',
    '/favorites',
    '/profile',
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    int currentIndex = tabs.indexWhere((tab) => location.startsWith(tab));
    if (currentIndex == -1) currentIndex = 0;

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedFontSize: 12.sp,
        unselectedFontSize: 11.sp,
        selectedIconTheme: IconThemeData(size: 24.sp),
        unselectedIconTheme: IconThemeData(size: 22.sp),
        onTap: (index) {
          if (index != currentIndex) {
            context.go(tabs[index]);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
