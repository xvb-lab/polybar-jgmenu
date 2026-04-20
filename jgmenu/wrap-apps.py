#!/usr/bin/env python3
import subprocess, signal

signal.signal(signal.SIGPIPE, signal.SIG_DFL)

try:
    out = subprocess.check_output(['jgmenu_run', 'apps'], text=True)
    for line in out.splitlines():
        if line.startswith('^') or not line.strip():
            print(line)
            continue
        parts = line.split(',')
        if len(parts) < 2:
            print(line)
            continue
        name = parts[0]
        cmd  = parts[1]
        icon = parts[2] if len(parts) > 2 and parts[2] else 'applications-other'
        if cmd.startswith('^checkout('):
            print(line)
            continue
        wrapped = f'~/.config/jgmenu/runapp.sh "{name}" "{icon}" -- {cmd}'
        print(f'{name},{wrapped},{icon}')
except BrokenPipeError:
    pass
