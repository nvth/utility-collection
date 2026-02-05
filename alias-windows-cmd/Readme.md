Command Prompt aliases (Linux-style, e.g., `ls` instead of `dir`)

Quick setup (recommended)
1. Double-click `setup-aliases-full.cmd` for the current user.
2. For all users (requires Administrator), run:
   `setup-aliases-full.cmd /all`

What it does
- Creates `C:\alias\cmd.cmd` with DOSKEY aliases.
- Generates wrapper commands in `%USERPROFILE%\.cmd-aliases\bin` (current user).
- Generates wrapper commands in `C:\ProgramData\cmd-aliases\bin` (all users).
- Sets Command Prompt AutoRun in `HKEY_CURRENT_USER\Software\Microsoft\Command Processor` (current user).
- Sets Command Prompt AutoRun in `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Command Processor` (all users).

Add or change aliases
Edit `C:\alias\cmd.cmd` and add more `DOSKEY` lines.

Uninstall
- Run `uninstall-aliases.cmd` to remove AutoRun and alias files.
