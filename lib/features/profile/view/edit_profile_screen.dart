import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/auth_service.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditProfileScreen({super.key, required this.userData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _authService = AuthService();

  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  late TextEditingController _imageUrlController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.userData['username'] ?? '');
    _bioController = TextEditingController(text: widget.userData['bio'] ?? '');
    _imageUrlController = TextEditingController(text: widget.userData['imageUrl'] ?? '');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);

    try {
      await _authService.updateProfile(
        username: _usernameController.text,
        bio: _bioController.text,
        imageUrl: _imageUrlController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil başarıyla güncellendi!'), backgroundColor: Colors.green),
        );
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1B2D),
      appBar: AppBar(
        title: Text("Profili Düzenle", style: TextStyle(fontSize: 18.sp)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: _isLoading
                ? SizedBox(width: 20.w, height: 20.w, child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Text("Kaydet", style: TextStyle(color: Colors.blueAccent, fontSize: 16.sp, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 50.r,
                backgroundColor: Colors.grey.shade800,
                backgroundImage: _imageUrlController.text.isNotEmpty
                    ? NetworkImage(_imageUrlController.text)
                    : null,
                child: _imageUrlController.text.isEmpty
                    ? const Icon(Icons.person, size: 50, color: Colors.white54)
                    : null,
              ),
            ),
            SizedBox(height: 30.h),

            _buildTextField("Kullanıcı Adı", _usernameController),
            SizedBox(height: 20.h),
            _buildTextField("Biyografi", _bioController, maxLines: 3),
            SizedBox(height: 20.h),
            _buildTextField("Resim URL", _imageUrlController, hint: "http://..."),

            SizedBox(height: 10.h),
            Text(
              "Not: Resim yükleme özelliği yakında gelecek. Şimdilik geçerli bir resim linki yapıştırın.",
              style: TextStyle(color: Colors.white38, fontSize: 12.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1, String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 14.sp)),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          onChanged: (val) {
            if(label == "Resim URL") setState(() {});
          },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white24),
            filled: true,
            fillColor: const Color(0xFF262033),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          ),
        ),
      ],
    );
  }
}