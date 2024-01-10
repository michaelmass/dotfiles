source ~/.oh-my-posh.nu
source ~/.zoxide.nu
source ~/os.nu

$env.EDITOR = "code"
$env.KIT_EDITOR = "code"

def gfu [
  msg = "update"
  --pr (-p) = false
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
    gh pr create --fill-first
  } else {
    gh pr create --fill-first --web
  }
}

def grmb [] {
	git branch | lines | where ($it != "* master" and $it != "* main") | each {|br| git branch -D ($br | str trim) } | str trim
  git remote prune origin
}

def grhard [] {
  let $branch = (git branch --show-current | str trim)
  print $"Resetting git to origin/($branch)"
  git reset --hard $"origin/($branch)"
}

def grhead [] {
  let $branch = (git branch --show-current | str trim)
  print $"Resetting git to origin/($branch)"
  git reset $"origin/($branch)"
}

def gs [] {
  git add --all
  git stash
}

alias exp = let-env

alias y = yarn
alias yd = yarn dev
alias ys = yarn start
alias yt = yarn test
alias yw = yarn watch

alias gaa = git add --all
alias gcb = git checkout -b
alias gcl = git clone
alias gcm = git checkout master
alias gco = git commit -am
alias gf = git fetch
alias gp = git pull
alias gpm = git pull origin master
alias gpom = git pull origin master
alias grmrf = git clean -fxd
alias gsd = git stash drop
alias gsp = git stash pop

alias ghprv = gh pr view --web
alias ghv = gh repo view --web
def ghprmerge [] {
  gh pr merge --squash --auto
  gclean
}

alias docb = docker build .
alias docr = docker run

alias c = clear

alias td = tilt down
alias tu = tilt up

alias npmp = pnpm
alias npn = pnpm
alias p = pnpm
alias pnp = pnpm
alias ppnm = pnpm
alias pnpmlg = pnpm list -g

alias cat = bat

alias dr = dagger run deno run -A

alias npmlg = npm list -g --depth 0 # list global packages

alias bottom = btm

def gclean [] {
  gcm
  gf
  gp
  grmb
}

def gc [
  branch
] {
  git checkout $branch
  gp
}

def gcfu [
  msg = "update"
  --branch (-b) = "mm-update"
] {
  gcb $branch
  gfu -p true $msg
}

def gcfumerge [
  msg = "update"
  --branch (-b) = "mm-update"
] {
  gcfu -b $branch $msg
  ghprmerge
}

clear
