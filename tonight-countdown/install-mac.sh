#!/bin/bash
# 安装 / 更新「今晚安排倒计时.app」
# 网页放在纯英文路径 ~/Library/TonightCountdown/index.html（Chrome 打开中文 file 路径会白屏）
# 旧版本挪到同目录的「旧版备份」文件夹。
set -e
APP="$HOME/Documents/Codex/2026-10-30/mac-19-30-21-00/outputs/今晚安排倒计时.app"
URL="https://raw.githubusercontent.com/jolyneumich/-/claude/adoring-darwin-iz6zp3/tonight-countdown/tonight.html?v=$(date +%s)"
DATA_DIR="$HOME/Library/TonightCountdown"
mkdir -p "$DATA_DIR"
curl -fsSL "$URL" -o "$DATA_DIR/index.html.new"
mv "$DATA_DIR/index.html.new" "$DATA_DIR/index.html"
echo "网页已下载：$DATA_DIR/index.html"

mkdir -p "$(dirname "$APP")"
if [ -e "$APP" ]; then
  BK="$(dirname "$APP")/旧版备份"
  mkdir -p "$BK"
  mv "$APP" "$BK/今晚安排倒计时-$(date +%Y%m%d-%H%M%S).app"
  echo "旧版本已挪到：$BK"
fi
mkdir -p "$APP/Contents/MacOS"
cat > "$APP/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleExecutable</key><string>run</string>
<key>CFBundleIdentifier</key><string>local.tonight.countdown</string>
<key>CFBundleName</key><string>今晚安排倒计时</string>
<key>CFBundlePackageType</key><string>APPL</string>
<key>CFBundleShortVersionString</key><string>2.1</string>
</dict></plist>
PLIST
cat > "$APP/Contents/MacOS/run" <<'RUN'
#!/bin/bash
HTML="$HOME/Library/TonightCountdown/index.html"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
if [ -x "$CHROME" ]; then
  nohup "$CHROME" --app="file://$HTML" --window-size=1200,860 >/dev/null 2>&1 &
else
  open "$HTML"
fi
RUN
chmod +x "$APP/Contents/MacOS/run"
touch "$APP"
echo "装好了：$APP"
"$APP/Contents/MacOS/run"
