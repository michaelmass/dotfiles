/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew install volllly/tap/rotz

cd ~/

if ! [ -d ~/.dotfiles ]; then
  git clone https://github.com/michaelmass/dotfiles.git .dotfiles
fi

cd .dotfiles
git pull

brew install fnm
eval "$(fnm env --use-on-cd)"

source ./bash/.zshrc

rotz link -f
rotz install
