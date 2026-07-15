# VS Code con Vim: comandos para cuando Vim "se apaga"

VSCodeVim **solo funciona dentro de un editor de texto**. En cualquier otro panel (terminal, explorer, settings, extensions, source control, command palette, etc.) las teclas van al widget nativo de VS Code, no a Vim. Esta guía cubre los atajos y comandos para moverte cuando Vim no está activo.

---

## El botón de pánico: Command Palette

Si te perdés en cualquier widget, esto te salva:

- **`Ctrl+Shift+P`** — abre la Command Palette
- Escribís lo que querés hacer (en español o inglés) y elegís
- **`Esc`** cierra la paleta y vuelve al foco anterior

Ejemplos de búsquedas útiles:
- "Close All Editors" → cerrar todo
- "Reopen Closed Editor" → reabrir pestaña cerrada
- "Focus Active Editor Group" → volver al editor
- "Toggle Terminal" → mostrar/ocultar terminal
- "Open Settings (JSON)" → abrir el `settings.json`

---

## Volver al editor siempre

| Atajo | Acción |
|---|---|
| `Ctrl+1` | Foco al primer grupo de editores (el de la izquierda) |
| `Ctrl+2` / `Ctrl+3` | Foco al segundo / tercer grupo |
| `Ctrl+K` `Ctrl+...` | Algunos focus especiales |
| `Ctrl+Shift+P` → "Focus Active Editor Group" | Vuelve al editor estés donde estés |
| `Esc` (en la mayoría de widgets) | Cierra el widget y vuelve al foco anterior |

> Con esta config Vim pisa `Ctrl+B`, `Ctrl+J`, `Ctrl+P` y `Ctrl+W` — usá la Command Palette o los atajos con `<leader>` para esas acciones.

---

## Escenarios comunes de "me perdí"

### Estoy en el terminal integrado y quiero volver al editor

| Acción | Atajo / Comando |
|---|---|
| Volver al editor | `Ctrl+1` o `Ctrl+Esc` |
| Ocultar terminal | `<space> t t` (toggle, también cierra el foco) |
| Crear nueva terminal | `<space> t n` |

> `Ctrl+Esc` no está bindeado por VS Code, pero podés mapearlo a "focusActiveEditorGroup" si lo necesitás.

### Estoy en el Explorer y quiero volver al editor

| Acción | Atajo |
|---|---|
| Volver al editor | `Ctrl+1` |
| Toggle sidebar | `Ctrl+B` (liberado por Vim, anda nativo) |

### Estoy en Source Control / Git panel y quiero volver

| Acción | Atajo |
|---|---|
| Volver al editor | `Ctrl+1` |
| Cerrar el panel | `Ctrl+J` (toggle) |

### Estoy en el panel de Extensions

| Acción | Atajo |
|---|---|
| Volver al editor | `Ctrl+1` |
| Buscar extensión | escribí el nombre en el cuadro de búsqueda |
| Instalar / desinstalar | click en el botón (no hay atajo estándar) |

### Estoy en Settings (UI)

| Acción | Atajo |
|---|---|
| Volver al editor | `Ctrl+1` |
| Buscar setting | empezá a escribir |
| Abrir settings.json | `Ctrl+Shift+P` → "Open User Settings (JSON)" |

### Estoy en la Command Palette

| Acción | Atajo |
|---|---|
| Cerrar | `Esc` |
| Navegar opciones | flechas o `Ctrl+N` / `Ctrl+P` |
| Ejecutar | `Enter` |

### Estoy en un diff (comparando archivos / viendo cambios git)

| Acción | Atajo |
|---|---|
| Volver a la vista normal | `Ctrl+1` |
| Navegar entre hunks | `F7` (next) / `Shift+F7` (prev) |
| Aceptar cambio | `Ctrl+Shift+P` → "Accept Merge Change" |
| Rechazar cambio | `Ctrl+Shift+P` → "Reject Merge Change" |

### Abrí un archivo y no tiene Vim / se ve raro

| Acción | Atajo / Comando |
|---|---|
| Reabrir el archivo (forzar reload) | `Ctrl+Shift+P` → "Revert File" |
| Reload de VS Code (por si VSCodeVim se trabó) | `Ctrl+Shift+P` → "Developer: Reload Window" |
| Desactivar/activar VSCodeVim | `Ctrl+Shift+P` → "Toggle Vim Mode" |

> Si Vim dejó de responder en un editor puntual, `:set nopaste` o un `:e!` (re-edit) suelen destrabarlo.

### Cerré una pestaña sin querer

| Acción | Atajo |
|---|---|
| Reabrir última pestaña cerrada | `Ctrl+Shift+T` |
| Ver lista de recientes | `<space> f r` (funciona con Vim activo) |

### Me fui a otra app y al volver Vim no responde

`Ctrl+Shift+P` → **"Developer: Reload Window"** — recarga VS Code sin perder estado.

---

## Atajos nativos de VS Code que NO pisa Vim

Estos funcionan siempre, estés donde estés:

| Atajo | Acción |
|---|---|
| `Ctrl+Shift+P` | Command Palette |
| `Ctrl+Shift+T` | Reabrir editor cerrado |
| `Ctrl+K` `Ctrl+S` | Atajos de teclado (keybindings.json) |
| `Ctrl+K` `Ctrl+T` | Cambiar color theme |
| `Ctrl+,` | Abrir Settings UI |
| `Ctrl+Shift+K` | Borrar línea (en editor, pisa `<space> x` en modo Vim) |
| `Ctrl+Shift+G` | Source Control panel |
| `Ctrl+Shift+X` | Extensions panel |
| `Ctrl+Shift+F` | Buscar en archivos |
| `Ctrl+Shift+H` | Reemplazar en archivos |
| `Alt+Left` / `Alt+Right` | Navegación history (atrás / adelante) |
| `Ctrl+Tab` | Switcher de editores abiertos (miniaturas) |
| `Ctrl+Shift+Tab` | Switcher inverso |

---

## Atajos chording (dos teclas)

VS Code tiene una sintaxis `Ctrl+K` `Ctrl+S` que significa "presioná `Ctrl+K`, soltá, `Ctrl+S`". Algunos útiles:

| Secuencia | Acción |
|---|---|
| `Ctrl+K` `Ctrl+S` | Abrir keybindings.json / editor visual |
| `Ctrl+K` `Ctrl+W` | Cerrar todo (sin guardar, cuidado) |
| `Ctrl+K` `Ctrl+C` | Comentario de línea (editor) |
| `Ctrl+K` `Ctrl+U` | Descomentar línea (editor) |
| `Ctrl+K` `F` | Cerrar carpeta / workspace |
| `Ctrl+K` `V` | Markdown preview al lado |

> El primero de la secuencia (ej. `Ctrl+K`) es "prefijo"; VS Code espera el segundo. Si te arrepentís, `Esc` cancela.

---

## ¿Vim funciona en otro lado?

Algunos widgets sí dejan pasar teclas Vim si el widget es un "tree" o lista:

| Widget | ¿Vim anda? | Notas |
|---|---|---|
| Editor de texto | Sí | Modo completo |
| Terminal integrada | No | Es una shell real (bash, PowerShell). Ahí usás los atajos de la shell. |
| Explorer (file tree) | Parcial | `j`/`k` funcionan, `o`/`Enter` abren, `Esc` vuelve al editor |
| Output / Problems panel | No | Usá `Ctrl+F` para buscar |
| Source Control (SCM) | No | Click + `Ctrl+Shift+P` |
| Extensions panel | No | Buscador visual |
| Settings UI | No | Buscador + clicks |
| Debug console | No | Shell REPL |
| Quick Open | Parcial | Escribís el nombre, flechas, `Enter` |
| Command Palette | Parcial | Escribís, flechas, `Enter` |

---

## Workflow típico de "salir y volver"

### Salir del editor a otra cosa y volver con un comando

```
1. Hago algo en el editor
2. <space> t t       →  abro la terminal
3. Corro el comando
4. <Esc>             →  salgo del modo insert de la terminal (si estaba en ella)
5. Ctrl+1            →  vuelvo al editor
```

### Perderme y querer volver al editor sin pensar

```
Ctrl+Shift+P  →  escribir "focus editor"  →  Enter
```

### Vim se trabó o dejó de responder

```
Ctrl+Shift+P  →  "Toggle Vim Mode"  →  Enter  →  mismo comando otra vez
```

Si no se arregla:

```
Ctrl+Shift+P  →  "Developer: Reload Window"  →  Enter
```

---

## Recursos

- [VS Code Keybindings](https://code.visualstudio.com/docs/getstarted/keybindings) — referencia oficial
- [VSCodeVim — Known Issues](https://github.com/VSCodeVim/Vim/wiki) — bugs y soluciones
- [Command Palette cheat sheet](https://code.visualstudio.com/docs/getstarted/tips-and-tricks) — tips oficiales
