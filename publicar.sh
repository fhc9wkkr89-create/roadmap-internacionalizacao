#!/bin/zsh
# Publica o tasks.json no GitHub Pages (só se mudou) e confere o link.
cd "$(dirname "$0")" || exit 1
python3 -c "import json;json.load(open('tasks.json'))" || { echo "tasks.json inválido"; exit 1; }
if git diff --quiet -- tasks.json index.html; then echo "sem mudanças"; exit 0; fi
git add tasks.json index.html
git commit -qm "Sincroniza roadmap com o ClickUp ($(date +%d/%m\ %H:%M))

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
git push -q origin main || { echo "push falhou"; exit 1; }
for i in {1..30}; do
  live=$(curl -s "https://fhc9wkkr89-create.github.io/roadmap-internacionalizacao/tasks.json?v=$RANDOM")
  [ "$live" = "$(cat tasks.json)" ] && { echo "publicado e conferido"; exit 0; }
  sleep 20
done
echo "push feito, mas o link ainda não refletiu (cache do Pages)"
