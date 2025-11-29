import 'package:gorider/core/utils/exports.dart';

enum StatusType { success, error, warning, info }

class StatusBottomSheet extends StatelessWidget {
  const StatusBottomSheet({
    super.key,
    required this.type,
    required this.title,
    required this.message,
    this.buttonText,
    this.onButtonPressed,
    this.secondaryButtonText,
    this.onSecondaryButtonPressed,
    this.autoDismiss = false,
    this.autoDismissDuration = const Duration(seconds: 3),
  });

  final StatusType type;
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryButtonPressed;
  final bool autoDismiss;
  final Duration autoDismissDuration;

  // Get colors based on status type
  Color get _primaryColor {
    switch (type) {
      case StatusType.success:
        return const Color(0xFF22C55E); // Green
      case StatusType.error:
        return const Color(0xFFEF4444); // Red
      case StatusType.warning:
        return const Color(0xFFF59E0B); // Amber
      case StatusType.info:
        return AppColors.primaryColor;
    }
  }

  Color get _lightColor {
    switch (type) {
      case StatusType.success:
        return const Color(0xFFDCFCE7);
      case StatusType.error:
        return const Color(0xFFFEE2E2);
      case StatusType.warning:
        return const Color(0xFFFEF3C7);
      case StatusType.info:
        return AppColors.primaryColor.withOpacity(0.1);
    }
  }

  IconData get _icon {
    switch (type) {
      case StatusType.success:
        return Icons.check_circle_rounded;
      case StatusType.error:
        return Icons.error_rounded;
      case StatusType.warning:
        return Icons.warning_rounded;
      case StatusType.info:
        return Icons.info_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Auto dismiss if enabled
    if (autoDismiss) {
      Future.delayed(autoDismissDuration, () {
        if (Get.isBottomSheetOpen ?? false) {
          Get.back();
        }
      });
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.greyColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          SizedBox(height: 24.h),

          // Icon with animated background
          _AnimatedStatusIcon(
            icon: _icon,
            primaryColor: _primaryColor,
            lightColor: _lightColor,
          ),

          SizedBox(height: 20.h),

          // Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: customText(
              title,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.blackColor,
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible
            ),
          ),

          SizedBox(height: 8.h),

          // Message
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: customText(
              message,
              fontSize: 14.sp,
              color: AppColors.greyColor,
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
              height: 1.5,
            ),
          ),

          SizedBox(height: 28.h),

          // Buttons
          if (buttonText != null || secondaryButtonText != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  // Primary Button
                  if (buttonText != null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onButtonPressed ?? () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          foregroundColor: AppColors.whiteColor,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 0,
                        ),
                        child: customText(
                          buttonText!,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),

                  // Secondary Button
                  if (secondaryButtonText != null) ...[
                    SizedBox(height: 12.h),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: onSecondaryButtonPressed ?? () => Get.back(),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: customText(
                          secondaryButtonText!,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.greyColor,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

          // Bottom safe area padding
          SizedBox(height: MediaQuery.of(context).padding.bottom + 24.h),
        ],
      ),
    );
  }
}

/// Animated icon widget with pulsing background effect
class _AnimatedStatusIcon extends StatefulWidget {
  const _AnimatedStatusIcon({
    required this.icon,
    required this.primaryColor,
    required this.lightColor,
  });

  final IconData icon;
  final Color primaryColor;
  final Color lightColor;

  @override
  State<_AnimatedStatusIcon> createState() => _AnimatedStatusIconState();
}

class _AnimatedStatusIconState extends State<_AnimatedStatusIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer glow
            Container(
              width: 100.sp,
              height: 100.sp,
              decoration: BoxDecoration(
                color: widget.lightColor.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
            // Inner circle
            Container(
              width: 76.sp,
              height: 76.sp,
              decoration: BoxDecoration(
                color: widget.lightColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon,
                color: widget.primaryColor,
                size: 42.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================
// Helper functions for easy usage
// ============================================

/// Show success bottom sheet
void showSuccessSheet({
  required String title,
  required String message,
  String? buttonText,
  VoidCallback? onButtonPressed,
  bool autoDismiss = false,
}) {
  Get.bottomSheet(
    StatusBottomSheet(
      type: StatusType.success,
      title: title,
      message: message,
      buttonText: buttonText ?? "Done",
      onButtonPressed: onButtonPressed,
      autoDismiss: autoDismiss,
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

/// Show error bottom sheet
void showErrorSheet({
  required String title,
  required String message,
  String? buttonText,
  VoidCallback? onButtonPressed,
  String? secondaryButtonText,
  VoidCallback? onSecondaryButtonPressed,
}) {
  Get.bottomSheet(
    StatusBottomSheet(
      type: StatusType.error,
      title: title,
      message: message,
      buttonText: buttonText ?? "Try Again",
      onButtonPressed: onButtonPressed,
      secondaryButtonText: secondaryButtonText,
      onSecondaryButtonPressed: onSecondaryButtonPressed,
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

/// Show warning bottom sheet
void showWarningSheet({
  required String title,
  required String message,
  String? buttonText,
  VoidCallback? onButtonPressed,
  String? secondaryButtonText,
  VoidCallback? onSecondaryButtonPressed,
}) {
  Get.bottomSheet(
    StatusBottomSheet(
      type: StatusType.warning,
      title: title,
      message: message,
      buttonText: buttonText ?? "OK",
      onButtonPressed: onButtonPressed,
      secondaryButtonText: secondaryButtonText,
      onSecondaryButtonPressed: onSecondaryButtonPressed,
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

/// Show info bottom sheet
void showInfoSheet({
  required String title,
  required String message,
  String? buttonText,
  VoidCallback? onButtonPressed,
  bool autoDismiss = false,
}) {
  Get.bottomSheet(
    StatusBottomSheet(
      type: StatusType.info,
      title: title,
      message: message,
      buttonText: buttonText ?? "Got it",
      onButtonPressed: onButtonPressed,
      autoDismiss: autoDismiss,
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}
