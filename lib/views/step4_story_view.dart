import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../core/constants/app_routes.dart';
import '../core/theme/app_text_styles.dart';
import '../core/widgets/redime_outline_button.dart';
import '../core/widgets/section_header.dart';

import '../widgets/photo_upload_area.dart';

class Step4StoryView extends StatefulWidget {
  const Step4StoryView({super.key});

  @override
  State<Step4StoryView> createState() => _Step4StoryViewState();
}

class _Step4StoryViewState extends State<Step4StoryView> {
  final TextEditingController _storyController = TextEditingController();

  String? _photoPath;
  bool _isSubmitting = false;
  String? _errorMessage;

  Future<void> _pickPhoto() async {
    try {
      final picker = ImagePicker();

      final image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _photoPath = image.path;
        });
      }
    } catch (_) {
      // Photo picking cancelled or failed
    }
  }

  Future<void> _submit({required bool withStory}) async {
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      // Aquí puedes agregar tu lógica de envío

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, AppRoutes.pickupConfirmation);
    } catch (e) {
      setState(() {
        _errorMessage = 'Ocurrió un error al enviar la solicitud';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SectionHeader(
            title: 'Su Historia',
            subtitle: '¿Qué significa este objeto para ti?',
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              AppStrings.step4Description,
              style: AppTextStyles.screenSubtitle.copyWith(fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 24),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(AppStrings.storyLabel, style: AppTextStyles.fieldLabel),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: _storyController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: AppStrings.storyHint,
              alignLabelWithHint: true,
            ),
          ),

          const SizedBox(height: 20),

          PhotoUploadArea(photoPath: _photoPath, onTap: _pickPhoto),

          const SizedBox(height: 32),

          Row(
            children: [
              Expanded(
                child: RedimeOutlineButton(
                  label: AppStrings.skipButton,
                  onPressed: _isSubmitting
                      ? null
                      : () => _submit(withStory: false),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: OutlinedButton(
                  onPressed: _isSubmitting
                      ? null
                      : () => _submit(withStory: true),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryTeal,
                    side: const BorderSide(
                      color: AppColors.primaryTeal,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primaryTeal,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.sendStoryButton,
                              style: AppTextStyles.outlineButtonLabel,
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.send,
                              size: 16,
                              color: AppColors.primaryTeal,
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),

          if (_errorMessage != null) ...[
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: const TextStyle(color: AppColors.errorRed, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
