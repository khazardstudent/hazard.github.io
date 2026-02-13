#!/usr/bin/env bash
set -euo pipefail

repo_root="${1:-maven}"

if [[ ! -d "$repo_root" ]]; then
  echo "Repository directory '$repo_root' does not exist."
  exit 1
fi

generate_index() {
  local dir="$1"
  local title="/${dir#./}/"

  {
    echo '<!doctype html>'
    echo '<html lang="en">'
    echo '<head>'
    echo '  <meta charset="utf-8">'
    echo '  <meta name="viewport" content="width=device-width, initial-scale=1">'
    echo "  <title>Index of ${title}</title>"
    echo '  <style>'
    echo '    body { font-family: Arial, sans-serif; max-width: 900px; margin: 2rem auto; padding: 0 1rem; }'
    echo '    ul { list-style: none; padding: 0; }'
    echo '    li { margin: 0.35rem 0; }'
    echo '    a { text-decoration: none; }'
    echo '    a:hover { text-decoration: underline; }'
    echo '  </style>'
    echo '</head>'
    echo '<body>'
    echo "  <h1>Index of ${title}</h1>"
    echo '  <ul>'

    if [[ "$dir" != "$repo_root" ]]; then
      echo '    <li><a href="../">../</a></li>'
    fi

    while IFS= read -r entry; do
      [[ -z "$entry" ]] && continue
      [[ "$entry" == "index.html" ]] && continue
      local full_path="$dir/$entry"

      if [[ -d "$full_path" ]]; then
        printf '    <li><a href="%s/">%s/</a></li>\n' "$entry" "$entry"
      else
        printf '    <li><a href="%s">%s</a></li>\n' "$entry" "$entry"
      fi
    done < <(find "$dir" -mindepth 1 -maxdepth 1 -printf '%f\n' | LC_ALL=C sort)

    echo '  </ul>'
    echo '</body>'
    echo '</html>'
  } > "$dir/index.html"
}

while IFS= read -r directory; do
  generate_index "$directory"
done < <(find "$repo_root" -type d | LC_ALL=C sort)

echo "Generated index files under '$repo_root'."
