#!/bin/bash
set -e

CODE_USER="$HOME/.config/Code/User"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_ROOT="$SCRIPT_DIR/.backups"

SKIP_CONFIRM=0
for arg in "$@"; do
    case "$arg" in
        -y|--yes) SKIP_CONFIRM=1 ;;
    esac
done

echo -e "\033[36m=== VS Code Config Setup ===\033[0m"
echo ""

EXT_COUNT=$(grep -cv -E '^\s*(#|$)' "$SCRIPT_DIR/extensions.txt" 2>/dev/null || echo "0")
echo -e "\033[33mEsto va a:\033[0m"
echo -e "\033[33m  - Respaldar tu config actual en .backups/<timestamp>/ (si existe)\033[0m"
echo -e "\033[33m  - Instalar la fuente Fira Code\033[0m"
echo -e "\033[33m  - Copiar settings.json a $CODE_USER\033[0m"
echo -e "\033[33m  - Instalar $EXT_COUNT extensiones de extensions.txt\033[0m"
echo ""

if [[ $SKIP_CONFIRM -eq 0 ]]; then
    read -p "¿Continuar? [s/N] " ans
    case "$ans" in
        s|S|y|Y) ;;
        *) echo -e "\033[33mCancelado.\033[0m"; exit 0 ;;
    esac
fi

echo ""
echo -e "\033[33m[1/4] Respaldando config previa...\033[0m"
TIMESTAMP="$(date +%Y-%m-%d_%H%M%S)"
BACKUP_DIR="$BACKUP_ROOT/$TIMESTAMP"
mkdir -p "$BACKUP_DIR"

HAS_BACKUP=0
if [[ -f "$CODE_USER/settings.json" ]]; then
    cp "$CODE_USER/settings.json" "$BACKUP_DIR/settings.json"
    HAS_BACKUP=1
fi
if [[ -f "$CODE_USER/keybindings.json" ]]; then
    cp "$CODE_USER/keybindings.json" "$BACKUP_DIR/keybindings.json"
    HAS_BACKUP=1
fi
if [[ -d "$CODE_USER/snippets" ]]; then
    cp -r "$CODE_USER/snippets" "$BACKUP_DIR/snippets"
    HAS_BACKUP=1
fi
if command -v code >/dev/null 2>&1; then
    code --list-extensions > "$BACKUP_DIR/extensions.txt" 2>/dev/null || true
    HAS_BACKUP=1
else
    echo -e "\033[33m       (code no en PATH, lista de extensiones omitida)\033[0m"
fi

if [[ $HAS_BACKUP -eq 1 ]]; then
    echo -e "\033[32m       Backup en: $BACKUP_DIR\033[0m"
else
    echo -e "\033[33m       Sin config previa, salto backup.\033[0m"
    rmdir "$BACKUP_DIR" 2>/dev/null || true
fi

echo ""
echo -e "\033[33m[2/4] Instalando fuentes Fira Code...\033[0m"
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
echo -e "\033[33m[3/4] Copiando settings.json...\033[0m"
mkdir -p "$CODE_USER"
cp "$SCRIPT_DIR/settings.json" "$CODE_USER/settings.json"
echo -e "\033[32m       Listo.\033[0m"

echo ""
echo -e "\033[33m[4/4] Instalando extensiones...\033[0m"
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
