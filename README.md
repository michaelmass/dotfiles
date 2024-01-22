# Dotfiles

> All the required files to setup a new desktop

## Requirements

Run the following commands:

Linux / MacOS

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/michaelmass/dotfiles/master/install.sh)"
```

Windows

```powershell
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/michaelmass/dotfiles/master/install.ps1'))
```

On windows there are some software that are not yet supported by scoop, so you will have to install them manually:

- [1password8](https://1password.com/downloads/windows/)
- [scriptkit](https://scriptkit.com/)
- [nordvpn](https://nordvpn.com/)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [linear](https://linear.app/download)
- [steam](https://store.steampowered.com/)
- [battle.net](https://us.shop.battle.net/en-us)
- [arc](https://arc.net/)
