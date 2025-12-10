import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:podkes_app/features/favorites/view/favorites_screen.dart';
import '../../features/discover/view/discover_screen.dart';
import '../../features/profile/view/profile_screen.dart';

class MainScreen extends StatelessWidget {
  final int currentIndex;

  const MainScreen({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = const [
      DiscoverScreen(),
      FavoritesScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF1C1B2D),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: const Color(0xFF1C1B2D),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12.sp,
        unselectedFontSize: 11.sp,
        selectedIconTheme: IconThemeData(size: 24.sp),
        unselectedIconTheme: IconThemeData(size: 22.sp),
        showUnselectedLabels: true,
        onTap: (index) {
          switch (index) {
            case 0:
              context.push('/home');
              break;
            case 1:
              context.push('/favorites');
              break;
            case 2:
              context.push('/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Library',
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
