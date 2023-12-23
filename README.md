# Dotfiles

> All the required files to setup a new desktop

## Requirements

1. Start by installing a package manager to script the rest of the installation of other tools:

- Homebrew (MacOS)
- Linuxbrew (linux)
- Scoop (Windows)

2. Then, install rust which will give access to cargo:

Linux / MacOS

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install volllly/tap/rotz
```

Windows

In powershell run:

```
iwr -useb get.scoop.sh | iex
scoop install git
scoop bucket add extras
scoop install vcredist2022
scoop bucket add volllly https://github.com/volllly/scoop-bucket
scoop install volllly/rotz
scoop bucket add tilt-dev https://github.com/tilt-dev/scoop-bucket
```

Make sure to setup rust correctly in your path and terminal

3. Use `rotz` to link && install all the dotfiles

```
rotz link
rotz install
```

On windows there are some software that are not yet supported by scoop, so you will have to install them manually:

- [1password8](https://1password.com/downloads/windows/)
- [scriptkit](https://scriptkit.com/)
- [nordvpn](https://nordvpn.com/)
