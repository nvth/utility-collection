Command Prompt aliases (Linux-style, e.g., `ls` instead of `dir`)

Quick setup (recommended)
1. Double-click `setup-aliases.bat`.

This will:
- Create `C:\alias\cmd.cmd` with only the `ls` alias.
- Import `autorun-hkcu.reg` so `cmd` auto-loads aliases.

Add more aliases
Edit `C:\alias\cmd.cmd` and add more `DOSKEY` lines.

Example `cmd.cmd`:
@echo off
DOSKEY ls=dir /B $*

Manual setup (optional)
1. Create `C:\alias\cmd.cmd` with your `DOSKEY` commands.
2. Import `autorun-hkcu.reg` (double-click), or:
   - Open Registry Editor (`regedit`).
   - Go to `HKEY_CURRENT_USER\Software\Microsoft\Command Processor`.
   - Add a String Value named `AutoRun` with value `C:\alias\cmd.cmd`.

Windows 10 / 11 (optional, system-wide)
Repeat the `AutoRun` value under:
`HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Command Processor`

If you do not see `Command Processor`, create the key with that exact name.
