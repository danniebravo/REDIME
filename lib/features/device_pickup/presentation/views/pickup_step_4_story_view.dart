import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../viewmodels/pickup_viewmodel.dart';

class PickupStep4StoryView extends StatefulWidget {
  const PickupStep4StoryView({super.key});

  @override
  State<PickupStep4StoryView> createState() => _PickupStep4StoryViewState();
}

class _PickupStep4StoryViewState extends State<PickupStep4StoryView> {
  late PickupViewModel _viewModel;
  final TextEditingController _storyController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as PickupViewModel?;
    _viewModel = args ?? PickupViewModel();
    _viewModel.addListener(_onViewModelChange);
    _storyController.text = _viewModel.storyText;
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChange);
    _storyController.dispose();
    super.dispose();
  }

  void _onViewModelChange() {
    setState(() {});
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
      _viewModel.setStoryImage(image.path);
    }
  }

  Future<void> _pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
      _viewModel.setStoryImage(image.path);
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Seleccionar imagen',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.teal.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt, color: AppColors.darkTeal),
                ),
                title: const Text('Tomar foto'),
                subtitle: const Text('Usa la cámara de tu dispositivo'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImageFromCamera();
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.teal.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.photo_library, color: AppColors.darkTeal),
                ),
                title: const Text('Elegir de galería'),
                subtitle: const Text('Selecciona una imagen existente'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImageFromGallery();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onSkip() async {
    if (_viewModel.isSubmitting) return;
    _viewModel.skipStory();
    final ok = await _viewModel.submit();
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_viewModel.submitError ?? 'Error al guardar')),
      );
      return;
    }
    Navigator.pushNamed(context, AppRoutes.pickupConfirm, arguments: _viewModel);
  }

  Future<void> _onSubmitStory() async {
    if (_viewModel.isSubmitting) return;
    _viewModel.setStoryImageBytes(_imageBytes);
    _viewModel.submitStory();
    final ok = await _viewModel.submit();
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_viewModel.submitError ?? 'Error al guardar')),
      );
      return;
    }
    Navigator.pushNamed(context, AppRoutes.pickupConfirm, arguments: _viewModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'REDIME',
        currentStep: 4,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),

                    // Title
                    const Text(
                      'Su Historia',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Subtitle
                    const Text(
                      '¿Qué significa este objeto para ti?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkTeal,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Description
                    Text(
                      'Este paso es totalmente opcional; si no quieres que tu dispositivo aparezca como exhibición en el museo de memorias de REDIME, solo salta este paso.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.darkTeal.withOpacity(0.7),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Story text area
                    const Text(
                      'Escribe un recuerdo o mensaje',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMain,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.lightTeal, width: 1.5),
                      ),
                      child: TextField(
                        controller: _storyController,
                        onChanged: (val) => _viewModel.setStoryText(val),
                        maxLines: 5,
                        maxLength: 500,
                        decoration: InputDecoration(
                          hintText: 'Este fue mi primer celular...',
                          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                          contentPadding: const EdgeInsets.all(16),
                          border: InputBorder.none,
                          counterStyle: TextStyle(color: AppColors.teal.withOpacity(0.6), fontSize: 11),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Photo upload area (real image picker)
                    GestureDetector(
                      onTap: _showImageSourceDialog,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.lightTeal, width: 1.5),
                        ),
                        child: _imageBytes != null
                            ? Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.memory(
                                      _imageBytes!,
                                      height: 180,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _imageBytes = null;
                                        });
                                        _viewModel.setStoryImage(null);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.close, color: Colors.white, size: 18),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    left: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.darkTeal.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'Toca para cambiar',
                                        style: TextStyle(color: Colors.white, fontSize: 11),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Icon(
                                    Icons.camera_alt_outlined,
                                    size: 48,
                                    color: AppColors.darkTeal.withOpacity(0.5),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Subir foto del recuerdo',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textMain,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '(Esta imagen será colocada a la par de tu\ndispositivo en el museo, contando su historia.)',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.darkTeal.withOpacity(0.5),
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Bottom buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Row(
                children: [
                  // Omitir button (HU-20)
                  Expanded(
                    flex: 2,
                    child: OutlinedButton(
                      onPressed: _onSkip,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.darkTeal,
                        side: const BorderSide(color: AppColors.darkTeal),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Omitir...',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Enviar historia button (HU-19)
                  Expanded(
                    flex: 3,
                    child: ElevatedButton(
                      onPressed: _viewModel.canSubmitStory ? _onSubmitStory : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _viewModel.canSubmitStory
                            ? AppColors.darkTeal
                            : AppColors.disabledButton,
                        foregroundColor: _viewModel.canSubmitStory
                            ? AppColors.white
                            : AppColors.disabledText,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Enviar historia',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.send, size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
