#!/bin/sh
# 把 index.html（片段）包成可以直接打开的完整网页：今晚倒计时.html 和 tonight.html（同一份）
cd "$(dirname "$0")"
{
  printf '<!doctype html>\n<html lang="zh-CN">\n<head>\n<meta charset="utf-8">\n<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">\n'
  sed -n '1,/<\/style>/p' index.html
  printf '</head>\n<body>\n'
  sed -n '/<\/style>/,$p' index.html | tail -n +2
  printf '</body>\n</html>\n'
} > tonight.html
cp tonight.html 今晚倒计时.html
