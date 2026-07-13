#!/bin/bash
set -e

CODE_USER="$HOME/.config/Code/User"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo -e "\033[36m=== VS Code Config Setup ===\033[0m"
echo ""

echo -e "\033[33m[1/2] Copiando settings.json...\033[0m"
mkdir -p "$CODE_USER"
cp "$SCRIPT_DIR/settings.json" "$CODE_USER/settings.json"
echo -e "\033[32m       Listo.\033[0m"

echo ""
echo -e "\033[33m[2/2] Instalando extensiones...\033[0m"
while IFS= read -r ext; do
    ext=$(echo "$ext" | xargs)
    if [[ -n "$ext" && "$ext" != \#* ]]; then
        printf "       %s ..." "$ext"
        code --install-extension "$ext" --force >/dev/null 2>&1
        echo -e "\033[32m OK\033[0m"
    fi
done < "$SCRIPT_DIR/extensions.txt"

echo ""
echo -e "\033[36m=== Setup completado ===\033[0m"
