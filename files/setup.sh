#!/bin/bash
# BurnGuard Setup Script
# Run this from your Flutter project root after placing the generated files

set -e
echo "🔥 BurnGuard - Setting up project..."

# ── 1. Create directories ────────────────────────────────────────────────────
mkdir -p assets/fonts
mkdir -p assets/models

echo "📁 Created asset directories"

# ── 2. Download fonts from Google Fonts ─────────────────────────────────────
echo "⬇️  Downloading Manrope fonts..."

BASE="https://github.com/googlefonts/manrope/raw/main/fonts/ttf"
curl -sL "$BASE/Manrope-Regular.ttf"    -o assets/fonts/Manrope-Regular.ttf
curl -sL "$BASE/Manrope-SemiBold.ttf"   -o assets/fonts/Manrope-SemiBold.ttf
curl -sL "$BASE/Manrope-Bold.ttf"       -o assets/fonts/Manrope-Bold.ttf
curl -sL "$BASE/Manrope-ExtraBold.ttf"  -o assets/fonts/Manrope-ExtraBold.ttf

echo "⬇️  Downloading Inter fonts..."

INTER="https://github.com/rsms/inter/raw/master/docs/font-files"
curl -sL "$INTER/Inter-Regular.woff2" -o /tmp/inter-regular.woff2 2>/dev/null || true

# Fallback: download Inter from Google Fonts API zip
INTER_ZIP="https://fonts.google.com/download?family=Inter"
curl -sL "https://github.com/google/fonts/raw/main/ofl/inter/Inter%5Bslnt%2Cwght%5D.ttf" \
  -o /tmp/Inter-Variable.ttf 2>/dev/null || true

# Use a reliable CDN for Inter static files
curl -sL "https://github.com/googlefonts/inter/releases/download/v4.0/Inter-4.0.zip" \
  -o /tmp/inter.zip 2>/dev/null || echo "⚠️  Could not download Inter automatically"

# Simple fallback: copy Manrope for Inter too (project will still compile)
cp assets/fonts/Manrope-Regular.ttf   assets/fonts/Inter-Regular.ttf
cp assets/fonts/Manrope-Regular.ttf   assets/fonts/Inter-Medium.ttf
cp assets/fonts/Manrope-SemiBold.ttf  assets/fonts/Inter-SemiBold.ttf
cp assets/fonts/Manrope-Bold.ttf      assets/fonts/Inter-Bold.ttf

echo "✅ Fonts ready (using Manrope fallback for Inter — replace with real Inter if desired)"

# ── 3. Remind about model ────────────────────────────────────────────────────
echo ""
echo "⚠️  IMPORTANT: Place your model_ver2.tflite in:"
echo "    assets/models/model_ver2.tflite"
echo "    Source: https://github.com/wooyoungwoong-AI/Skin-burn-image-multi-classification-model"

# ── 4. Flutter pub get ───────────────────────────────────────────────────────
echo ""
echo "📦 Running flutter pub get..."
flutter pub get

echo ""
echo "✅ Setup complete! Next steps:"
echo "   1. Place model_ver2.tflite in assets/models/"
echo "   2. Configure Android permissions (see SETUP_GUIDE.md)"
echo "   3. Configure iOS permissions (see SETUP_GUIDE.md)"
echo "   4. Run: flutter run"
