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

Restaurar también desinstala las extensiones que el setup haya agregado y reinstala las que tenías. Para saltear la confirmación: `-Force` (PowerShell) o `-y` (bash).

## Backup automático

Cada vez que corrés `setup`, antes de tocar nada se guarda una copia de tu `settings.json`, `keybindings.json`, `snippets/` y la lista de extensiones instaladas en `.backups/<timestamp>/` (uno por ejecución). La carpeta `.backups/` está ignorada por git, podés limpiarla cuando quieras.

## Qué incluye

| Archivo | Descripción |
|---|---|
| `settings.json` | Config del editor, Vim, formateo, terminal, Git |
| `extensions.txt` | Lista de extensiones a instalar |
| `fire code font/` | Fuente Fira Code (6 variantes) |
| `package.json` | Config npm + entry point para `npx` |
| `bin/cli.js` | Wrapper multiplataforma que detecta el SO y delega al script correspondiente |
| `setup.ps1` | Script de instalación para Windows |
| `setup.sh` | Script de instalación para Linux/Mac |
| `restore.ps1` | Script para restaurar el backup (Windows) |
| `restore.sh` | Script para restaurar el backup (Linux/Mac) |

## Editor

| Setting | Valor | Qué hace |
|---|---|---|
| `editor.fontFamily` | `Fira Code, Consolas, 'Courier New', monospace` | Fuente con ligaduras |
| `editor.fontLigatures` | `true` | Activa ligaduras tipográficas |
| `editor.fontWeight` | `400` | Peso de la fuente |
| `editor.tabSize` | `2` | Tamaño de tabulación |
| `editor.formatOnSave` | `true` | Formatea al guardar |
| `files.autoSave` | `afterDelay` | Autosave con delay |
| `editor.lineNumbers` | `relative` | Números de línea relativos (Vim-friendly) |
| `editor.cursorBlinking` | `expand` | Cursor expandido al parpadear |
| `editor.cursorSmoothCaretAnimation` | `on` | Animación suave del cursor |
| `editor.stickyScroll.enabled` | `true` | Sticky scroll para ver el contexto |
| `editor.guides.bracketPairs` | `true` | Guías de pares de corchetes |
| `editor.bracketPairColorization.independentColorPoolPerBracketType` | `true` | Color independiente por tipo de bracket |
| `editor.guides.highlightActiveBracketPair` | `true` | Resalta el par de brackets activo |
| `editor.experimental.asyncTokenization` | `true` | Tokenización asíncrona (mejor performance) |
| `editor.inlineSuggest.edits.showCollapsed` | `true` | Inline suggestions colapsadas |
| `js/ts.updateImportsOnFileMove.enabled` | `always` | Actualiza imports al mover archivos |
| `emmet.includeLanguages` | `{ "javascript": "javascriptreact" }` | Emmet en archivos JSX |

## Apariencia y UI

| Setting | Valor | Qué hace |
|---|---|---|
| `workbench.colorTheme` | `One Dark Pro` | Tema de color |
| `workbench.iconTheme` | `symbols` | Iconos estilo símbolos |
| `workbench.sideBar.location` | `right` | Sidebar a la derecha |
| `workbench.startupEditor` | `none` | Sin pantalla de bienvenida |
| `workbench.navigationControl.enabled` | `false` | Oculta controles de navegación |
| `workbench.layoutControl.enabled` | `false` | Oculta control de layout |
| `window.menuBarVisibility` | `classic` | Menu bar visible (Alt para toggle) |
| `symbols.hidesExplorerArrows` | `false` | Muestra flechas en el explorer |

## Formateo por lenguaje

Prettier es el formateador por defecto para la mayoría de lenguajes, con configuración específica:

| Setting | Valor | Qué hace |
|---|---|---|
| `prettier.jsxSingleQuote` | `true` | Comillas simples en JSX |
| `[html]` | `prettier-vscode` | Formatter default HTML |
| `[javascriptreact]` | `prettier-vscode` | Formatter default JSX |
| `[typescriptreact]` | `prettier-vscode` | Formatter default TSX |
| `[css]` | `prettier-vscode` | Formatter default CSS |
| `[jsonc]` | `prettier-vscode` | Formatter default JSONC |
| `[astro]` | `astro-vscode` | Formatter default Astro |
| `[python]` | `black-formatter` | Formatter default Python (Black) |

## Git

| Setting | Valor | Qué hace |
|---|---|---|
| `git.autofetch` | `true` | Fetch automático del remoto |
| `git.enableSmartCommit` | `true` | Commit sin stage explícito |

## Terminal

| Setting | Valor | Qué hace |
|---|---|---|
| `terminal.integrated.defaultProfile.windows` | `Git Bash` | Perfil por defecto en Windows |
| `terminal.integrated.fontLigatures.enabled` | `true` | Ligaduras en la terminal |
| `terminal.integrated.profiles.windows` | PowerShell, CMD, Git Bash, Cmder | Perfiles disponibles |

## Otros

| Setting | Valor | Qué hace |
|---|---|---|
| `security.allowedUNCHosts` | `["wsl.localhost"]` | Permite links UNCHost para WSL |
| `workbench.editorAssociations` | `*.svg → default` | Abre SVG con editor por defecto |
| `json.schemaDownload.trustedDomains` | schemastore, raw.githubusercontent, biomejs, etc. | Dominios confiables para descargar schemas |
| `github.copilot.enable` | `false` | Copilot deshabilitado globalmente |

## Atajos personalizados

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

#### Paneles y foco

| Tecla | Acción |
|---|---|
| `<C-h>` | Ir al panel izquierdo |
| `<C-l>` | Ir al panel derecho |
| `<C-k>` | Ir al panel superior |
| `<C-j>` | Ir al panel inferior |
| `s v` | Split vertical |
| `<space> e` | Toggle explorer |
| `<space> t t` | Toggle terminal |
| `<space> t f` | Focus terminal |
| `<space> t n` | Nueva terminal |
| `<space> b d` | Cerrar buffer actual |
| `<space> q` | Cerrar todos los editores |
| `H` | Editor anterior |
| `L` | Editor siguiente |

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
| `<C-p>` | Quick Open (archivos) |
| `<C-w>` | Cerrar editor |

### Comportamiento Vim activo

| Setting | Qué hace |
|---|---|
| `vim.leader` | Leader key configurada como `<space>` |
| `easymotion` | Movimiento rápido con `<leader><leader>` |
| `incsearch` | Búsqueda incremental mientras escribís |
| `hlsearch` | Resalta todos los resultados de búsqueda |
| `useSystemClipboard` | Yank/put comparten portapapeles con el SO |
| `useCtrlKeys` | Habilita atajos como `<C-r>`, `<C-d>`, `<C-u>` |
| `vim.cursorPositionMode` | `keep` — mantiene la posición del cursor al volver |
| `commentary` | `gcc` y `gc` para comentar (siempre activo) |
| `surround` | `ys`/`cs`/`ds` para manipular surrounds (siempre activo) |
| `highlightedyank` | Resalta brevemente lo que acabás de yankear |
| `visualstar` | En visual, `*`/`#` buscan la selección actual |
| `sneak` | `s<char><char>` salta a la próxima aparición de 2 chars |
| `camelCaseMotion` | `w`/`b`/`e` saltan entre segmentos de camelCase / snake_case |
| `extensions.experimental.affinity` | Acelera VSCodeVim asignándole un core dedicado |
