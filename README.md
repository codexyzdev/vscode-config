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

## Qué incluye

| Archivo | Descripción |
|---|---|
| `settings.json` | Config del editor, Vim, formateo, terminal, Git |
| `extensions.txt` | Lista de extensiones a instalar |
| `fire code font/` | Fuente Fira Code (6 variantes) |
| `setup.ps1` | Script de instalación para Windows |
| `setup.sh` | Script de instalación para Linux/Mac |

## Atajos personalizados

> Leader key: `<space>`

### Modo Normal

| Tecla | Acción |
|---|---|
| `<space> w` | Guardar archivo |
| `<space> f` | Formatear documento |
| `g d` | Ir a definición |
| `g R` | Renombrar símbolo |
| `K` | Mostrar documentación (hover) |
| `<C-n>` | Quitar resaltado de búsqueda |
| `<C-h>` | Ir al panel izquierdo |
| `<C-l>` | Ir al panel derecho |
| `<C-k>` | Ir al panel superior |
| `<C-j>` | Ir al panel inferior |
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
