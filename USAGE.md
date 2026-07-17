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
2. **Copia** `settings.json` a la carpeta de usuario de VS Code (`%APPDATA%\Code\User\` en Windows, `~/.config/Code/User/` en Linux, `~/Library/Application Support/Code/User/` en macOS).
3. **Instala** todas las extensiones listadas en `extensions.txt` (las que falten).
4. **Copia** la fuente Fira Code desde `fire code font/` a la carpeta de fuentes del sistema.
5. **Muestra** un resumen con qué cambió y cómo restaurar.

Nada se reinstala si ya está — el script es idempotente.

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

### Agregar o quitar extensiones

Editá `extensions.txt`, una por línea:

```
vscodevim.vim
esbenp.prettier-vscode
dbaeumer.vscode-eslint
```

Al volver a correr `setup`, se instalan las que falten y se desinstalan las que ya no estén listadas (a menos que estén en `extensions_keep.txt` si lo creás).

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
Abrí VS Code, `Ctrl+Shift+P` → "Shell Command: Install 'code' command in PATH", reiniciá la terminal.

**Los atajos de Vim no funcionan**
Verificá que la extensión `vscodevim.vim` esté instalada (`code --list-extensions | grep vim`). Si no, corré `setup` de nuevo.

**Una extensión no se instala**
Revisá el ID en `extensions.txt`. El formato es `publisher.name`, lo encontrás en la página de la extensión en el Marketplace.

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
