# Xcode Archive Guide for GoRider

## The Problem
When archiving in Xcode, you're getting "Unable to find module dependency: FirebaseMessaging, GoogleMaps"

## The Solution

### Step 1: ALWAYS Open the Workspace (Not Project)
```bash
cd /Users/mac/Documents/apps/sharp-rider
open ios/Runner.xcworkspace
```

⚠️ **CRITICAL:** Do NOT open `Runner.xcodeproj` - you MUST use `Runner.xcworkspace`

### Step 2: Select the Correct Scheme
- At the top of Xcode, next to the Run/Stop buttons
- Click the scheme selector dropdown
- Select: **Runner** (NOT Firebase, FirebaseCore, or any other scheme)
- Device target: **Any iOS Device (arm64)**

### Step 3: Clean Build Folder
- Menu: **Product → Clean Build Folder** (or press ⇧⌘K)

### Step 4: Archive
- Menu: **Product → Archive**
- Wait for archive to complete (~1-2 minutes)

### Step 5: Distribute
- When Organizer opens, click **Distribute App**
- Choose distribution method:
  - **App Store Connect** - for production release
  - **Ad Hoc** - for testing on specific devices
  - **Development** - for your own devices

## Alternative: Use Flutter CLI (Recommended)

This is more reliable and handles all dependencies automatically:

```bash
# Clean first
flutter clean
cd ios && pod install && cd ..

# Build IPA (this already worked for you!)
flutter build ipa --release

# The IPA will be at:
# build/ios/ipa/Go-Rider.ipa
```

## Common Mistakes That Cause This Error

❌ Opening `Runner.xcodeproj` instead of `Runner.xcworkspace`
❌ Selecting wrong scheme (Firebase instead of Runner)
❌ Not cleaning build folder before archiving
❌ CocoaPods not installed properly

## Verify Everything is Correct

Check these in Xcode:
1. Runner scheme is selected (top toolbar)
2. You see "Pods" project in navigator (left sidebar)
3. Build Settings → Framework Search Paths includes `$(inherited)`

## If Still Failing

Close Xcode completely and run:
```bash
cd ios
rm -rf Pods Podfile.lock
pod install
open Runner.xcworkspace
```

Then follow steps 2-4 above.
