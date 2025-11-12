import 'package:gorider/core/utils/exports.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoScaleController;
  late AnimationController _logoFadeController;
  late AnimationController _textSlideController;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    // Logo scale animation - bouncy entrance
    _logoScaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _logoScaleAnimation = CurvedAnimation(
      parent: _logoScaleController,
      curve: Curves.elasticOut,
    );

    // Logo fade animation
    _logoFadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _logoFadeAnimation = CurvedAnimation(
      parent: _logoFadeController,
      curve: Curves.easeIn,
    );

    // Text slide animation - slides up from bottom
    _textSlideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textSlideController,
      curve: Curves.easeOutCubic,
    ));

    // Pulse animation - continuous subtle pulse
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Shimmer effect for background
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    _shimmerAnimation = CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.linear,
    );
  }

  void _startAnimations() {
    // Start logo animations
    _logoFadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _logoScaleController.forward();
    });

    // Start text animation after logo
    Future.delayed(const Duration(milliseconds: 600), () {
      _textSlideController.forward();
    });

    // Start continuous pulse after initial animations
    Future.delayed(const Duration(milliseconds: 1500), () {
      _pulseController.repeat(reverse: true);
    });

    // Start shimmer effect
    _shimmerController.repeat();
  }

  @override
  void dispose() {
    _logoScaleController.dispose();
    _logoFadeController.dispose();
    _textSlideController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      builder: (splashController) {
        return Scaffold(
          backgroundColor: AppColors.fadedPrimaryColor,
          appBar: flatAppBar(
            bgColor: AppColors.fadedPrimaryColor,
            navigationColor: AppColors.fadedPrimaryColor,
          ),
          body: Stack(
            children: [
              // Animated shimmer background
              AnimatedBuilder(
                animation: _shimmerAnimation,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.fadedPrimaryColor,
                          AppColors.fadedPrimaryColor.withOpacity(0.8),
                          AppColors.fadedPrimaryColor,
                        ],
                        stops: [
                          _shimmerAnimation.value - 0.3,
                          _shimmerAnimation.value,
                          _shimmerAnimation.value + 0.3,
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Watermark background
              Positioned.fill(
                child: Opacity(
                  opacity: 0.15,
                  child: Image.asset(
                    PngAssets.lightWatermark,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Main content
              SizedBox(
                height: 1.sh,
                width: 1.sw,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),

                    // Animated logo with scale, fade, and pulse
                    FadeTransition(
                      opacity: _logoFadeAnimation,
                      child: ScaleTransition(
                        scale: _logoScaleAnimation,
                        child: AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _pulseAnimation.value,
                              child: Container(
                                padding: EdgeInsets.all(30.sp),
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryColor
                                          .withOpacity(0.3),
                                      blurRadius: 40,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(20.sp),
                                  decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primaryColor
                                            .withOpacity(0.2),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Image.asset(
                                    PngAssets.goSharpSharpTextLogo,
                                    height: 120.sp,
                                    width: 120.sp,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: 40.h),

                    // Animated text - slides up
                    SlideTransition(
                      position: _textSlideAnimation,
                      child: FadeTransition(
                        opacity: _textSlideController,
                        child: Column(
                          children: [
                            customText(
                              'GoSharpSharp',
                              fontSize: 32.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.whiteColor,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8.h),
                            customText(
                              'Rider',
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.whiteColor.withOpacity(0.9),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(flex: 2),

                    // Loading indicator with fade
                    FadeTransition(
                      opacity: _textSlideController,
                      child: Column(
                        children: [
                          Lottie.asset(
                            'assets/json/loading.json',
                            width: 50.sp,
                            height: 50.sp,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(height: 12.h),
                          customText(
                            'Loading...',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.whiteColor.withOpacity(0.8),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 60.h),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
