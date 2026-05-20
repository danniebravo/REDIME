import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';

class WeightDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const WeightDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.lightGrey,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      hint: const Text(
        AppStrings.selectPlaceholder,
        style: TextStyle(color: AppColors.disabledGrey, fontSize: 14),
      ),
      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.darkText),
      items: AppStrings.weightOptions.map((option) {
        return DropdownMenuItem(value: option, child: Text(option));
      }).toList(),
      onChanged: onChanged,
    );
  }
}
