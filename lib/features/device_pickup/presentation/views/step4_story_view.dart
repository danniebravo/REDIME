import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/redime_outline_button.dart';
import '../../../../core/widgets/section_header.dart';
import '../viewmodels/pickup_flow_viewmodel.dart';
import '../widgets/photo_upload_area.dart';

class Step4StoryView extends StatelessWidget {
  const Step4StoryView({super.key});

  Future<void> _pickPhoto(BuildContext context) async {
    try {
      final picker = ImagePicker();

      final image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null && context.mounted) {
        context.read<PickupFlowViewModel>().setPhotoPath(image.path);
      }
    } catch (_) {
      // Si el usuario cancela o falla la carga de imagen, no hacemos nada.
    }
  }

  Future<void> _finishWithoutStory(
    BuildContext context,
    PickupFlowViewModel vm,
  ) async {
    await vm.submitRequest(withStory: false);

    if (!context.mounted) return;

    if (vm.isCompleted) {
      Navigator.pushNamed(context, AppRoutes.pickupConfirmation, arguments: vm);
    }
  }

  Future<void> _finishWithStory(
    BuildContext context,
    PickupFlowViewModel vm,
  ) async {
    await vm.submitRequest(withStory: true);

    if (!context.mounted) return;

    if (vm.isCompleted) {
      Navigator.pushNamed(context, AppRoutes.pickupConfirmation, arguments: vm);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PickupFlowViewModel>();

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
            onChanged: vm.setStory,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: AppStrings.storyHint,
              alignLabelWithHint: true,
            ),
          ),

          const SizedBox(height: 20),

          PhotoUploadArea(
            photoPath: vm.photoPath,
            onTap: () => _pickPhoto(context),
          ),

          const SizedBox(height: 32),

          Row(
            children: [
              Expanded(
                child: RedimeOutlineButton(
                  label: AppStrings.skipButton,
                  onPressed: vm.isSubmitting
                      ? null
                      : () => _finishWithoutStory(context, vm),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: OutlinedButton(
                  onPressed: vm.isSubmitting
                      ? null
                      : () => _finishWithStory(context, vm),
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
                  child: vm.isSubmitting
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

          if (vm.errorMessage != null) ...[
            const SizedBox(height: 16),
            Text(
              vm.errorMessage!,
              style: const TextStyle(color: AppColors.errorRed, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
