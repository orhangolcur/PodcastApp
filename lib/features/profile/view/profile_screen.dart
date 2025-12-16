import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/auth_service.dart';
import '../../discover/cubit/discover_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();

  String _username = "Loading...";
  String _email = "Loading...";
  String _bio = "";
  String _imageUrl = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userDetails = await _authService.getUserDetails();

    if (mounted) {
      setState(() {
        _username = userDetails['username'] ?? "Kullanıcı";
        _email = userDetails['email'] ?? "";
        _bio = userDetails['bio'] ?? "Henüz bir biyografi eklenmemiş.";
        _imageUrl = userDetails['imageUrl'] ?? "";
        _isLoading = false;
      });
    }
  }

  Future<void> _handleLogout() async {
    await _authService.logout();

    if (mounted) {
      context.read<DiscoverCubit>().resetState();

      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1B2D),
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(fontSize: 20.sp)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () async {
              final result = await context.push('/edit-profile', extra: {
                'username': _username,
                'bio': _bio == "Henüz bir biyografi eklenmemiş." ? "" : _bio,
                'imageUrl': _imageUrl,
              });

              if (result == true) {
                _loadUserData();
              }
            },
          ),
        ],
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
                      radius: 50.r,
                      backgroundColor: Colors.grey.shade800,
                      backgroundImage: _imageUrl.isNotEmpty
                          ? NetworkImage(_imageUrl)
                          : null,
                      child: _imageUrl.isEmpty
                          ? Icon(Icons.person, size: 50.r, color: Colors.white)
                          : null,
                    ),

                    SizedBox(height: 16.h),

                    Text(
                      _username,
                      style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: Colors.white),
                    ),

                    Text(
                      _email,
                      style: TextStyle(fontSize: 14.sp, color: Colors.white54),
                    ),

                    SizedBox(height: 12.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: Text(
                        _bio,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14.sp, color: Colors.white70, fontStyle: FontStyle.italic),
                      ),
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