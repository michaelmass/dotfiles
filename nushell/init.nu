source ~/.oh-my-posh.nu
source ~/.zoxide.nu
source ~/os.nu

$env.K8S_NAMESPACE = "default"

def mkerr [
  msg
  --cond (-c) = true
] {
  if ($cond) {
    error make {
      msg: $msg
    }
  }
}

def ternary [
  cond
  true
  false
] {
  if $cond {
    return $true
  } else {
    return $false
  }
}

def gfu [
  msg = "update"
  --pr (-p) = false
  --web (-w) = true
  --draft (-d) = false
  --skipci (-s)
] {
  git add --all

  let $msg = ([$msg (ternary $skipci " [skip ci]" "")] | str join)
  let $commit = (git commit -m $msg | complete)

  echo $commit.stdout

  if $commit.stderr? != "" and $commit.stderr? != null {
    mkerr $commit.stderr
  }

  if $commit.exit_code == 1 and not ($commit.stdout | str contains "nothing to commit")  {
    mkerr "commit failed"
  }

  let $push = (git push | complete)
  mkerr "push failed" -c ($push.exit_code == 1)

  if ($pr) {
    gh pr create --fill-first $"--draft=($draft)"

    if ($web) {
      gh pr view --web
    }
  } else {
    gh pr create --fill-first $"--draft=($draft)" --web
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
  let repoWithOwner = ([$org, $repo] | path join)
  let target = ([$folder, $repoWithOwner] | where ($it != "") | first)
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
  let repoWithOwner = ([$org, $repo] | path join)
  let target = ([$folder, $repoWithOwner] | where ($it != "") | first)
  let directory = ([$nu.home-path "Documents/dev" $target] | path join)
  gh repo clone $"($org)/($repo)" $directory
  code $directory
}

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

def ghpropen [
  --draft (-d) = false
  --web (-w) = true
] {
  gh pr create --fill-first $"--draft=($draft)"

  if ($web) {
    gh pr view --web
  }
}

def ghprapprove [
  pr
  --repo (-r) = ""
  --msg (-m) = "LGTM"
] {
  gh pr review $pr $"--repo=($repo)" --approve --body $""($msg)""
}

def ghprmerge [
  pr = ""
  --repo (-r) = ""
] {
  gh pr merge $pr --squash $"--repo=($repo)"
}

def ghprcheck [
  pr
  --repo (-r) = ""
] {
  let branch = (gh pr view $pr --json headRefName --jq .headRefName $"--repo=($repo)")
  echo $"Branch is ($branch)"
  mkerr "Branch was not found" -c ($branch == "")

  let directory = ternary ($repo == "") $env.PWD ([$nu.home-path "Documents/dev" $repo] | path join)

  echo $"Directory is ($directory)"
  mkerr "Directory does not exist" -c (not ($directory | path exists))

  cd $directory
  git fetch
  git checkout $branch
  git pull
  code $directory
}

alias docb = docker build .
alias docr = docker run

alias c = clear

alias gor = go run .
alias gob = go build .

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

alias k = kubectl --namespace $env.K8S_NAMESPACE

alias h = helm --namespace $env.K8S_NAMESPACE
alias hls = helm ls --namespace $env.K8S_NAMESPACE
alias hup = helm upgrade --namespace $env.K8S_NAMESPACE --install --atomic --create-namespace --cleanup-on-fail
alias hdep = helm dependency build

def --env kns [
  namespace
] {
  $env.K8S_NAMESPACE = $namespace
}

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
  --draft (-d)
  --skipci (-s)
  ] {
  gcb $branch
  gfu -p true -w $web --skipci=$skipci --draft=$draft $msg
}

def gcfumerge [
  msg = "update"
  --branch (-b) = "mm-update"
  --draft (-d)
  --skipci (-s)
  ] {
  gcfu -w false -b $branch --skipci=$skipci --draft=$draft $msg
  ghprmerge
  gclean
}

def new [
  filename
] {
  mkdir ($filename | path dirname)
  touch $filename
  code $filename
}

clear
