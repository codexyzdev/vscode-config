# Vim en VS Code

Guía de referencia para usar VSCodeVim con esta configuración. Asume que conocés los básicos de Vim; el foco está en los atajos y comportamientos habilitados acá.

> **Leader key:** `<space>` — todas las combinaciones `<space> x` se escriben como `space` + `x` en modo Normal.

---

## Modos

| Modo | Cómo entrar | Cómo salir |
|---|---|---|
| Normal | `<Esc>` o `jj` desde Insert | — |
| Insert | `i`, `a`, `o`, `O`, `s`, etc. | `<Esc>` o `jj` |
| Visual | `v` (carácter), `V` (línea) | `<Esc>` o `jj` |
| Command-line | `:` (comandos ex) | `<Esc>` |
| Search | `/` o `?` | `<Esc>` |

`jj` mapeado desde Insert es la única forma rápida de volver a Normal sin mover la mano a `<Esc>`.

> El modo Visual-bloque (`<C-v>`) no está disponible: `<C-v>` está liberado a VS Code (pegar).

---

## Movimiento

### Básico

| Tecla | Acción |
|---|---|
| `h` `j` `k` `l` | Izquierda, abajo, arriba, derecha |
| `w` / `b` / `e` | Palabra siguiente / anterior / fin de palabra |
| `W` / `B` / `E` | WORD siguiente / anterior / fin (espacio-delimitado) |
| `0` / `$` | Inicio / fin de línea |
| `^` | Primer carácter no-blanco de la línea |
| `gg` / `G` | Inicio / fin del archivo |
| `{` / `}` | Párrafo anterior / siguiente |
| `%` | Saltar al bracket que matchea |
| `M` | Middle de la pantalla |
| `C-u` / `C-d` | Media página arriba / abajo |
| `C-b` / `C-f` | Página completa arriba / abajo |
| `C-y` / `C-e` | Scroll sin mover cursor |

> `w`/`b`/`e` se comportan con `camelCaseMotion`: en `getUserById` saltan entre `get` / `User` / `By` / `Id`. Idem para `snake_case`.

> `H` y `L` están rebindeados a editor anterior/siguiente (ver [Tabs y buffers](#tabs-y-buffers)); el "top/bottom de pantalla" nativo de Vim queda sobreescrito.

### Lineas relativas: motion con conteo

Con `editor.lineNumbers: "relative"` el gutter muestra la **distancia al cursor** en vez del número real. La línea actual muestra su número real, todas las demás muestran cuántas líneas las separan del cursor.

```
      8
      3
      2
      1
  →  42   ← línea actual (número real)
      1
      4
```

El truco: leer el número y usarlo como **contador de motion** directo.

| Querés... | Hacé |
|---|---|
| Bajar 8 líneas | `8j` |
| Subir 3 líneas | `3k` |
| Ir a esa línea y entrar en insert | `8j i` o `8j a` |
| Borrar 4 líneas desde ahí | `8j 4dd` |
| Yankear 5 líneas abajo | `8j 5yy` |
| Copiar hasta esa línea | `8j y}` |

Con números absolutos tendrías que hacer `60G` o `:60`. Con relativos leés el dígito y lo ejecutás — sin pensar.

**Ejemplo real:** estás en la línea 42 y querés borrar la 60. Leés `18` abajo del cursor, tecleás `18j` → saltás a la 60 → `dd` para borrar.

Combina bien con:
- **EasyMotion** (`<leader><leader> s<char>`) para saltos largos sin contar
- **Sneak** (`s<char><char>`) para ir a 2 chars visibles
- **`M`** para ir al medio de la pantalla (`H`/`L` están rebindeados a cambiar de editor)

---

## Búsqueda y salto rápido

| Tecla | Acción |
|---|---|
| `/` + patrón | Buscar hacia adelante (incremental, `incsearch`) |
| `?` + patrón | Buscar hacia atrás |
| `n` / `N` | Siguiente / anterior match |
| `*` / `#` | Buscar la palabra bajo el cursor (en visual: la selección, `visualstar`) |
| `<C-n>` | Quitar el resaltado de búsqueda (`:nohlsearch`) |
| `<leader><leader>` + char | **EasyMotion**: highlight de todos los matches en pantalla, luego elegís con la letra |
| `s` + `<char><char>` | **Sneak**: salta a la próxima aparición de 2 caracteres |
| `S` + `<char><char>` | Sneak hacia atrás |

> Con `hlsearch` activo, todos los matches quedan resaltados hasta que presiones `<C-n>` o hagas otra búsqueda.

### Ejemplo EasyMotion

```
<leader><leader> w   →  saltar a la siguiente palabra
<leader><leader> j   →  saltar a una línea abajo (con hints)
<leader><leader> f<char>  →  buscar carácter en la línea
```

---

## Edición

### Operators básicos

| Operator | Acción | Ejemplo |
|---|---|---|
| `d` | Delete (cortar) | `dw`, `d$`, `dd` |
| `c` | Change (delete + insert) | `cw`, `ci"`, `cc` |
| `y` | Yank (copiar) | `yw`, `y$`, `yy` |
| `>` / `<` | Indent / outdent | `>>`, `>iw` |
| `=` | Auto-indent | `==` |

> `y`/`d` van al portapapeles del SO (`useSystemClipboard`), podés pegar en otras apps con `Ctrl+V`.

### Custom (definidos en esta config)

| Tecla | Acción |
|---|---|
| `<space> d` | Duplicar línea hacia abajo |
| `<space> u` | Duplicar línea hacia arriba |
| `<space> x` | Borrar línea (sin yank) |
| `<space> /` | Comentar / descomentar línea |
| `gcc` | Comentar línea (`commentary`) |
| `gc` + motion | Comentar rango (visual: `gc` comenta selección) |
| `ys` + motion + char | Agregar surround (`commentary`/`surround`) |
| `cs` + oldchar + newchar | Cambiar surround |
| `ds` + char | Quitar surround |

### Texto objects útiles

| Texto object | Selección |
|---|---|
| `iw` / `aw` | Palabra interior / con espacio |
| `i"` / `a"` | Comillas dobles |
| `i'` / `a'` | Comillas simples |
| `` i` `` / `` a` `` | Backticks |
| `ip` / `ap` | Párrafo |
| `it` / `at` | Tag HTML/JSX interior / con tag |
| `i(` / `a(` | Paréntesis |
| `i{` / `a{` | Llaves |
| `i[` / `a[` | Corchetes |

Ejemplo: `ci"` cambia el contenido dentro de comillas, `di(` borra lo de adentro de paréntesis, `yat` selecciona todo un tag.

### Undo / redo

| Tecla | Acción |
|---|---|
| `u` | Undo |
| `<C-r>` | Redo |

---

## Navegación de código (LSP)

| Tecla | Acción |
|---|---|
| `g d` | Ir a definición |
| `g D` | Ir a declaración |
| `g i` | Ir a implementación |
| `g r` | Buscar referencias |
| `g y` | Ir a definición de tipo |
| `K` | Mostrar hover (documentación, tipo) |
| `<space> r n` | Renombrar símbolo (en todos los archivos) |
| `<space> c a` | Quick fix / code actions |

---

## Archivos, símbolos, búsqueda

| Tecla | Acción |
|---|---|
| `<space> w` | Guardar archivo |
| `<space> f` | Formatear documento (Prettier / Black) |
| `<space> t w` | Alternar word wrap |
| `<space> f f` | Quick Open (buscar archivo por nombre) |
| `<space> f g` | Buscar texto en archivos (grep) |
| `<space> f b` | Listar editores abiertos (buffers) |
| `<space> f r` | Archivos recientes |
| `<space> f s` | Ir a símbolo del workspace |
| `<space> b d` | Cerrar editor actual |
| `<space> q` | Cerrar todos los editores |

---

## Paneles, splits y foco

### Mover foco entre grupos

| Tecla | Acción |
|---|---|
| `<C-h>` | Foco al panel izquierdo |
| `<C-l>` | Foco al panel derecho |
| `<C-k>` | Foco al panel superior |
| `<C-j>` | Foco al panel inferior |

> Son `Ctrl` + letra directo (no el prefijo `<C-w>` de Vim): `<C-w>` está liberado a VS Code, que lo usa para cerrar el editor.

### Splits y barras laterales

| Tecla | Acción |
|---|---|
| `s v` | Split vertical |
| `<space> e` | Toggle explorer (mostrar/ocultar) |

Dentro del file tree, las teclas de Vim siguen funcionando: `j`/`k` para moverte, `o` o `Enter` para abrir, `Escape` para volver al editor.

---

## Tabs y buffers

VS Code no tiene "tabs" al estilo Vim; tiene **editores** dentro de **grupos**. Estos atajos te dan la experiencia Vim.

### Navegación

| Tecla | Acción |
|---|---|
| `H` | Editor anterior en el grupo activo |
| `L` | Editor siguiente en el grupo activo |
| `g t` | Siguiente editor (nativo de VSCodeVim, estilo `:tabnext`) |
| `g T` | Editor anterior (nativo de VSCodeVim, estilo `:tabprev`) |

> `H`/`L` son bindings de esta config y pisan el "top/bottom de pantalla" nativo de Vim.

### Cerrar

| Tecla | Acción |
|---|---|
| `<space> b d` | Cerrar editor actual |
| `<space> q` | Cerrar todos los editores |

---

## Terminal integrada

| Tecla | Acción |
|---|---|
| `<space> t t` | Toggle terminal |
| `<space> t f` | Focus terminal (si está oculta la abre) |
| `<space> t n` | Nueva terminal |

> Por defecto usa **Git Bash** en Windows. El resto de los profiles (PowerShell, CMD, Cmder) siguen disponibles en el selector.

---

## Diagnósticos

| Tecla | Acción |
|---|---|
| `] d` | Siguiente error / warning |
| `[ d` | Error / warning anterior |

Útil combinado con `<space> c a` en la línea del error para aplicar el quick fix.

---

## Comportamientos Vim activos

Definidos en `settings.json`:

| Setting | Efecto |
|---|---|
| `vim.easymotion` | `<leader><leader>` activa hints de salto |
| `vim.incsearch` | `/` y `?` filtran en vivo mientras escribís |
| `vim.hlsearch` | Matches de búsqueda quedan resaltados |
| `vim.useSystemClipboard` | Yank/delete usan el portapapeles del SO |
| `vim.useCtrlKeys` | Habilita bindings con Ctrl (`<C-r>`, `<C-d>`, `<C-u>`, etc.) |
| `vim.highlightedyank` | Flash visual breve al yankear |
| `vim.visualstar` | `*`/`#` en visual buscan la selección actual |
| `vim.sneak` | `s<char><char>` para salto de 2 chars |
| `vim.camelCaseMotion` | `w`/`b`/`e` respetan `camelCase` y `snake_case` |

---

## Teclas liberadas a VS Code

Estas combinaciones **no** las maneja Vim; van directo a VS Code:

| Tecla | Acción |
|---|---|
| `<C-a>` | Seleccionar todo |
| `<C-c>` | Copiar |
| `<C-v>` | Pegar (por eso no hay Visual-bloque con `<C-v>`) |
| `<C-f>` | Buscar en archivo |
| `<C-z>` | Undo nativo |
| `<C-p>` | Quick Open nativo |
| `<C-w>` | Cerrar editor (nativo de VS Code — cuidado, usá `<space> b d`) |

> Están declaradas en `vim.handleKeys` con `false`, así que VS Code las maneja en todos los modos.

---

## Workflows comunes

### Renombrar una variable en todo el proyecto

1. Cursor sobre el símbolo.
2. `<space> r n`.
3. Escribís el nuevo nombre, `<Enter>`.
4. Los cambios se aplican a todos los archivos (LSP rename).

### Moverte a una función, leer su tipo, volver

```
g d       →  ir a definición
K         →  ver hover con tipo/doc
<C-o>     →  volver a la posición anterior (Vim nativo)
```

### Comentar varias líneas

Visual: `V`, seleccionás las líneas, `gc`.
O en Normal: `gcc` en cada línea, o `gc2j` para la línea actual y las 2 siguientes.

### Duplicar y modificar

```
<space> d   →  duplica línea abajo
<c>w        →  entrar en change, palabra
... editás y volvés a Normal con jj
```

### Buscar usos y navegar

```
g r                     →  lista de referencias
<Enter> sobre la entrada
<C-o>                   →  volver
```

---

## VS Code desde cero

Si nunca usaste VS Code (o venís de otro editor puro), esto es lo mínimo para no perderse.

### Conceptos básicos

- **Workbench**: la ventana completa de VS Code. Incluye todo lo que ves.
- **Editor**: el área donde escribís código. Es un archivo abierto.
- **Grupo de editores** (editor group): un panel del editor. Podés tener varios a la vez (splits).
- **Sidebar**: la barra lateral (izquierda o derecha según tu config). Contiene el Explorer, Search, Source Control, Extensions, etc.
- **Panel**: la barra inferior. Contiene Terminal, Problems, Output, Debug Console.
- **Command Palette**: el centro de control. Toda acción de VS Code vive acá.

### Atajos esenciales sin mouse

| Atajo | Acción |
|---|---|
| `Ctrl+Shift+P` | Abrir Command Palette (lo más importante) |
| `Ctrl+P` | Quick Open: buscar y abrir un archivo por nombre |
| `Ctrl+Shift+F` | Buscar texto en todos los archivos (grep) |
| `Ctrl+Shift+E` | Mostrar / focus Explorer |
| `Ctrl+` ` (backtick) | Toggle terminal integrada |
| `Ctrl+B` | Toggle sidebar |
| `Ctrl+J` | Toggle panel inferior |
| `Ctrl+W` | Cerrar editor actual (Vim lo libera a VS Code — andá con cuidado, usá `<space> b d`) |

> `Ctrl+P` también está liberado y funciona nativo (Quick Open); si preferís mantener las manos en home row, `<space> f f` hace lo mismo.

### Settings: UI vs JSON

- **Settings UI** (`Ctrl+,`): buscador visual, ideal para descubrir opciones.
- **settings.json** (este archivo): control total, versionable, portable. Es lo que se sincroniza con el repo.

Para abrir settings.json directo: `Ctrl+Shift+P` → "Open User Settings (JSON)".

### Diff y source control

- `Ctrl+Shift+G` abre el panel de Source Control.
- `Ctrl+Shift+P` → "Git: Open Changes" para ver el diff del archivo actual.

### Sincronización

Las settings, extensions y keybindings se pueden sincronizar entre máquinas con una cuenta de Microsoft/GitHub. **Esta config está pensada para que NO necesites login** — la clonan, corren `setup.sh`/`setup.ps1` y listo.

### Atajos propios de esta config (resumen rápido)

| Tecla | Acción |
|---|---|
| `<space> f f` | Quick Open (buscar archivo) |
| `<space> f g` | Grep en archivos |
| `<space> e` | Toggle explorer |
| `<space> t t` | Toggle terminal |
| `<space> w` | Guardar |
| `H` / `L` | Editor anterior / siguiente |
| `g t` / `g T` | Tab siguiente / anterior |
| `<C-h/j/k/l>` | Foco entre grupos |

---

## Recursos

- [VSCodeVim](https://github.com/VSCodeVim/Vim) — repo oficial
- [`:help` desde Vim](https://vimhelp.org/) — referencia completa
- [Vim Adventures](https://vim-adventures.com/) — aprender jugando
- [Vim Cheat Sheet](https://vim.rtorr.com/) — cheatsheet imprimible
- [VS Code Docs](https://code.visualstudio.com/docs) — manual oficial
