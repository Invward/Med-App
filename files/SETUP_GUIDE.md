# BurnGuard — Platform Setup Guide

## 1. Android Configuration

### `android/app/src/main/AndroidManifest.xml`
Add inside `<manifest>`:
```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.INTERNET"/>
<uses-feature android:name="android.hardware.camera" android:required="false"/>
```

### `android/app/build.gradle`
```groovy
android {
    compileSdkVersion 34
    defaultConfig {
        minSdkVersion 21        // Required by camera package
        targetSdkVersion 34
    }
    aaptOptions {
        noCompress "tflite"     // Required by tflite_flutter
    }
}
```

### `android/gradle.properties`
```properties
android.useAndroidX=true
android.enableJetifier=true
```

---

## 2. iOS Configuration

### `ios/Runner/Info.plist`
Add inside `<dict>`:
```xml
<key>NSCameraUsageDescription</key>
<string>BurnGuard needs camera access to photograph burn wounds for AI assessment.</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>BurnGuard needs photo library access to select burn images for analysis.</string>

<key>NSPhotoLibraryAddUsageDescription</key>
<string>BurnGuard saves assessment images to your photo library.</string>
```

### `ios/Podfile`
Add at top:
```ruby
platform :ios, '12.0'
```

---

## 3. Assets Setup

### Font Files Required
Download from Google Fonts or use the setup.sh script:

**Manrope** (https://fonts.google.com/specimen/Manrope):
- `assets/fonts/Manrope-Regular.ttf`
- `assets/fonts/Manrope-SemiBold.ttf`
- `assets/fonts/Manrope-Bold.ttf`
- `assets/fonts/Manrope-ExtraBold.ttf`

**Inter** (https://fonts.google.com/specimen/Inter):
- `assets/fonts/Inter-Regular.ttf`
- `assets/fonts/Inter-Medium.ttf`
- `assets/fonts/Inter-SemiBold.ttf`
- `assets/fonts/Inter-Bold.ttf`

### TFLite Model
Place your model at:
```
assets/models/model_ver2.tflite
```
Source: https://github.com/wooyoungwoong-AI/Skin-burn-image-multi-classification-model

---

## 4. Project Structure

```
lib/
├── main.dart
├── core/
│   ├── theme/
│   │   └── app_theme.dart          ← Colors, typography, radius tokens
│   ├── router/
│   │   └── app_router.dart         ← GoRouter configuration
│   └── providers/
│       └── app_providers.dart      ← Riverpod providers
├── features/
│   ├── detection/
│   │   └── model_service.dart      ← TFLite inference engine
│   ├── onboarding/screens/
│   │   └── onboarding_screen.dart  ← 3-slide onboarding + disclaimer
│   ├── home/screens/
│   │   └── home_screen.dart        ← Dashboard
│   ├── camera/screens/
│   │   ├── camera_screen.dart      ← Live camera + guidelines
│   │   └── photo_preview_screen.dart
│   ├── results/screens/
│   │   └── results_screen.dart     ← Analysis results + severity badge
│   ├── firstaid/screens/
│   │   └── first_aid_screen.dart   ← Step-by-step first aid
│   ├── medical/screens/
│   │   └── medical_advice_screen.dart
│   ├── emergency/screens/
│   │   └── emergency_screen.dart   ← 911 + Medical ID
│   ├── history/screens/
│   │   └── history_screen.dart     ← Scan history + insights
│   └── settings/screens/
│       └── settings_screen.dart    ← Disclaimer + settings + about
└── shared/
    └── widgets/
        ├── main_scaffold.dart           ← Shell with bottom nav
        ├── burn_guard_app_bar.dart
        ├── medical_disclaimer_banner.dart
        ├── severity_badge.dart
        └── gradient_button.dart
```

---

## 5. Model Input/Output Format

The `ModelService` assumes:

| Property | Value |
|----------|-------|
| Input shape | `[1, 224, 224, 3]` |
| Input type | `float32`, normalized to [0, 1] |
| Output shape | `[1, 4]` |
| Output type | `float32` (softmax probabilities) |
| Classes | Normal Skin, 1st Degree, 2nd Degree, 3rd Degree |

If your model uses a different input size (e.g., 256×256), update `ModelService.inputSize`.

If output is logits (not softmax), apply softmax before argmax — add this to `runInference()`:
```dart
// After interpreter.run():
final sum = scores.reduce((a, b) => a + b);
final softmax = scores.map((s) => s / sum).toList();
```

---

## 6. Running the App

```bash
# Install dependencies
flutter pub get

# Run on Android
flutter run -d android

# Run on iOS
cd ios && pod install && cd ..
flutter run -d ios

# Build release APK
flutter build apk --release

# Build release iOS
flutter build ios --release
```

---

## 7. Troubleshooting

**TFLite model fails to load:**
- Ensure `assets/models/model_ver2.tflite` exists
- Check `pubspec.yaml` assets section includes the model path
- Add `noCompress "tflite"` to `android/app/build.gradle`

**Camera not working on Android:**
- Ensure `minSdkVersion 21` in build.gradle
- Grant camera permission on device

**Fonts not showing:**
- Verify all 8 font files exist in `assets/fonts/`
- Run `flutter pub get` after adding fonts

**Model inference crashes:**
- Check your model's actual input shape using `_interpreter.getInputTensor(0).shape`
- Adjust `ModelService.inputSize` accordingly
