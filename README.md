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
brew tap homebrew/cask-fonts
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

3. Install `rotz`

```
cargo install rotz
```

## Linking & Installing

To link all the dotfiles, run the following command:

```
rotz link
```

To install all the packages, run the following command:

```
rotz install
```
