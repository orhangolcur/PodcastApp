import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/auth_service.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String _username = "Misafir";
  String _email = "";

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userDetails = await _authService.getUserDetails();

    if (mounted) {
      setState(() {
        _username = userDetails['username'] ?? "Misafir Kullanıcı";
        _email = userDetails['email'] ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouter.of(context).routeInformationProvider.value.uri.path;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    return Drawer(
      width: isTablet ? screenWidth * 0.75 : null,
      backgroundColor: const Color(0xFF1C1B2D),
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              color: const Color(0xFF262033),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 32.r,
                    backgroundImage: const AssetImage('assets/images/profile.jpg'),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _username,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          _email,
                          style: TextStyle(fontSize: 13.sp, color: Colors.white70),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            _DrawerItem(
              icon: Icons.home,
              label: 'Discover',
              selected: currentPath == '/discover',
              onTap: () => context.go('/discover'),
            ),
            _DrawerItem(
              icon: Icons.favorite_border,
              label: 'Favorites',
              selected: currentPath == '/favorites',
              onTap: () => context.go('/favorites'),
            ),
            _DrawerItem(
              icon: Icons.person,
              label: 'Profile',
              selected: currentPath == '/profile',
              onTap: () => context.go('/profile'),
            ),

            _DrawerItem(
              icon: Icons.logout,
              label: 'Logout',
              selected: false,
              onTap: () async {
                await _authService.logout();
                if (context.mounted) {
                  context.go('/login');
                }
              },
            ),

            SizedBox(height: 20.h),
            Center(
              child: Text(
                'v1.0.0',
                style: TextStyle(color: Colors.white24, fontSize: 12.sp),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: selected ? Colors.white : Colors.white60,
        size: 24.sp,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.white70,
          fontSize: 15.sp,
        ),
      ),
      selected: selected,
      selectedTileColor: Colors.white10,
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}