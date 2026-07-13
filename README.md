# VS Code Config

Mi configuración personal de VS Code — portable, sin login, lista en un solo comando.

## Requisitos

- [VS Code](https://code.visualstudio.com/) instalado y con `code` en el PATH

## Uso

```bash
git clone https://github.com/tu-usuario/vscode-config.git
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

## Atajos de Vim incluidos

| Tecla | Acción |
|---|---|
| `<space> w` | Guardar archivo |
| `<space> f` | Formatear documento |
| `g d` | Ir a definición |
| `g R` | Renombrar símbolo |
| `K` | Mostrar documentación |
| `Ctrl+h/j/k/l` | Navegar entre paneles |
