import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../core/theme/app_text_styles.dart';
import '../core/widgets/redime_outline_button.dart';
import '../core/widgets/section_header.dart';
import '../widgets/photo_upload_area.dart';

class Step4StoryView extends StatefulWidget {
  final String story;
  final String? photoPath;
  final bool isSubmitting;
  final String? errorMessage;
  final ValueChanged<String> onStoryChanged;
  final ValueChanged<String?> onPhotoPathChanged;
  final Future<void> Function() onFinishWithoutStory;
  final Future<void> Function() onFinishWithStory;

  const Step4StoryView({
    super.key,
    required this.story,
    required this.photoPath,
    required this.isSubmitting,
    required this.errorMessage,
    required this.onStoryChanged,
    required this.onPhotoPathChanged,
    required this.onFinishWithoutStory,
    required this.onFinishWithStory,
  });

  @override
  State<Step4StoryView> createState() => _Step4StoryViewState();
}

class _Step4StoryViewState extends State<Step4StoryView> {
  late final TextEditingController _storyController;

  @override
  void initState() {
    super.initState();
    _storyController = TextEditingController(text: widget.story);
  }

  @override
  void didUpdateWidget(covariant Step4StoryView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.story != _storyController.text) {
      _storyController.text = widget.story;
    }
  }

  @override
  void dispose() {
    _storyController.dispose();
    super.dispose();
  }

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
        widget.onPhotoPathChanged(image.path);
      }
    } catch (_) {
      // Si el usuario cancela o falla la carga de imagen, no hacemos nada.
    }
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
            onChanged: widget.onStoryChanged,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: AppStrings.storyHint,
              alignLabelWithHint: true,
            ),
          ),

          const SizedBox(height: 20),

          PhotoUploadArea(photoPath: widget.photoPath, onTap: _pickPhoto),

          const SizedBox(height: 32),

          Row(
            children: [
              Expanded(
                child: RedimeOutlineButton(
                  label: AppStrings.skipButton,
                  onPressed: widget.isSubmitting
                      ? null
                      : () async {
                          await widget.onFinishWithoutStory();
                        },
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: OutlinedButton(
                  onPressed: widget.isSubmitting
                      ? null
                      : () async {
                          await widget.onFinishWithStory();
                        },
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
                  child: widget.isSubmitting
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

          if (widget.errorMessage != null) ...[
            const SizedBox(height: 16),
            Text(
              widget.errorMessage!,
              style: const TextStyle(color: AppColors.errorRed, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
