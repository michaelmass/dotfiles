/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
yes | brew install volllly/tap/rotz

cd ~/

if ! [ -d ~/.dotfiles ]; then
  git clone https://github.com/michaelmass/dotfiles.git .dotfiles
fi

cd .dotfiles
git pull

source ./bash/.zshrc

rotz link -f
rotz install
