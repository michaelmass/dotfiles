# Dotfiles

> All the required files to setup a new desktop by installing the required software and setting up the configuration files.

## Requirements

Run the following commands:

Linux / MacOS

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/michaelmass/dotfiles/master/install.sh)"
```

Also, for setting configuration see:
[Set up a Mac in 2024](https://www.youtube.com/watch?v=GK7zLYAXdDs)

Windows

```powershell
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/michaelmass/dotfiles/master/install.ps1'))
```
