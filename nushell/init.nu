source ~/.oh-my-posh.nu
source ~/.zoxide.nu
source ~/os.nu

$env.K8S_NAMESPACE = "default"
$env.DAGGER_NO_NAG = "1"

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

def dotenv [
  file = ".env"
] {
  let $file = ([$file ".env"] | where ($it | path exists) | first)
  let $lines = (open --raw $file | lines | str trim | compact --empty | filter {|it| ($it | str starts-with "#" | not $in)})
  let $record = ($lines | split column "=" | reduce -f {} {|it, acc| $acc | upsert $it.column1 $it.column2 })
  return $record
}

def ghaipr [] {
  let $pr = (kit ai-pr-message | from json)
  gh pr create $"--title=($pr.title)" $"--body=($pr.body)" --web
}

def gfu [
  msg = "update"
  --pr (-p) = false
  --web (-w) = false
  --draft (-d) = false
  --skipci (-s)
] {
  git add --all

  let $msg = ([$msg (ternary $skipci " [skip ci]" "")] | str join)
  let $commit = (git commit -m $msg | complete)

  print $commit.stdout
  print $commit.stderr

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
    if ($web) {
      gh pr create --fill-first $"--draft=($draft)" --web
    }
  }
}

def gb [] {
  return (git branch --show-current | str trim)
}

def gbl [] {
  let $username = (git config user.name | str trim)
  return (git for-each-ref --sort=authorname --format "%(authorname) %(refname)" | grep $username | str replace -a $"($username) " "")
}

def grmb [] {
	git branch | lines | where ($it != "* master" and $it != "* main") | each {|br| git branch -D ($br | str trim) } | str trim
  git remote prune origin
}

def grhard [] {
  git add --all
  let $branch = gb
  print $"Resetting git to origin/($branch)"
  git reset --hard $"origin/($branch)"
}

def grhead [] {
  let $branch = gb
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
  --open = true
] {
  let repoWithOwner = ([$org, $repo] | path join)
  let target = ([$folder, $repoWithOwner] | where ($it != "") | first)
  let directory = ([$nu.home-path "Documents/dev" $target] | path join)
  gh repo clone $"($org)/($repo)" $directory

  if ($open) {
    code $directory
  }
}

alias nvm = fnm

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
alias gsc = git stash clear
alias gsd = git stash drop
alias gsp = git stash pop
alias glogjson = git log --pretty=format:'{"commit": "%H", "author": "%an <%ae>", "date": "%ad", "message": "%f"},' --date=iso

alias cc = pbcopy
alias pp = pbpaste

alias ghprv = gh pr view --web
alias ghv = gh repo view --web

def ghbv [] {
  gh repo view $"--branch=(gb)" --web
}

def ghprcreate [
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

def ghprls [
  --repo (-r) = ""
  --author (-a) = "@me"
] {
  gh pr list $"--repo=($repo)" $"--author=($author)"
}

def ghprmerge [
  pr = ""
  --repo (-r) = ""
] {
  gh pr merge $pr --squash $"--repo=($repo)"
}

def parse_pr [
  pr
  --org (-o) = ""
  --repo (-r) = ""
] {
  mut repo_name = $repo
  mut org_name = $org
  mut pr_number = $pr

  if ($pr | into string | str starts-with 'https://') {
    let parts = ($pr | str replace -r '^https://' '' | str replace -r '^github.com' '' | str trim -c '/' | split row '/')

    $org_name = ($parts | first)
    $repo_name = ($parts | get 1)
    $pr_number = ($parts | get 3)
  }

  if ($repo_name == "") {
    let parts = ($env.PWD | split row "/")

    $repo_name = ($parts | last)
    $org_name = ($parts | reverse | get 1)

    if ($repo_name == ".dotfiles") {
      $org_name = "michaelmass"
    }

    if ($repo_name == ".kenv") {
      $org_name = "michaelmass"
    }
  }

  # Ensure PR is a number
  $pr_number | into int

  return {
    org: $org_name,
    repo: $repo_name,
    pr: ($pr_number | into string)
  }
}

def getprojectdir [
  --org (-o) = ""
  --repo (-r) = ""
] {
  if ($repo == ".dotfiles") {
    return "~/.dotfiles"
  }

  if ($repo == ".kenv") {
    return "~/.kenv"
  }

  if ($repo == "test") {
    return "~/Documents/dev/test"
  }

  return ([$nu.home-path "Documents/dev" $org $repo] | path join)
}

def ghprcheck [
  pr
  --repo (-r) = ""
  --org (-o) = ""
] {
  let info = (parse_pr --org=($org) --repo=($repo) $pr)
  print $"Checkout PR ($info.pr) in ($info.org)/($info.repo)"

  let branch = (gh pr view $info.pr --json headRefName --jq .headRefName $"--repo=($info.org)/($info.repo)")
  print $"Branch is ($branch)"
  mkerr "Branch was not found" -c ($branch == "")

  let directory = (getprojectdir --org=($info.org) --repo=($info.repo))

  print $"Directory is ($directory)"

  if (not ($directory | path exists)) {
    ghrepoclone --org=($info.org) --open=false $info.repo
  }

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
alias tc = tilt ci

alias npmp = pnpm
alias npn = pnpm
alias p = pnpm
alias pd = pnpm dlx
alias dlx = pnpm dlx
alias pnp = pnpm
alias ppnm = pnpm
alias pnpmlg = pnpm list -g
alias pu = pnpm update --latest

alias ez = eza --color=always --long --icons=always --no-filesize --no-time --no-permissions --no-user

alias cat = bat

alias dr = dagger run deno run --no-lock --node-modules-dir=false -A
alias dprune = dagger core engine local-cache prune

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

def gfumerge [
  msg = "update"
  --draft (-d)
  --skipci (-s)
  ] {
  gfu -p true -w false --skipci=$skipci --draft=$draft $msg
  ghprmerge
  gclean
}

def lhf [] {
  gaa
  lefthook run format
  gaa
}

def lhc [] {
  gaa
  lefthook run pre-commit
  gaa
}

def new [
  filename
] {
  mkdir ($filename | path dirname)
  touch $filename
  code $filename
}

alias stodo = deno run --allow-run=rg,git,jq jsr:@michaelmass/stodo/cli search
alias stodom = deno run --allow-run=rg,git,jq jsr:@michaelmass/stodo/cli search -e --format pretty --jq "[.[] | select(.priority.value >= 5 and .priority.value < 8)]"
alias stodoh = deno run --allow-run=rg,git,jq jsr:@michaelmass/stodo/cli search -e --format pretty --jq "[.[] | select(.priority.value >= 8)]"

alias ghf = deno run -A jsr:@michaelmass/ghf/cli
alias ghfa = deno run -A jsr:@michaelmass/ghf/cli apply

clear
