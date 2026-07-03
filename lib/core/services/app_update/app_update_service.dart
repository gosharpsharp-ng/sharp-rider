import 'dart:developer';
import 'dart:io';
import 'package:gorider/core/utils/exports.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateService {
  static final AppUpdateService _instance = AppUpdateService._internal();
  factory AppUpdateService() => _instance;
  AppUpdateService._internal();

  bool _isDialogShowing = false;

  static const String _playStoreId = 'com.gosharpsharp.rider';
  static const String _appStoreId = '6744299798';

  Future<void> initialize() async {
    await checkForUpdate();
  }

  Future<void> checkForUpdate() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final installedVersion = packageInfo.version;

      final upgrader = Upgrader(
        storeController: UpgraderStoreController(
          onAndroid: () => UpgraderPlayStore(),
          oniOS: () => UpgraderAppStore(),
        ),
      );

      await upgrader.initialize();

      final storeVersion = upgrader.currentAppStoreVersion ?? '';

      log('Installed version: $installedVersion');
      log('Store version: $storeVersion');

      if (storeVersion.isEmpty) {
        log('Could not fetch store version — skipping update check');
        return;
      }

      final updateAvailable = _isStoreVersionNewer(storeVersion, installedVersion);

      if (!updateAvailable) {
        log('App is up to date ($installedVersion)');
        return;
      }

      if (upgrader.belowMinAppVersion()) {
        log('Force update required — below minimum version');
        _showUpdateDialog(
          latestVersion: storeVersion,
          isForceUpdate: true,
          releaseNotes: upgrader.releaseNotes,
        );
      } else {
        log('New version available: $storeVersion');
        _showUpdateDialog(
          latestVersion: storeVersion,
          isForceUpdate: false,
          releaseNotes: upgrader.releaseNotes,
        );
      }
    } catch (e) {
      log('Error checking for updates: $e');
    }
  }

  bool _isStoreVersionNewer(String storeVersion, String installedVersion) {
    try {
      final store = storeVersion.trim().split('.').map(int.parse).toList();
      final installed = installedVersion.trim().split('.').map(int.parse).toList();

      while (store.length < installed.length) store.add(0);
      while (installed.length < store.length) installed.add(0);

      for (int i = 0; i < store.length; i++) {
        if (store[i] > installed[i]) return true;
        if (store[i] < installed[i]) return false;
      }
      return false;
    } catch (e) {
      log('Version parse error — skipping update check: $e');
      return false;
    }
  }

  void _showUpdateDialog({
    required String latestVersion,
    required bool isForceUpdate,
    String? releaseNotes,
  }) {
    if (_isDialogShowing) return;
    _isDialogShowing = true;

    Get.dialog(
      PopScope(
        canPop: !isForceUpdate,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // App icon
                CircleAvatar(
                  radius: 32.sp,
                  backgroundImage: const AssetImage(PngAssets.goSharpSharpIcon),
                ),
                SizedBox(height: 20.h),

                // Title
                customText(
                  'New update available',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blackColor,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 6.h),

                // Version line
                customText(
                  'Version $latestVersion is ready to install.',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.greyColor,
                  textAlign: TextAlign.center,
                ),

                // Release notes
                if (releaseNotes != null && releaseNotes.isNotEmpty) ...[
                  SizedBox(height: 16.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: customText(
                      "What's new",
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: customText(
                      releaseNotes,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.greyColor,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],

                SizedBox(height: 24.h),

                // Primary action
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _openStore,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      elevation: 0,
                    ),
                    child: customText(
                      'Update',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),

                if (!isForceUpdate) ...[
                  SizedBox(height: 4.h),
                  TextButton(
                    onPressed: () {
                      _isDialogShowing = false;
                      Get.back();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.greyColor,
                    ),
                    child: customText(
                      'Not now',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.greyColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: !isForceUpdate,
      barrierColor: Colors.black.withValues(alpha: 0.4),
    ).then((_) {
      if (!isForceUpdate) {
        _isDialogShowing = false;
      }
    });
  }

  Future<void> _openStore() async {
    final Uri storeUrl;

    if (Platform.isAndroid) {
      storeUrl = Uri.parse('market://details?id=$_playStoreId');
    } else {
      storeUrl = Uri.parse('https://apps.apple.com/app/id$_appStoreId');
    }

    try {
      if (await canLaunchUrl(storeUrl)) {
        await launchUrl(storeUrl, mode: LaunchMode.externalApplication);
      } else {
        final webUrl = Platform.isAndroid
            ? Uri.parse('https://play.google.com/store/apps/details?id=$_playStoreId')
            : Uri.parse('https://apps.apple.com/app/id$_appStoreId');
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      log('Error opening store: $e');
      showToast(message: 'Could not open store', isError: true);
    }
  }

  void showUpdateDialogForTesting() {
    _showUpdateDialog(
      latestVersion: '2.0.0',
      isForceUpdate: false,
      releaseNotes: '• Improved delivery tracking\n• Bug fixes and performance improvements\n• Better navigation experience',
    );
  }
}
