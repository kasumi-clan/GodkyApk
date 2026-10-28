#!/data/data/com.termux/files/usr/bin/bash
set -e

echo "===================================================="
echo "  GODLY CAMERA AI - TRÌNH ĐÓNG GÓI APK TỰ ĐỘNG      "
echo "===================================================="

pkg update -y
pkg install -y openjdk-17 gradle wget unzip aapt aapt2

if [ ! -d "$HOME/android-sdk/platforms/android-34" ]; then
    echo "[+] Đang tải Android SDK Platform 34..."
    mkdir -p $HOME/android-sdk/cmdline-tools
    cd $HOME/android-sdk/cmdline-tools
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O tools.zip
    unzip -q -o tools.zip
    rm -f tools.zip
    mv -f cmdline-tools latest 2>/dev/null || true
    yes | $HOME/android-sdk/cmdline-tools/latest/bin/sdkmanager --sdk_root=$HOME/android-sdk "platforms;android-34" "build-tools;34.0.0"
fi

export ANDROID_HOME=$HOME/android-sdk
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"
mkdir -p app/src/main/assets/models

echo "[+] Đang biên dịch GodlyCameraAI.apk (ARM64)..."
gradle assembleDebug -Pandroid.aapt2FromMavenOverride=$(which aapt2) --no-daemon

OUT_APK="app/build/outputs/apk/debug/app-debug.apk"
if [ -f "$OUT_APK" ]; then
    cp "$OUT_APK" /sdcard/Download/GodlyCameraAI.apk 2>/dev/null || true
    echo "===================================================="
    echo " THÀNH CÔNG! File APK đã sẵn sàng tại:"
    echo " -> $SCRIPT_DIR/$OUT_APK"
    echo " -> /sdcard/Download/GodlyCameraAI.apk"
    echo "===================================================="
fi
