import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart'; // ✅ EKLENDİ
import '../../../core/services/auth_service.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditProfileScreen({super.key, required this.userData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _authService = AuthService();
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

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

  Future<void> _pickAndUploadImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() => _isUploading = true);

        final url = await _authService.uploadProfileImage(image.path);

        if (url != null) {
          setState(() {
            _imageUrlController.text = url;
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Resim yüklendi! Kaydetmeyi unutmayın.'), backgroundColor: Colors.green),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Resim seçilemedi: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
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
            onPressed: (_isLoading || _isUploading) ? null : _saveProfile,
            child: _isLoading
                ? SizedBox(width: 20.w, height: 20.w, child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Text("Kaydet", style: TextStyle(color: (_isLoading || _isUploading) ? Colors.white24 : Colors.blueAccent, fontSize: 16.sp, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50.r,
                    backgroundColor: Colors.grey.shade800,
                    backgroundImage: _imageUrlController.text.isNotEmpty
                        ? NetworkImage(_imageUrlController.text)
                        : null,
                    child: _isUploading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : (_imageUrlController.text.isEmpty
                        ? const Icon(Icons.person, size: 50, color: Colors.white54)
                        : null),
                  ),

                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: (_isLoading || _isUploading) ? null : _pickAndUploadImage,
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF1C1B2D), width: 3),
                        ),
                        child: Icon(Icons.camera_alt, color: Colors.white, size: 18.sp),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),

            _buildTextField("Kullanıcı Adı", _usernameController),
            SizedBox(height: 20.h),
            _buildTextField("Biyografi", _bioController, maxLines: 3),
            SizedBox(height: 20.h),

            _buildTextField("Resim URL", _imageUrlController, hint: "http://...", readOnly: false),

            SizedBox(height: 10.h),
            Text(
              "Fotoğraf ikonuna tıklayarak galeriden yükleme yapabilirsiniz.",
              style: TextStyle(color: Colors.white38, fontSize: 12.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1, String? hint, bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 14.sp)),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          maxLines: maxLines,
          readOnly: readOnly,
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