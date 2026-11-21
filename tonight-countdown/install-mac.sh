#!/bin/bash
# 安装 / 更新「今晚安排倒计时.app」：旧版本挪到同目录的「旧版备份」文件夹，再装新版本。
set -e
APP="$HOME/Documents/Codex/2026-10-30/mac-19-30-21-00/outputs/今晚安排倒计时.app"
URL="https://raw.githubusercontent.com/jolyneumich/-/claude/adoring-darwin-iz6zp3/tonight-countdown/tonight.html"
TMP="$(mktemp)"
curl -fsSL "$URL" -o "$TMP"
mkdir -p "$(dirname "$APP")"
if [ -e "$APP" ]; then
  BK="$(dirname "$APP")/旧版备份"
  mkdir -p "$BK"
  mv "$APP" "$BK/今晚安排倒计时-$(date +%Y%m%d-%H%M%S).app"
  echo "旧版本已挪到：$BK"
fi
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
mv "$TMP" "$APP/Contents/Resources/index.html"
cat > "$APP/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleExecutable</key><string>run</string>
<key>CFBundleIdentifier</key><string>local.tonight.countdown</string>
<key>CFBundleName</key><string>今晚安排倒计时</string>
<key>CFBundlePackageType</key><string>APPL</string>
<key>CFBundleShortVersionString</key><string>2.0</string>
</dict></plist>
PLIST
cat > "$APP/Contents/MacOS/run" <<'RUN'
#!/bin/bash
HTML="$(cd "$(dirname "$0")/../Resources" && pwd)/index.html"
if [ -d "/Applications/Google Chrome.app" ]; then
  open -na "Google Chrome" --args --app="file://$HTML" --window-size=1200,860 || open "$HTML"
else
  open "$HTML"
fi
RUN
chmod +x "$APP/Contents/MacOS/run"
touch "$APP"
echo "装好了：$APP"
open "$APP" 2>/dev/null || open "$APP/Contents/Resources/index.html"
