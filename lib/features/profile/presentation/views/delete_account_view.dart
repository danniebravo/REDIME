import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/presentation/widgets/primary_button.dart';
import '../viewmodels/delete_account_view_model.dart';

class DeleteAccountView extends StatefulWidget {
  const DeleteAccountView({super.key});

  @override
  State<DeleteAccountView> createState() => _DeleteAccountViewState();
}

class _DeleteAccountViewState extends State<DeleteAccountView> {
  late final DeleteAccountViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = DeleteAccountViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textMain,
        iconTheme: const IconThemeData(color: AppColors.textMain),
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'REDIME',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMain,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Hasta luego :(',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMain,
                  ),
                ),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Pero antes, para eliminar tu cuenta, primero\ningresa tu correo y contraseña para\nverificar que eres tú.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textMain,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'correo electrónico@dominio.com',
                    hintStyle: const TextStyle(
                      color: AppColors.greyColor,
                      fontSize: 14,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.greyColor.withOpacity(0.5),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                  onChanged: _viewModel.updateEmail,
                ),
                const SizedBox(height: 16),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'contraseña',
                    hintStyle: const TextStyle(
                      color: AppColors.greyColor,
                      fontSize: 14,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.greyColor.withOpacity(0.5),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                  onChanged: _viewModel.updatePassword,
                ),
                if (_viewModel.errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _viewModel.errorMessage!,
                    style: const TextStyle(color: AppColors.error),
                  ),
                ],
                const SizedBox(height: 24),
                PrimaryButton(
                  text: 'Continuar',
                  isLoading: _viewModel.isLoading,
                  onPressed: _viewModel.canSubmit
                      ? () => _viewModel.deleteAccount(context)
                      : null,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
