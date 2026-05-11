import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_routes.dart';
import 'stepper_widget.dart';

class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 35);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 35,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int? currentStep;
  final bool showBackButton;
  final Widget? bottomWidget;
  final Color backgroundColor;
  final Color titleColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.currentStep,
    this.showBackButton = true,
    this.bottomWidget,
    this.backgroundColor = AppColors.darkestTeal,
    this.titleColor = AppColors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CurvedBottomClipper(),
      child: Container(
        color: backgroundColor,
        padding: const EdgeInsets.only(
          top: 55,
          left: 24,
          right: 24,
          bottom: 50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (showBackButton)
                  GestureDetector(
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    child: Icon(Icons.arrow_back, color: titleColor, size: 28),
                  )
                else
                  const SizedBox(width: 28),

                Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    fontSize: 16,
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.chat);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: titleColor, width: 1.5),
                      color: Colors.transparent,
                    ),
                    child: Icon(
                      Icons.question_mark,
                      color: titleColor,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            if (currentStep != null) ...[
              const SizedBox(height: 24),
              StepperWidget(currentStep: currentStep!),
            ],
            if (bottomWidget != null) ...[
              const SizedBox(height: 20),
              bottomWidget!,
            ],
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(220);
}
