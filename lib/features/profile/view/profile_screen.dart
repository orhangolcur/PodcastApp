import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();

  String _username = "Loading...";
  String _email = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await _authService.getUserDetails();
    if (mounted) {
      setState(() {
        _username = userData['username']!;
        _email = userData['email']!;
      });
    }
  }

  Future<void> _handleLogout() async {
    await _authService.logout();
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstLetter = _username.isNotEmpty ? _username[0].toUpperCase() : "?";

    return Scaffold(
      backgroundColor: const Color(0xFF1C1B2D),
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(fontSize: 20.sp)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600.w),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 48.r,
                      backgroundColor: Colors.deepPurpleAccent,
                      child: Text(
                        firstLetter,
                        style: TextStyle(
                            fontSize: 40.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    Text(
                      _username,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),

                    Text(
                      _email,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32.h),

                    _buildProfileCard(
                      icon: Icons.favorite_border,
                      title: 'Favorites',
                      onTap: () => context.push("/favorites"),
                    ),
                    SizedBox(height: 12.h),
                    _buildProfileCard(
                      icon: Icons.info_outline,
                      title: 'About Podkes',
                      onTap: () => showAboutDialog(context: context),
                    ),
                    SizedBox(height: 12.h),
                    _buildProfileCard(
                      icon: Icons.star_border,
                      title: 'Rate Podkes',
                      onTap: () {},
                    ),

                    SizedBox(height: 32.h),

                    SizedBox(
                      width: double.infinity,
                      child: TextButton.icon(
                        onPressed: _handleLogout,
                        icon: Icon(Icons.logout, color: Colors.redAccent, size: 20.sp),
                        label: Text(
                          "Log Out",
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          backgroundColor: Colors.redAccent.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: const Color(0xFF262033),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 22.sp),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}