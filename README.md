# VS Code Config

Mi configuración personal de VS Code — portable, sin login, lista en un solo comando.

> [codexyz.dev](https://www.codexyz.dev/)

## Requisitos

- [VS Code](https://code.visualstudio.com/) instalado y con `code` en el PATH

## Uso

### Opción 1: npx (sin clonar)

Desde cualquier directorio:

```bash
npx @codexyzdev/vscode-config
```

Antes de tocar nada, el script muestra qué va a hacer y pide confirmación. Para saltear el prompt:

```bash
npx @codexyzdev/vscode-config -y
```

Si querés volver atrás después:

```bash
npx @codexyzdev/vscode-config restore
```

### Opción 2: clonar el repo

```bash
git clone https://github.com/codexyzdev/vscode-config.git
cd vscode-config
```

#### Windows

```powershell
.\setup.ps1
```

#### Linux / Mac

```bash
chmod +x setup.sh
./setup.sh
```

## Restaurar

Si querés volver a la config que tenías antes de correr el setup:

- Vía npx: `npx @codexyzdev/vscode-config restore`
- Windows (repo clonado): `.\restore.ps1`
- Linux / Mac (repo clonado): `./restore.sh`

Por defecto toma el backup más reciente de `.backups/`. Para uno específico:

- npx: `npx @codexyzdev/vscode-config restore 2026-07-14_203000`
- Windows: `.\restore.ps1 -Timestamp 2026-07-14_203000`
- Linux / Mac: `./restore.sh 2026-07-14_203000`

Restaurar también sincroniza las extensiones: desinstala las que no estaban en el backup y reinstala las que tenías antes. Para saltear la confirmación: `-Force` (PowerShell) o `-y` (bash).

## Backup automático

Cada vez que corrés `setup`, antes de tocar nada se guarda una copia de tu `settings.json`, `keybindings.json`, `snippets/` y la lista de extensiones instaladas en `.backups/<timestamp>/` (uno por ejecución). La carpeta `.backups/` está ignorada por git, podés limpiarla cuando quieras.

## Qué hace el setup

Al ejecutarlo, en orden:

1. **Backup** de tu `settings.json`, `keybindings.json`, `snippets/` y lista de extensiones actuales en `.backups/<timestamp>/`.
2. **Instala las extensiones** listadas en `extensions.txt` (4 en paralelo, con barra de progreso).
3. **Copia** la fuente Fira Code desde `fire code font/` y la registra en el sistema (P/Invoke + registro en Windows, `atsutil` en macOS, `fc-cache` en Linux).
4. **Copia** `settings.json` a la carpeta de usuario de VS Code (`%APPDATA%\Code\User\` en Windows, `~/.config/Code/User/` en Linux, `~/Library/Application Support/Code/User/` en macOS), y también `keybindings.json` y `snippets/` si existen en el repo.

> Si VS Code no está en PATH, el setup aborta con un mensaje accionable. Para sumarlo: `View > Command Palette > Shell Command: Install 'code' command in PATH`.

## Qué incluye

| Archivo | Descripción |
|---|---|
| `settings.json` | Config del editor, Vim, formateo, terminal, Git |
| `extensions.txt` | Lista de extensiones a instalar (52) |
| `fire code font/` | Fuente Fira Code (6 variantes) |
| `package.json` | Config npm + entry point para `npx` |
| `bin/cli.js` | Wrapper multiplataforma que detecta el SO y delega al script correspondiente |
| `setup.ps1` | Script de instalación para Windows |
| `setup.sh` | Script de instalación para Linux/Mac |
| `restore.ps1` | Script para restaurar el backup (Windows) |
| `restore.sh` | Script para restaurar el backup (Linux/Mac) |

## Editor

| Setting | Qué hace |
|---|---|
| `editor.fontLigatures: true` | Ligaduras de Fira Code (`=>`, `!=`, etc.) |
| `editor.fontWeight: "500"` | Fira Code en peso medium |
| `editor.linkedEditing: true` | Edición sincronizada de tags HTML/JSX |
| `editor.bracketPairColorization` | Coloreado independiente por tipo de bracket |
| `editor.stickyScroll.enabled: true` | Sticky scroll en la parte superior del editor |
| `editor.tabSize: 2` | Indentación de 2 espacios |
| `editor.formatOnSave: true` | Formateo automático al guardar |
| `editor.lineNumbers: "relative"` | Números de línea relativos (ideal con Vim) |
| `files.autoSave: "afterDelay"` | Autosave con delay |
| `js/ts.updateImportsOnFileMove.enabled: "always"` | Actualiza imports al mover/renombrar archivos |
| `prettier.jsxSingleQuote: true` | Comillas simples en JSX |

## Atajos personalizados

Referencia completa en [`VIM.md`](./VIM.md).

> Leader key: `<space>`

### Modo Normal

#### Archivos y formato

| Tecla | Acción |
|---|---|
| `<space> w` | Guardar archivo |
| `<space> t w` | Alternar word wrap |
| `<space> f` | Formatear documento |
| `<space> f f` | Quick Open (buscar archivo) |
| `<space> f g` | Buscar en archivos (grep) |
| `<space> f b` | Listar buffers abiertos |
| `<space> f r` | Archivos recientes |
| `<space> f s` | Ir a símbolo del workspace |

#### Navegación de código (LSP)

| Tecla | Acción |
|---|---|
| `g d` | Ir a definición |
| `g D` | Ir a declaración |
| `g i` | Ir a implementación |
| `g r` | Buscar referencias |
| `g y` | Ir a definición de tipo |
| `<space> r n` | Renombrar símbolo |
| `K` | Mostrar documentación (hover) |
| `<space> c a` | Quick fix / code actions |

#### Diagnósticos

| Tecla | Acción |
|---|---|
| `] d` | Siguiente error/warning |
| `[ d` | Error/warning anterior |

#### Edición de líneas

| Tecla | Acción |
|---|---|
| `<space> d` | Duplicar línea hacia abajo |
| `<space> u` | Duplicar línea hacia arriba |
| `<space> x` | Borrar línea |
| `<space> /` | Comentar/descomentar línea |
| `g c c` | Comentar línea (commentary) |
| `g c` (visual) | Comentar selección (commentary) |

#### Paneles, foco y buffers

| Tecla | Acción |
|---|---|
| `<C-h>` | Ir al panel izquierdo |
| `<C-l>` | Ir al panel derecho |
| `<C-k>` | Ir al panel superior |
| `<C-j>` | Ir al panel inferior |
| `H` | Editor anterior del grupo |
| `L` | Editor siguiente del grupo |
| `s v` | Split vertical |
| `<space> e` | Toggle explorer |
| `<space> t t` | Toggle terminal |
| `<space> t f` | Focus terminal |
| `<space> t n` | Nueva terminal |
| `<space> b d` | Cerrar buffer actual |
| `<space> q` | Cerrar todos los editores |

#### Búsqueda

| Tecla | Acción |
|---|---|
| `<C-n>` | Quitar resaltado de búsqueda |
| `<leader><leader> s <char>` | EasyMotion (saltar a `<char>`) |

### Modo Insert

| Tecla | Acción |
|---|---|
| `j j` | Salir a modo Normal (`<Esc>`) |

### Teclas liberadas (usa las de VS Code)

| Tecla | Va a |
|---|---|
| `<C-a>` | Seleccionar todo |
| `<C-c>` | Copiar |
| `<C-v>` | Pegar |
| `<C-f>` | Buscar en archivo |
| `<C-z>` | Deshacer |
| `<C-p>` | Quick Open nativo |
| `<C-w>` | Cerrar editor (nativo de VS Code — cuidado, usá `<space> b d`) |

### Comportamiento Vim activo

| Setting | Qué hace |
|---|---|
| `easymotion` | Movimiento rápido con `<leader><leader>` |
| `incsearch` | Búsqueda incremental mientras escribís |
| `hlsearch` | Resalta todos los resultados de búsqueda |
| `useSystemClipboard` | Yank/put comparten portapapeles con el SO |
| `useCtrlKeys` | Habilita atajos como `<C-r>`, `<C-d>`, `<C-u>` |
| `commentary` | `gcc` y `gc` para comentar (siempre activo) |
| `surround` | `ys`/`cs`/`ds` para manipular surrounds (siempre activo) |
| `highlightedyank` | Resalta brevemente lo que acabás de yankear |
| `visualstar` | En visual, `*`/`#` buscan la selección actual |
| `sneak` | `s<char><char>` salta a la próxima aparición de 2 chars |
| `camelCaseMotion` | `w`/`b`/`e` saltan entre segmentos de camelCase / snake_case |
