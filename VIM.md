# Vim en VS Code

Guía de referencia para usar VSCodeVim con esta configuración. Asume que conocés los básicos de Vim; el foco está en los atajos y comportamientos habilitados acá.

> **Leader key:** `<space>` — todas las combinaciones `<space> x` se escriben como `space` + `x` en modo Normal.

---

## Modos

| Modo | Cómo entrar | Cómo salir |
|---|---|---|
| Normal | `<Esc>` o `jj` desde Insert | — |
| Insert | `i`, `a`, `o`, `O`, `s`, etc. | `<Esc>` o `jj` |
| Visual | `v` (carácter), `V` (línea), `<C-v>` (bloque) | `<Esc>` o `jj` |
| Command-line | `:` (comandos ex) | `<Esc>` |
| Search | `/` o `?` | `<Esc>` |

`jj` mapeado desde Insert es la única forma rápida de volver a Normal sin mover la mano a `<Esc>`.

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
| `H` `M` `L` | Top / middle / bottom de la pantalla |
| `C-u` / `C-d` | Media página arriba / abajo |
| `C-b` / `C-f` | Página completa arriba / abajo |
| `C-y` / `C-e` | Scroll sin mover cursor |

> `w`/`b`/`e` se comportan con `camelCaseMotion`: en `getUserById` saltan entre `get` / `User` / `By` / `Id`. Idem para `snake_case`.

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

### Mover foco entre grupos (estilo tmux)

| Tecla | Acción |
|---|---|
| `<C-w> h` | Foco al panel izquierdo |
| `<C-w> l` | Foco al panel derecho |
| `<C-w> k` | Foco al panel superior |
| `<C-w> j` | Foco al panel inferior |

> Cada `Ctrl+w` espera la siguiente tecla; no se pisa con la navegación `h/j/k/l` pura.

### Splits y barras laterales

| Tecla | Acción |
|---|---|
| `s v` | Split vertical |
| `<space> e` | Toggle explorer |

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
| `<C-c>` | Copiar (en modo Normal va a Vim, en Insert/Visual sí copia) |
| `<C-v>` | Pegar (idem) |
| `<C-f>` | Buscar en archivo |
| `<C-z>` | Undo nativo |

> En Insert/Visual estas sí pasan a VS Code, así no perdés los atajos estándar al editar texto.

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

## Recursos

- [VSCodeVim](https://github.com/VSCodeVim/Vim) — repo oficial
- [`:help` desde Vim](https://vimhelp.org/) — referencia completa
- [Vim Adventures](https://vim-adventures.com/) — aprender jugando
- [Vim Cheat Sheet](https://vim.rtorr.com/) — cheatsheet imprimible
