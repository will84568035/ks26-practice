#!/usr/bin/env bash
# 用法：bash verify.sh
# 全部 ok 回傳 0；有任何 bad 回傳 1

FAIL=0
ok()  { echo "  ok   $1"; }
bad() { echo "  BAD  $1"; FAIL=1; }

echo "== C01 index.html 存在且有標題 =="
if [ -f index.html ] && grep -qiE '<title>[^<]+</title>' index.html; then
  ok "C01"
else
  bad "C01 根目錄需有 index.html，且 <title> 不可空白"
fi

echo "== C02 網頁檔沒有帳密字樣 =="
WEBFILES=$(ls *.html *.css *.js 2>/dev/null)
if [ -n "$WEBFILES" ] && grep -qiE 'password|passwd|token|secret|api[_-]?key' $WEBFILES; then
  bad "C02 網頁檔出現 password／token／secret／api_key 字樣"
else
  ok "C02"
fi

echo "== C03 README 有負責人署名 =="
if [ -f README.md ] && grep -qE '^負責人：.+' README.md && ! grep -q '請填' README.md; then
  ok "C03"
else
  bad "C03 README.md 需有「負責人：姓名」，且不可保留「請填」"
fi

echo "== C04 頁面有「主日」 =="
if [ -f index.html ] && grep -q '主日' index.html; then
  ok "C04"
else
  bad "C04 index.html 需出現「主日」二字"
fi

echo
if [ "$FAIL" -eq 0 ]; then echo "全部通過"; else echo "有檢查未通過"; fi
exit $FAIL
