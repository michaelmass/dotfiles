if (Get-Command scoop -errorAction SilentlyContinue) {
  scoop update
} else {
  iwr -useb get.scoop.sh | iex
}

scoop install git
scoop bucket add extras
scoop install vcredist2022
scoop install sudo
scoop bucket add volllly https://github.com/volllly/scoop-bucket
scoop install volllly/rotz
cd $env:USERPROFILE

if (Test-Path ./.dotfiles) {
  cd .dotfiles
  git pull
} else {
  git clone https://github.com/michaelmass/dotfiles.git .dotfiles
  cd .dotfiles
}

sudo rotz link -f
rotz install
