
   import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/feature/profile/presentation/manger/cubit/profile_cubit.dart';

/// Circular avatar with a camera badge. Picking an image uploads it via
/// [ProfileCubit.uploadAvatar]; the new URL comes back through the cubit state.
class UploadAvatarWidget extends StatefulWidget {
  const UploadAvatarWidget({super.key, required this.avatarUrl});

  final String? avatarUrl;

  @override
  State<UploadAvatarWidget> createState() => _UploadAvatarWidgetState();
}

class _UploadAvatarWidgetState extends State<UploadAvatarWidget> {
  static const _maxBytes = 5 * 1024 * 1024; // backend's 5 MB limit

  final _picker = ImagePicker();
  bool _uploading = false;

  Future<void> _change() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;

    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 2000,
      );
      if (picked == null) return;

      final file = File(picked.path);
      if (await file.length() > _maxBytes) {
        _snack('Image is larger than 5 MB. Try a smaller photo.');
        return;
      }
    
      if (!mounted) return;
      //بلش رفع
      setState(() => _uploading = true);
      //تخزين في DB
      await context.read<ProfileCubit>().uploadAvatar(file);
      // خلص رفع
      if (mounted) setState(() => _uploading = false);
    } catch (_) {
      if (!mounted) return;
      setState(() => _uploading = false);
      _snack(
        'Could not open the '
        '${source == ImageSource.camera ? 'camera' : 'gallery'}.',
);
    }
}

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    final url = widget.avatarUrl;
    final hasUrl = url != null && url.isNotEmpty;

    return Center(
      child: SizedBox(
        width: 124,
        height: 124,
        child: Stack(
          children: [
            CircleAvatar(
             radius: 60,
          backgroundColor: AppColors.categoryBorder,
              backgroundImage: hasUrl ? NetworkImage(url) : null,
              child: hasUrl
                  ? null
                  : const Icon(Icons.person, size: 52, color: Colors.white),
            ),
            if (_uploading)
              const Positioned.fill(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.black45,
                  child: CircularProgressIndicator(color: Colors.white),
                ),
        ),
         Positioned(
              right: 2,
              bottom: 2,
           child: GestureDetector(
            //يعني اذا قاعد برفع الصوره المستخدم ما بقدر يضغط ع زر الكاميرا
                onTap: _uploading ? null : _change,
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.deepTeal,
                    border: Border.all(color: AppColors.background, width: 2),
                  ),
                  child: const Icon(Icons.camera_alt, size: 15, color: Colors.white),
                   ),
           ),
         ),
          ],
        ),
      ),
    );
  }
}
