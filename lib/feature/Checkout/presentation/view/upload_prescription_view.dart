import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_pharmacy/core/util/app_colors.dart';
import 'package:smart_pharmacy/core/widgets/button_app.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/manger/prescription/cubit/prescription_cubit.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/widget/doc_row.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/widget/guidelines_card.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/widget/header.dart';
import 'package:smart_pharmacy/feature/Checkout/presentation/view/widget/source_card.dart';
import 'package:smart_pharmacy/feature/home/presentation/views/home_view.dart';

class UploadPrescriptionView extends StatefulWidget {
  const UploadPrescriptionView({super.key, required this.orderId});

  static const routeName = "UploadPrescriptionView";

  final int orderId;

  @override
  State<UploadPrescriptionView> createState() => _UploadPrescriptionViewState();
}

class _UploadPrescriptionViewState extends State<UploadPrescriptionView> {
  static const _maxBytes = 5 * 1024 * 1024; // matches the backend's 5 MB limit

  final _picker = ImagePicker();
  final List<File> _files = [];

  Future<void> _pick(ImageSource source) async {
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
      setState(() => _files.add(file));
    } catch (_) {
      _snack(
        'Could not open the '
        '${source == ImageSource.camera ? 'camera' : 'gallery'}.',
);
    }
}

  void _remove(File file) => setState(() => _files.remove(file));

  void _submit() => context.read<PrescriptionCubit>().submit(
        orderId: widget.orderId,
        images: _files,
      );

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  void _onState(BuildContext context, PrescriptionState state) {
    if (state is PrescriptionFailure) {
      _snack(state.message);
    } else if (state is PrescriptionSuccess) {
      _snack('Submitted — your order is pending pharmacist review.');
      Navigator.pushNamedAndRemoveUntil(
        context,
        HomeView.routeName,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PrescriptionCubit, PrescriptionState>(
      listener: _onState,
      builder: (context, state) {
        final progress = state is PrescriptionUploading ? state : null;
        final busy = progress != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const Header(title: 'Medicine Details'),
          body: AbsorbPointer(
            absorbing: busy,
            child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upload your prescription',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Order #${widget.orderId}',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            const GuidelinesCard(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SourceCard(
                    icon: Icons.photo_camera_outlined,
                    label: 'Take photo',
                    circleColor: AppColors.deepTeal,
                    background: AppColors.primarySurface,
                          onTap: () => _pick(ImageSource.camera),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SourceCard(
                    icon: Icons.photo_library_outlined,
                    label: 'Gallery',
                    circleColor: AppColors.accent,
                    background: AppColors.accent.withValues(alpha: 0.12),
                          onTap: () => _pick(ImageSource.gallery),
                  ),
                ),
              ],
            ),
                  if (_files.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text(
                'UPLOADED DOCUMENTS',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
                    for (final f in _files)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                        child: DocRow(file: f, onRemove: () => _remove(f)),
                ),
            ],
          ],
        ),
      ),
          ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: PrimaryButton(
            backgroundColor: AppColors.deepTeal,
            foregroundColor: Colors.white,
                label: busy
                    ? 'Uploading ${progress.uploaded}/${progress.total}…'
                    : 'Submit for review',
                onPressed: _files.isEmpty || busy ? null : _submit,
          ),
        ),
      ),
    );
      },
    );
  }
}
