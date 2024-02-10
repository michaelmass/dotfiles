# Update scoop if it's already installed, otherwise install it
if (Get-Command scoop -errorAction SilentlyContinue) {
  scoop update
} else {
  iwr -useb get.scoop.sh | iex
}

scoop bucket add extras
scoop bucket add versions
scoop bucket add volllly https://github.com/volllly/scoop-bucket

scoop install git
scoop install vcredist2022
scoop install sudo
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
