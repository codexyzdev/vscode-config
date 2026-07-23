#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_ROOT="$SCRIPT_DIR/.backups"

case "$(uname -s)" in
    Darwin)
        CODE_USER="$HOME/Library/Application Support/Code/User"
        ;;
    MINGW*|MSYS*|CYGWIN*)
        WIN_APPDATA="${APPDATA:-$HOME/AppData/Roaming}"
        if command -v cygpath >/dev/null 2>&1; then
            WIN_APPDATA="$(cygpath -u "$WIN_APPDATA")"
        fi
        CODE_USER="$WIN_APPDATA/Code/User"
        ;;
    *)
        CODE_USER="$HOME/.config/Code/User"
        ;;
esac

FORCE=0
TARGET=""

usage() {
    echo "Uso: $0 [opciones] [timestamp]"
    echo ""
    echo "Opciones:"
    echo "  -y, --yes    No pedir confirmación"
    echo "  -h, --help   Mostrar esta ayuda"
    echo ""
    echo "Si no se pasa timestamp, se usa el backup más reciente en .backups/."
    exit 0
}

for arg in "$@"; do
    case "$arg" in
        -y|--yes) FORCE=1 ;;
        -h|--help) usage ;;
        *) TARGET="$arg" ;;
    esac
done

if [[ ! -d "$BACKUP_ROOT" ]]; then
    echo -e "\033[31mError: No existe la carpeta $BACKUP_ROOT. Ejecutá setup.sh primero.\033[0m"
    exit 1
fi

if [[ -z "$TARGET" ]]; then
    TARGET="$(ls -1 "$BACKUP_ROOT" 2>/dev/null | sort | tail -1)"
    if [[ -z "$TARGET" ]]; then
        echo -e "\033[31mError: No hay backups en $BACKUP_ROOT.\033[0m"
        exit 1
    fi
    echo -e "\033[36mUsando el backup más reciente: $TARGET\033[0m"
fi

BACKUP_DIR="$BACKUP_ROOT/$TARGET"
if [[ ! -d "$BACKUP_DIR" ]]; then
    echo -e "\033[31mError: No existe el backup $BACKUP_DIR.\033[0m"
    exit 1
fi

echo ""
echo -e "\033[33mEsto va a restaurar tu config desde:\033[0m"
echo -e "\033[33m  $BACKUP_DIR\033[0m"
echo -e "\033[33m  a: $CODE_USER\033[0m"
echo ""

if [[ $FORCE -eq 0 ]]; then
    read -p "¿Continuar? [s/N] " ans
    case "$ans" in
        s|S|y|Y) ;;
        *) echo -e "\033[33mCancelado.\033[0m"; exit 0 ;;
    esac
fi

mkdir -p "$CODE_USER"

if [[ -f "$BACKUP_DIR/settings.json" ]]; then
    cp "$BACKUP_DIR/settings.json" "$CODE_USER/settings.json"
    echo -e "\033[32m[OK] settings.json\033[0m"
fi
if [[ -f "$BACKUP_DIR/keybindings.json" ]]; then
    cp "$BACKUP_DIR/keybindings.json" "$CODE_USER/keybindings.json"
    echo -e "\033[32m[OK] keybindings.json\033[0m"
fi
if [[ -d "$BACKUP_DIR/snippets" ]]; then
    rm -rf "$CODE_USER/snippets"
    cp -r "$BACKUP_DIR/snippets" "$CODE_USER/snippets"
    echo -e "\033[32m[OK] snippets/\033[0m"
fi

if [[ -f "$BACKUP_DIR/extensions.txt" ]]; then
    if ! command -v code >/dev/null 2>&1; then
        echo -e "\033[33m[SKIP] code no en PATH, no se restauran extensiones.\033[0m"
    else
        echo ""
        echo -e "\033[33mRestaurando extensiones...\033[0m"
        TMP_CURRENT="$(mktemp)"
        code --list-extensions > "$TMP_CURRENT" 2>/dev/null || true

        while IFS= read -r ext; do
            [[ -z "$ext" ]] && continue
            if ! grep -qxF "$ext" "$BACKUP_DIR/extensions.txt"; then
                printf "       uninstall %s ..." "$ext"
                code --uninstall-extension "$ext" >/dev/null 2>&1
                echo -e "\033[32m OK\033[0m"
            fi
        done < "$TMP_CURRENT"

        while IFS= read -r ext; do
            [[ -z "$ext" ]] && continue
            if ! grep -qxF "$ext" "$TMP_CURRENT"; then
                printf "       install   %s ..." "$ext"
                code --install-extension "$ext" --force >/dev/null 2>&1
                echo -e "\033[32m OK\033[0m"
            fi
        done < "$BACKUP_DIR/extensions.txt"

        rm -f "$TMP_CURRENT"
    fi
fi

echo ""
echo -e "\033[36m=== Restauración completada ===\033[0m"
