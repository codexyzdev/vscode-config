# Guía de uso

Cómo instalar, personalizar y mantener esta configuración de VS Code.

## Inicio rápido

Si solo querés probarlo sin clonar nada:

```bash
npx @codexyzdev/vscode-config
```

El script te muestra qué va a hacer antes de tocar nada y pide confirmación. Con `-y` salta el prompt.

## Instalación local

Cloná el repo para poder modificar la config a gusto:

```bash
git clone https://github.com/codexyzdev/vscode-config.git
cd vscode-config
```

### Windows (PowerShell)

```powershell
.\setup.ps1
```

Si te bloquea la ejecución de scripts:

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

### Linux / macOS (bash)

```bash
chmod +x setup.sh
./setup.sh
```

## Qué hace el setup

Al ejecutarlo, en orden:

1. **Backup** de tu `settings.json`, `keybindings.json`, `snippets/` y lista de extensiones actuales en `.backups/<timestamp>/`.
2. **Instala las extensiones** listadas en `extensions.txt` con `code --install-extension`, en grupos de 4, con barra de progreso Unicode.
3. **Copia y registra** la fuente Fira Code desde `fire code font/` en el sistema:
   - **Windows**: P/Invoke (`gdi32::AddFontResource`) + entrada en `HKCU\Software\Microsoft\Windows NT\CurrentVersion\Fonts` + `SendMessageTimeout(WM_FONTCHANGE)`. Sin permisos de admin.
   - **macOS**: copia a `~/Library/Fonts` + `atsutil databases -rebuild`.
   - **Linux**: copia a `~/.local/share/fonts` + `fc-cache -f`.
4. **Copia** `settings.json` a la carpeta de usuario de VS Code (`%APPDATA%\Code\User\` en Windows, `~/.config/Code/User/` en Linux, `~/Library/Application Support/Code/User/` en macOS), junto con `keybindings.json` y `snippets/` si existen en el repo. Al final te pide recargar la ventana (`Developer: Reload Window`) para aplicar todo.

El script es idempotente: lo podés correr varias veces sin romper nada. Si una extensión ya está instalada, la re-instala con `--force` (rápido). Si las fuentes ya están registradas, no duplica la entrada del registro.

> Si VS Code no está en PATH, el setup aborta con un mensaje accionable antes de tocar nada. Para sumarlo: `View > Command Palette > Shell Command: Install 'code' command in PATH`.

## Personalizar la configuración

Toda la config vive en archivos planos en la raíz del repo. Editalos y volvé a correr el setup para aplicar cambios.

### Editar settings

`settings.json` es el archivo principal. Cambios comunes:

```json
{
  "editor.tabSize": 4,
  "editor.fontSize": 16,
  "workbench.colorTheme": "One Dark Pro"
}
```

### Cambiar keybindings

Los atajos de Vim están en `vim.normalModeKeyBindingsNonRecursive` dentro de `settings.json`. Para agregar uno nuevo:

```json
{
  "before": ["<leader>", "g", "g"],
  "commands": ["workbench.action.gotoLine"]
}
```

### Editar la lista de extensiones

Editá `extensions.txt` y `.vscode/extensions.json` (deben estar en sync). Una por línea / por entry del array:

```
vscodevim.vim
esbenp.prettier-vscode
dbaeumer.vscode-eslint
```

## Instalar extensiones (en tus proyectos)

El setup ya instala las extensiones recomendadas a nivel de usuario. Si querés recomendar un subset en un proyecto puntual, usá la carpeta `.vscode/extensions.json`:

### Drop-in con `.vscode/extensions.json` (Recomendado)

Descargá solo la carpeta `.vscode/` y ponéla en la raíz de tu proyecto. Al abrirlo, VS Code te ofrece instalar las recomendadas.

```bash
# Ejemplo: clonar solo la carpeta .vscode
npx degit codexyzdev/vscode-config/.vscode tu-proyecto/.vscode
```

### Desde VS Code

En el repo, abrí la vista de extensiones, filtrá por `@recommended` (en el dropdown). Te aparece la lista completa y un botón "Install All" arriba.

## Vim: lineas relativas para moverte mas rapido

Con `editor.lineNumbers: "relative"` cada línea muestra su **distancia al cursor**, no su número real. La línea actual sigue mostrando el número real para saber dónde estás.

```
      8   ← 8 líneas arriba
      3   ← 3 líneas arriba
      2
      1
  →  42  ← línea actual (número real)
      1   ← 1 línea abajo
      4
```

El truco: leer el número y usarlo como **contador de motion**.

| Querés... | Hacé |
|---|---|
| Bajar 8 líneas | `8j` |
| Subir 3 líneas | `3k` |
| Ir a esa línea y entrar en insert | `8j i` o `8j a` |
| Borrar 4 líneas desde ahí | `8j 4dd` |
| Copiar hasta esa línea | `8j y}` |
| Yankear 5 líneas abajo | `8j 5yy` |

Con números absolutos tendrías que hacer `60G` o `:60` (escribir el número). Con relativos solo leés el dígito en pantalla y lo ejecutás — tu cerebro lee directo la distancia.

### Movimientos con conteo

| Motion | Qué hace |
|---|---|
| `5j` / `5k` | 5 líneas abajo / arriba |
| `3w` / `3b` | 3 palabras adelante / atrás |
| `2}` | 2 párrafos abajo |
| `2)` | 2 frases adelante |
| `7G` | Ir a línea 7 (casi no lo usás con relativas) |
| `gg` / `G` | Inicio / fin del archivo |
| `H` / `M` / `L` | Top / middle / bottom de la pantalla visible |

### Ejemplo real

Estás en la línea 42 y querés borrar la línea 60:

1. Leés `18` abajo del cursor.
2. Tecleás `18j` → saltás directo a la 60.
3. Tecleás `dd` → la borrás.

### Combinar con lo que ya tenés

- **EasyMotion** (`<leader><leader> s<char>`) para saltos largos sin contar.
- **Sneak** (`s<char><char>`) para saltar a 2 chars visibles.
- **Vim surround** (`ys`/`cs`/`ds`) para manipular brackets y comillas.

## Restaurar un backup

Cada ejecución de `setup` guarda un backup nuevo. Para volver a un estado anterior:

```bash
# Listar backups disponibles
ls .backups/

# Restaurar el más reciente
npx @codexyzdev/vscode-config restore

# Restaurar uno específico
npx @codexyzdev/vscode-config restore 2026-07-14_203000
```

O desde el repo clonado:

```powershell
.\restore.ps1                           # Windows, el más reciente
.\restore.ps1 -Timestamp 2026-07-14_203000  # uno específico
.\restore.ps1 -Force                    # sin pedir confirmación
```

```bash
./restore.sh 2026-07-14_203000
./restore.sh -y                         # sin pedir confirmación
```

El restore desinstala las extensiones que el setup agregó y reinstala las que tenías antes.

## Flujo de trabajo típico

**Setup inicial en una máquina nueva:**

```bash
git clone https://github.com/codexyzdev/vscode-config.git
cd vscode-config
./setup.sh        # o .\setup.ps1 en Windows
```

**Probar un cambio en la config:**

1. Editás `settings.json` en el repo.
2. Corrés `./setup.sh` de nuevo.
3. Si algo se rompe, `./restore.sh` para volver al estado anterior.

**Iterar sobre la config sin perder el estado actual:**

```bash
cp settings.json settings.local.json   # tu override
# editás settings.local.json
# usás ese mientras experimentás
```

## Sincronizar entre máquinas

El repo es la fuente de verdad. Para tener la misma config en varias máquinas:

```bash
# Máquina A
git add . && git commit -m "feat: new color theme"
git push

# Máquina B
git pull
./setup.sh
```

## Solución de problemas

**`code` no se reconoce como comando**
El setup aborta al inicio con un mensaje accionable. Lo que tenés que hacer:
1. Abrí VS Code.
2. `View > Command Palette > Shell Command: Install 'code' command in PATH`.
3. Cerrá la terminal y abrí una nueva.
4. Corré el setup de nuevo.

**Los atajos de Vim no funcionan**
Verificá que la extensión `vscodevim.vim` esté instalada (`code --list-extensions | grep vim`). Si no, corré `setup` de nuevo.

**Una extensión no se instala**
Al final del setup te aparece la lista de las que fallaron. Causas comunes:
- ID mal escrito en `extensions.txt` (el formato es `publisher.name`, lo encontrás en la URL de la página de la extensión en el Marketplace).
- La extensión fue removida o renombrada.
- Sin conexión a internet, o el Marketplace está caido.

Reintentá con `code --install-extension <id>` y, si falla, mirá el mensaje de error.

**Las fuentes no aparecen en VS Code**
- **Windows**: si corriste el setup desde bash/Git Bash en vez de PowerShell, las fuentes se copiaron pero no se registraron. Volvé a correr `setup.ps1` desde PowerShell.
- **macOS**: si `atsutil` no está disponible (raro), reiniciá sesión y debería funcionar.
- **Linux**: si `fc-cache` no está disponible, instalá `fontconfig` o corré `fc-cache -fv` manualmente.

**El backup no se restauró como esperabas**
Los backups se guardan en `.backups/<timestamp>/`. Inspeccioná manualmente:

```bash
ls .backups/
cat .backups/2026-07-14_203000/settings.json
```

Si querés restaurar a mano, copiá los archivos de esa carpeta a la carpeta de usuario de VS Code.

**Cambié la config y VS Code no la refleja**
Algunos settings requieren recargar la ventana: `Ctrl+Shift+P` → "Developer: Reload Window".

## Estructura del proyecto

```
vscode-config/
├── settings.json          # Config del editor
├── extensions.txt         # Extensiones a instalar
├── fire code font/        # Fuente Fira Code
├── package.json           # Metadata npm + entry point
├── bin/cli.js             # Wrapper multiplataforma
├── setup.ps1              # Instalador Windows
├── setup.sh               # Instalador Linux/macOS
├── restore.ps1            # Restaurador Windows
├── restore.sh             # Restaurador Linux/macOS
└── .backups/              # Backups automáticos (gitignored)
```

## Agregar soporte para otro SO

El wrapper en `bin/cli.js` detecta el SO y delega al script correspondiente. Para agregar uno nuevo:

1. Creá `setup.<ext>` y `restore.<ext>` con la misma interfaz.
2. Sumá la detección en `bin/cli.js`.
3. Actualizá este doc.

## Ver también

- [README.md](./README.md) — overview y badges
- [settings.json](./settings.json) — la config completa
- [extensions.txt](./extensions.txt) — lista de extensiones
