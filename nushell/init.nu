source ~/.oh-my-posh.nu
source ~/.zoxide.nu
source ~/os.nu

$env.EDITOR = "code"
$env.KIT_EDITOR = "code"

def gfu [
  msg = "update"
  --pr (-p) = false
  --web (-w) = true
  --skipci (-s) = false
] {
  git add --all

  let $skip_message = (if $skipci { ' [skip ci]' } else { '' })
  let $commit = (git commit -m ([$msg $skip_message] | str join) | complete)

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

    if ($web) {
      gh pr view --web
    }
  } else {
    gh pr create --fill-first --web
  }
}

def grmb [] {
	git branch | lines | where ($it != "* master" and $it != "* main") | each {|br| git branch -D ($br | str trim) } | str trim
  git remote prune origin
}

def grhard [] {
  git add --all
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

def ghreponew [
  repo
  --org (-o) = "michaelmass"
  --private (-p) = true
  --folder (-f) = ""
] {
  let target = ([$folder, $repo] | where ($it != "") | first)
  let directory = ([$nu.home-path "Documents/dev" $target] | path join)
  gh repo create --add-readme $"--private=($private)" $"($org)/($repo)"
  gh repo clone $"($org)/($repo)" $directory
  code $directory
}

def ghrepoclone [
  repo
  --org (-o) = "michaelmass"
  --folder (-f) = ""
] {
  let target = ([$folder, $repo] | where ($it != "") | first)
  let directory = ([$nu.home-path "Documents/dev" $target] | path join)
  gh repo clone $"($org)/($repo)" $directory
  code $directory
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
alias glogjson = git log --pretty=format:'{"commit": "%H", "author": "%an <%ae>", "date": "%ad", "message": "%f"},' --date=iso

alias ghprv = gh pr view --web
alias ghv = gh repo view --web
def ghprmerge [] {
  gh pr merge --squash
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
alias pd = pnpm dlx
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
  --web (-w) = true
  --skipci (-s) = false
  ] {
  gcb $branch
  gfu -p true -w $web -s $skipci $msg
}

def gcfumerge [
  msg = "update"
  --branch (-b) = "mm-update"
  --skipci (-s) = false
  ] {
  gcfu -w false -b $branch -s $skipci $msg
  ghprmerge
}

def new [
  filename
] {
  mkdir ($filename | path dirname)
  touch $filename
  code $filename
}

clear
