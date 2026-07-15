# VS Code Config

Mi configuración personal de VS Code — portable, sin login, lista en un solo comando.

> [codexyz.dev](https://www.codexyz.dev/)

## Requisitos

- [VS Code](https://code.visualstudio.com/) instalado y con `code` en el PATH

## Uso

```bash
git clone https://github.com/codexyzdev/vscode-config.git
cd vscode-config
```

### Windows

```powershell
.\setup.ps1
```

### Linux / Mac

```bash
chmod +x setup.sh
./setup.sh
```

## Restaurar

Si querés volver a la config que tenías antes de correr el setup:

- Windows: `.\restore.ps1`
- Linux / Mac: `./restore.sh`

Por defecto toma el backup más reciente de `.backups/`. Para uno específico:

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
| `setup.ps1` | Script de instalación para Windows |
| `setup.sh` | Script de instalación para Linux/Mac |
| `restore.ps1` | Script para restaurar el backup (Windows) |
| `restore.sh` | Script para restaurar el backup (Linux/Mac) |

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
| `extensions.experimental.affinity` | Acelera VSCodeVim asignándole un core dedicado |
