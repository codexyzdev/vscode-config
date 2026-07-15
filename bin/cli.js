#!/usr/bin/env node
const { spawn } = require('child_process');
const path = require('path');
const fs = require('fs');
const os = require('os');

const SCRIPT_DIR = path.resolve(__dirname, '..');
const isWindows = os.platform() === 'win32';

const HELP = `Uso: vscode-config [comando] [opciones]

Comandos:
  (sin comando)   Instalar la config (hace backup antes, pide confirmacion)
  restore         Restaurar el backup mas reciente (pide confirmacion)
  help            Mostrar esta ayuda

Ejemplos:
  vscode-config
  vscode-config -y
  vscode-config restore
  vscode-config restore 2026-07-14_203000
  vscode-config restore -y

Opciones (despues del comando):
  -y, --yes, -Force         No pedir confirmacion
  -Timestamp <id>           Backup especifico (PowerShell)
  <timestamp>               Backup especifico (bash)
`;

let action = process.argv[2];
let restArgs = process.argv.slice(3);

if (action === 'help' || action === '--help' || action === '-h' || action === '?') {
    console.log(HELP);
    process.exit(0);
}

const skipConfirmFlags = ['-y', '--yes', '-Force'];
if (action && skipConfirmFlags.includes(action)) {
    restArgs = [action, ...restArgs];
    action = undefined;
}

let scriptFile;
if (action === 'restore') {
    scriptFile = isWindows ? 'restore.ps1' : 'restore.sh';
} else if (action === undefined || action === 'install' || action === 'setup') {
    scriptFile = isWindows ? 'setup.ps1' : 'setup.sh';
} else {
    console.error(`Comando desconocido: ${action}\n`);
    console.log(HELP);
    process.exit(1);
}

const scriptPath = path.join(SCRIPT_DIR, scriptFile);
if (!fs.existsSync(scriptPath)) {
    console.error(`Error: script no encontrado: ${scriptPath}`);
    process.exit(1);
}

let proc;
if (isWindows) {
    proc = spawn('powershell.exe', [
        '-NoProfile',
        '-ExecutionPolicy', 'Bypass',
        '-File', scriptPath,
        ...restArgs
    ], { stdio: 'inherit', cwd: SCRIPT_DIR });
} else {
    proc = spawn('bash', [scriptPath, ...restArgs], {
        stdio: 'inherit', cwd: SCRIPT_DIR
    });
}

proc.on('exit', (code) => process.exit(code ?? 0));
proc.on('error', (err) => {
    console.error(`Error al ejecutar ${scriptFile}: ${err.message}`);
    process.exit(1);
});
