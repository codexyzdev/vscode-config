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

## Qué incluye

| Archivo | Descripción |
|---|---|
| `settings.json` | Config del editor, Vim, formateo, terminal, Git |
| `extensions.txt` | Lista de extensiones (referencia / backup) |
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
| `editor.minimap.enabled: false` | Oculta el minimap para ganar espacio vertical |
| `editor.linkedEditing: true` | Edición sincronizada de tags HTML/JSX |
| `editor.semanticHighlighting.enabled: true` | Highlighting semántico del LSP |
| `editor.bracketPairColorization` | Coloreado independiente por tipo de bracket |
| `editor.stickyScroll.enabled: true` | Sticky scroll en la parte superior del editor |
| `editor.fontWeight: "400"` | Fira Code en peso regular (mejor legibilidad) |
| `editor.tabSize: 2` | Indentación de 2 espacios |
| `files.autoSave: "afterDelay"` | Autosave con delay |
| `typescript.preferences.importModuleSpecifier: "non-relative"` | Imports TS sin rutas relativas cuando es posible |

> La config de Prettier vive en `.prettierrc` (no en `settings.json`) para que sea portable entre proyectos y clones del repo.

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

#### Paneles y foco

| Tecla | Acción |
|---|---|
| `<C-w> h` | Ir al panel izquierdo |
| `<C-w> l` | Ir al panel derecho |
| `<C-w> k` | Ir al panel superior |
| `<C-w> j` | Ir al panel inferior |
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
