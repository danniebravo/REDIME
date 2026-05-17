import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../core/theme/app_text_styles.dart';
import '../core/widgets/primary_button.dart';
import '../core/widgets/section_header.dart';

class Step3AddressDateView extends StatefulWidget {
  const Step3AddressDateView({super.key});

  @override
  State<Step3AddressDateView> createState() => _Step3AddressDateViewState();
}

class _Step3AddressDateViewState extends State<Step3AddressDateView> {
  final TextEditingController _addressController = TextEditingController();

  final TextEditingController _dateController = TextEditingController();

  DateTime? _pickupDate;

  @override
  void dispose() {
    _addressController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  bool get _canContinue {
    return _addressController.text.trim().isNotEmpty && _pickupDate != null;
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: _pickupDate ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryTeal,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _pickupDate = picked;
        _dateController.text = DateFormat('dd/MM/yy').format(picked);
      });
    }
  }

  void _continue() {
    // Aquí agregas tu lógica
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: SectionHeader(
              title: '¿A dónde vamos?',
              subtitle: '¿Dónde y cuándo pasamos por él?',
            ),
          ),

          const SizedBox(height: 36),

          // Address
          Row(
            children: [
              Text(AppStrings.addressLabel, style: AppTextStyles.fieldLabel),

              const SizedBox(width: 6),

              const Icon(
                Icons.location_on,
                size: 18,
                color: AppColors.primaryTeal,
              ),
            ],
          ),

          const SizedBox(height: 8),

          TextField(
            controller: _addressController,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(hintText: AppStrings.addressHint),
          ),

          const SizedBox(height: 24),

          // Date
          Row(
            children: [
              Text(AppStrings.dateLabel, style: AppTextStyles.fieldLabel),

              const SizedBox(width: 6),

              const Icon(
                Icons.calendar_today,
                size: 18,
                color: AppColors.primaryTeal,
              ),
            ],
          ),

          const SizedBox(height: 8),

          GestureDetector(
            onTap: _selectDate,
            child: AbsorbPointer(
              child: TextField(
                controller: _dateController,
                decoration: const InputDecoration(
                  hintText: AppStrings.dateHint,
                  suffixIcon: Icon(
                    Icons.calendar_month,
                    color: AppColors.primaryTeal,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Continue
          PrimaryButton(
            label: AppStrings.continueButton,
            onPressed: _canContinue ? _continue : null,
          ),
        ],
      ),
    );
  }
}
