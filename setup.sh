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

if [[ ! -t 1 ]]; then
    C_CYAN=""; C_YELLOW=""; C_GREEN=""; C_RED=""; C_RESET=""
else
    C_CYAN=$'\033[36m'; C_YELLOW=$'\033[33m'; C_GREEN=$'\033[32m'; C_RED=$'\033[31m'; C_RESET=$'\033[0m'
fi

echo -e "${C_CYAN}=== VS Code Config Setup ===${C_RESET}"
echo ""

if ! command -v code >/dev/null 2>&1; then
    echo -e "${C_RED}✗ VS Code no detectado${C_RESET}" >&2
    echo "" >&2
    echo "  Para que 'code' funcione en la terminal:" >&2
    echo "  1. Abrí VS Code" >&2
    echo "  2. View > Command Palette > 'Shell Command: Install 'code' command in PATH'" >&2
    echo "  3. Reiniciá la terminal y volvé a correr el setup" >&2
    exit 1
fi

EXT_COUNT=0
if [[ -f "$SCRIPT_DIR/extensions.txt" ]]; then
    EXT_COUNT=$(grep -cv -E '^\s*(#|$)' "$SCRIPT_DIR/extensions.txt" 2>/dev/null || echo "0")
fi
HAS_KEYBINDINGS=0
[[ -f "$SCRIPT_DIR/keybindings.json" ]] && HAS_KEYBINDINGS=1
HAS_SNIPPETS=0
[[ -d "$SCRIPT_DIR/snippets" ]] && HAS_SNIPPETS=1

echo -e "${C_YELLOW}Esto va a:${C_RESET}"
echo -e "${C_YELLOW}  - Respaldar tu config actual en .backups/<timestamp>/ (si existe)${C_RESET}"
echo -e "${C_YELLOW}  - Instalar $EXT_COUNT extensiones desde extensions.txt${C_RESET}"
echo -e "${C_YELLOW}  - Instalar la fuente Fira Code${C_RESET}"
echo -e "${C_YELLOW}  - Copiar settings.json a $CODE_USER${C_RESET}"
[[ $HAS_KEYBINDINGS -eq 1 ]] && echo -e "${C_YELLOW}  - Copiar keybindings.json${C_RESET}"
[[ $HAS_SNIPPETS -eq 1 ]] && echo -e "${C_YELLOW}  - Copiar snippets/${C_RESET}"
echo ""

if [[ $SKIP_CONFIRM -eq 0 ]]; then
    read -p "¿Continuar? [s/N] " ans
    case "$ans" in
        s|S|y|Y) ;;
        *) echo -e "${C_YELLOW}Cancelado.${C_RESET}"; exit 0 ;;
    esac
fi

echo ""
echo -e "${C_YELLOW}[1/4] Respaldando config previa...${C_RESET}"
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
EXT_LIST="$(code --list-extensions 2>/dev/null || true)"
if [[ -n "$EXT_LIST" ]]; then
    printf '%s\n' "$EXT_LIST" > "$BACKUP_DIR/extensions.txt"
    HAS_BACKUP=1
fi

if [[ $HAS_BACKUP -eq 1 ]]; then
    echo -e "${C_GREEN}       Backup en: $BACKUP_DIR${C_RESET}"
else
    echo -e "${C_YELLOW}       Sin config previa, salto backup.${C_RESET}"
    rmdir "$BACKUP_DIR" 2>/dev/null || true
fi

echo ""
echo -e "${C_YELLOW}[2/4] Instalando extensiones...${C_RESET}"
if [[ ! -f "$SCRIPT_DIR/extensions.txt" ]]; then
    echo -e "${C_YELLOW}       extensions.txt no encontrado, salto.${C_RESET}"
elif [[ $EXT_COUNT -eq 0 ]]; then
    echo -e "${C_YELLOW}       extensions.txt está vacío, salto.${C_RESET}"
else
    EXTENSIONS=()
    while IFS= read -r ext; do
        ext="${ext%$'\r'}"
        [[ -z "$ext" || "$ext" =~ ^[[:space:]]*# ]] && continue
        EXTENSIONS+=("$ext")
    done < "$SCRIPT_DIR/extensions.txt"
    TOTAL=${#EXTENSIONS[@]}
    BAR_WIDTH=20
    MAX_PARALLEL=4

    PROGRESS_DIR="$(mktemp -d)"
    trap 'rm -rf "$PROGRESS_DIR"' EXIT
    export PROGRESS_DIR

    printf '%s\n' "${EXTENSIONS[@]}" \
        | nl -w1 -s' ' \
        | xargs -P "$MAX_PARALLEL" -L 1 -I {} bash -c '
            line="{}"
            idx="${line%% *}"
            ext="${line#* }"
            if code --install-extension "$ext" --force >/dev/null 2>&1; then
                echo "OK" > "$PROGRESS_DIR/$idx.status"
            else
                echo "FAIL" > "$PROGRESS_DIR/$idx.status"
            fi
        ' &
    XARGS_PID=$!

    while kill -0 "$XARGS_PID" 2>/dev/null; do
        DONE=$(find "$PROGRESS_DIR" -maxdepth 1 -name '*.status' 2>/dev/null | wc -l)
        FILLED=$(( DONE * BAR_WIDTH / TOTAL ))
        [[ $FILLED -gt $BAR_WIDTH ]] && FILLED=$BAR_WIDTH
        EMPTY=$(( BAR_WIDTH - FILLED ))
        if [[ $FILLED -gt 0 ]]; then
            BAR_FILL=$(printf '#%.0s' $(seq 1 "$FILLED"))
        else
            BAR_FILL=""
        fi
        if [[ $EMPTY -gt 0 ]]; then
            BAR_EMPTY=$(printf '░%.0s' $(seq 1 "$EMPTY"))
        else
            BAR_EMPTY=""
        fi
        printf "\r[%-${BAR_WIDTH}s] %d/%d" "${BAR_FILL}${BAR_EMPTY}" "$DONE" "$TOTAL"
        sleep 0.2
    done
    wait "$XARGS_PID" 2>/dev/null || true

    BAR_FULL=$(printf '#%.0s' $(seq 1 "$BAR_WIDTH"))
    printf "\r[%-${BAR_WIDTH}s] %d/%d\n" "$BAR_FULL" "$TOTAL" "$TOTAL"

    INSTALLED=0
    FAILED=()
    for ((i=0; i<TOTAL; i++)); do
        if [[ -f "$PROGRESS_DIR/$i.status" ]] && grep -q '^OK$' "$PROGRESS_DIR/$i.status"; then
            INSTALLED=$((INSTALLED + 1))
        else
            FAILED+=("${EXTENSIONS[$i]}")
        fi
    done

    echo -e "${C_GREEN}       ✓ $INSTALLED/$TOTAL extensiones instaladas${C_RESET}"
    if [[ ${#FAILED[@]} -gt 0 ]]; then
        echo -e "${C_YELLOW}       ⚠ Fallaron ${#FAILED[@]} extensiones:${C_RESET}"
        for ext in "${FAILED[@]}"; do
            echo -e "${C_YELLOW}         - $ext${C_RESET}"
        done
    fi
fi

echo ""
echo -e "${C_YELLOW}[3/4] Instalando fuentes Fira Code...${C_RESET}"
case "$(uname -s)" in
    Darwin)
        FONT_DIR="$HOME/Library/Fonts"
        mkdir -p "$FONT_DIR"
        if cp "$SCRIPT_DIR/fire code font/ttf/"*.ttf "$FONT_DIR/" 2>/dev/null; then
            if command -v atsutil >/dev/null 2>&1; then
                atsutil databases -rebuild >/dev/null 2>&1 || true
            fi
            echo -e "${C_GREEN}       ✓ Fuentes copiadas a ~/Library/Fonts${C_RESET}"
        else
            echo -e "${C_RED}       ✗ Error copiando fuentes${C_RESET}" >&2
            exit 1
        fi
        ;;
    Linux)
        FONT_DIR="$HOME/.local/share/fonts"
        mkdir -p "$FONT_DIR"
        if cp "$SCRIPT_DIR/fire code font/ttf/"*.ttf "$FONT_DIR/" 2>/dev/null; then
            if command -v fc-cache >/dev/null 2>&1; then
                fc-cache -f "$FONT_DIR" >/dev/null 2>&1
            fi
            echo -e "${C_GREEN}       ✓ Fuentes copiadas a ~/.local/share/fonts${C_RESET}"
        else
            echo -e "${C_RED}       ✗ Error copiando fuentes${C_RESET}" >&2
            exit 1
        fi
        ;;
    MINGW*|MSYS*)
        FONT_DIR="$LOCALAPPDATA/Microsoft/Windows/Fonts"
        mkdir -p "$FONT_DIR"
        cp "$SCRIPT_DIR/fire code font/ttf/"*.ttf "$FONT_DIR/" 2>/dev/null || true
        echo -e "${C_YELLOW}       (bash en Windows: fuentes copiadas pero no registradas.${C_RESET}"
        echo -e "${C_YELLOW}        Usá setup.ps1 desde PowerShell para registro completo)${C_RESET}"
        ;;
    *)
        echo -e "${C_YELLOW}       SO no reconocido, fuentes omitidas.${C_RESET}"
        ;;
esac

echo ""
echo -e "${C_YELLOW}[4/4] Copiando config...${C_RESET}"
mkdir -p "$CODE_USER"

cp "$SCRIPT_DIR/settings.json" "$CODE_USER/settings.json" || {
    echo -e "${C_RED}       ✗ Error copiando settings.json${C_RESET}" >&2
    exit 1
}
echo -e "${C_GREEN}       ✓ settings.json${C_RESET}"

if [[ -f "$SCRIPT_DIR/keybindings.json" ]]; then
    cp "$SCRIPT_DIR/keybindings.json" "$CODE_USER/keybindings.json"
    echo -e "${C_GREEN}       ✓ keybindings.json${C_RESET}"
fi

if [[ -d "$SCRIPT_DIR/snippets" ]]; then
    rm -rf "$CODE_USER/snippets"
    cp -r "$SCRIPT_DIR/snippets" "$CODE_USER/snippets"
    echo -e "${C_GREEN}       ✓ snippets/${C_RESET}"
fi

echo ""
echo -e "${C_CYAN}=== Setup completado ===${C_RESET}"
echo -e "${C_CYAN}Recargá VS Code (Ctrl+Shift+P > 'Developer: Reload Window') para aplicar cambios.${C_RESET}"
