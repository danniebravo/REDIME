import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../core/theme/app_text_styles.dart';
import '../core/widgets/primary_button.dart';
import '../core/widgets/section_header.dart';

class Step3AddressDateView extends StatefulWidget {
  final String address;
  final DateTime? pickupDate;
  final bool canContinue;
  final ValueChanged<String> onAddressChanged;
  final ValueChanged<DateTime> onPickupDateChanged;
  final VoidCallback onContinue;

  const Step3AddressDateView({
    super.key,
    required this.address,
    required this.pickupDate,
    required this.canContinue,
    required this.onAddressChanged,
    required this.onPickupDateChanged,
    required this.onContinue,
  });

  @override
  State<Step3AddressDateView> createState() => _Step3AddressDateViewState();
}

class _Step3AddressDateViewState extends State<Step3AddressDateView> {
  late final TextEditingController _addressController;
  late final TextEditingController _dateController;

  @override
  void initState() {
    super.initState();

    _addressController = TextEditingController(text: widget.address);
    _dateController = TextEditingController(
      text: _formatDate(widget.pickupDate),
    );
  }

  @override
  void didUpdateWidget(covariant Step3AddressDateView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.address != _addressController.text) {
      _addressController.text = widget.address;
    }

    final newDateText = _formatDate(widget.pickupDate);

    if (newDateText != _dateController.text) {
      _dateController.text = newDateText;
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd/MM/yy').format(date);
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: widget.pickupDate ?? now.add(const Duration(days: 1)),
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
      widget.onPickupDateChanged(picked);
    }
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
            onChanged: widget.onAddressChanged,
            decoration: const InputDecoration(hintText: AppStrings.addressHint),
          ),

          const SizedBox(height: 24),

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
            onTap: () => _pickDate(context),
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

          PrimaryButton(
            label: AppStrings.continueButton,
            onPressed: widget.canContinue ? widget.onContinue : null,
          ),
        ],
      ),
    );
  }
}
