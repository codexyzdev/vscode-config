#!/bin/bash
set -e

CODE_USER="$HOME/.config/Code/User"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo -e "\033[36m=== VS Code Config Setup ===\033[0m"
echo ""

echo -e "\033[33m[1/3] Instalando fuentes Fira Code...\033[0m"
case "$(uname -s)" in
    Darwin)  FONT_DIR="$HOME/Library/Fonts" ;;
    Linux)   FONT_DIR="$HOME/.local/share/fonts" ;;
    MINGW*|MSYS*) FONT_DIR="$LOCALAPPDATA/Microsoft/Windows/Fonts" ;;
esac
mkdir -p "$FONT_DIR"
cp "$SCRIPT_DIR/fire code font/ttf/"*.ttf "$FONT_DIR/" 2>/dev/null
if command -v fc-cache >/dev/null 2>&1; then fc-cache -f "$FONT_DIR"; fi
echo -e "\033[32m       Listo.\033[0m"

echo ""
echo -e "\033[33m[2/3] Copiando settings.json...\033[0m"
mkdir -p "$CODE_USER"
cp "$SCRIPT_DIR/settings.json" "$CODE_USER/settings.json"
echo -e "\033[32m       Listo.\033[0m"

echo ""
echo -e "\033[33m[3/3] Instalando extensiones...\033[0m"
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
