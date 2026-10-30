#!/usr/bin/env bash
# Собирает страницы политик из store/ приложений: ../garantia и ../domovoy.
# Исходник политики — в репозитории приложения; здесь только копия для GitHub Pages.
# После правки политики в приложении: ./sync.sh && git commit -am "..." && git push
set -euo pipefail
cd "$(dirname "$0")"

page() { # page <приложение> <язык> <путь страницы> <ссылка на другой язык>
  local app=$1 lang=$2 permalink=$3 other=$4
  local src="../$app/store/privacy-policy.$lang.md"
  local title
  title=$(head -1 "$src" | sed 's/^# //')
  mkdir -p "$app"
  {
    printf -- '---\nlayout: default\ntitle: "%s"\nlang: %s\npermalink: %s\n---\n\n' "$title" "$lang" "$permalink"
    printf '%s\n\n' "$other"
    cat "$src"
  } > "$app/$lang.md"
}

for app in garantia domovoy; do
  page "$app" ru "/$app/" "[English version](/privacy/$app/en/)"
  page "$app" en "/$app/en/" "[Версия на русском](/privacy/$app/)"
done
echo "Готово: garantia/{ru,en}.md, domovoy/{ru,en}.md"
