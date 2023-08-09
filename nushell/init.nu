source ~/.oh-my-posh.nu
source ~/.zoxide.nu

def gfu [
  msg = "update"
  --pr (-p) = true
] {
  git add --all

  let $commit = (git commit -m $msg | complete)

  echo $commit.stdout

  if $commit.stderr? != "" and $commit.stderr? != null {
    error make {
      msg: $commit.stderr
    }
  }

  let $push = (git push | complete)

  if $push.exit_code == 1 {
    error make {
      msg: "push failed"
    }
  }

  if ($pr) {
    gh pr create --fill --web
  } else {
    gh pr view --web
  }
}

def grmb [] {
	git branch | lines | where ($it != "* master" and $it != "* main") | each {|br| git branch -D ($br | str trim) } | str trim
}

def grh [] {
  let $branch = (git branch --show-current)
  git reset --hard origin/$branch
}

alias exp = let-env

alias y = yarn
alias yd = yarn dev
alias yw = yarn watch
alias ys = yarn start
alias yt = yarn test

alias grh = git reset --hard HEAD
alias gco = git commit -am
alias gaa = git add --all
alias gf = git fetch
alias gp = git pull
alias gc = git checkout
alias gcb = git checkout -b
alias gcm = git checkout master
alias gcl = git clone
alias gs = git stash
alias gsp = git stash pop
alias gsd = git stash drop
alias gpm = git pull origin master
alias gpom = git pull origin master

alias ghv = gh repo view --web
alias ghprv = gh pr view --web

alias db = docker build .
alias dr = docker run

alias c = clear

alias tu = tilt up
alias td = tilt down

alias p = pnpm
alias ppnm = pnpm
alias pnp = pnpm
alias npn = pnpm
alias npmp = pnpm

alias npmlg = npm list -g --depth 0 # list global packages

alias code = ^open -b com.microsoft.VSCode
