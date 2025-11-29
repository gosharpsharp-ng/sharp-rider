import 'package:gorider/core/utils/exports.dart';

class DeliveryContactCard extends StatelessWidget {
  const DeliveryContactCard({
    super.key,
    required this.senderName,
    required this.senderInitials,
    required this.senderPhone,
    required this.receiverName,
    required this.receiverInitials,
    required this.receiverPhone,
    this.senderAvatar,
    this.onSenderCall,
    this.onReceiverCall,
    this.showCallButtons = true,
    this.useCircleCallButton = false,
  });

  final String senderName;
  final String senderInitials;
  final String senderPhone;
  final String? senderAvatar;
  final String receiverName;
  final String receiverInitials;
  final String receiverPhone;
  final VoidCallback? onSenderCall;
  final VoidCallback? onReceiverCall;
  final bool showCallButtons;
  final bool useCircleCallButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          // Sender Info
          _buildContactRow(
            name: senderName,
            initials: senderInitials,
            role: "Sender",
            phone: senderPhone,
            avatarUrl: senderAvatar,
            avatarBgColor: AppColors.primaryColor.withOpacity(0.1),
            initialsColor: AppColors.primaryColor,
            onCall: onSenderCall ?? () => makePhoneCall(senderPhone),
          ),
          SizedBox(height: 16.h),
          const Divider(height: 1, color: AppColors.backgroundColor),
          SizedBox(height: 16.h),

          // Receiver Info
          _buildContactRow(
            name: receiverName,
            initials: receiverInitials,
            role: "Receiver",
            phone: receiverPhone,
            avatarBgColor: AppColors.secondaryColor.withOpacity(0.1),
            initialsColor: AppColors.secondaryColor,
            onCall: onReceiverCall ?? () => makePhoneCall(receiverPhone),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow({
    required String name,
    required String initials,
    required String role,
    required String phone,
    String? avatarUrl,
    required Color avatarBgColor,
    required Color initialsColor,
    required VoidCallback onCall,
  }) {
    final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;

    return Row(
      children: [
        CircleAvatar(
          radius: 24.r,
          backgroundColor: avatarBgColor,
          backgroundImage: hasAvatar ? CachedNetworkImageProvider(avatarUrl) : null,
          child: !hasAvatar
              ? customText(
                  initials.isNotEmpty ? initials : "?",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: initialsColor,
                )
              : null,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customText(
                name,
                color: AppColors.blackColor,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 2.h),
              customText(
                role,
                color: AppColors.obscureTextColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
        if (showCallButtons)
          InkWell(
            onTap: onCall,
            child: useCircleCallButton
                ? Container(
                    padding: EdgeInsets.all(10.sp),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      SvgAssets.callIcon,
                      height: 18.sp,
                      width: 18.sp,
                      colorFilter: const ColorFilter.mode(
                        AppColors.whiteColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  )
                : SvgPicture.asset(
                    SvgAssets.callIcon,
                    height: 18.sp,
                    width: 18.sp,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
          ),
      ],
    );
  }
}
