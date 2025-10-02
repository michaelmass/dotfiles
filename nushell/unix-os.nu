$env.PNPM_HOME = $"($env.HOME)/Library/pnpm"
$env.ANDROID_HOME = $"($env.HOME)/Library/Android/sdk"

$env.GOPATH = $"($env.HOME)/go"

let $paths = [
  $env.PNPM_HOME,
  $"($env.GOPATH)/bin",
  "/opt/homebrew/bin",
  "/opt/homebrew/sbin",
  "/opt/homebrew/opt/openjdk/bin",
  "~/.cargo/bin",
  "~/.kit/bin",
  "~/.deno/bin",
  "~/.bun/bin",
  "/usr/local/bin",
  "/usr/local/sbin",
  "/usr/local/opt/openjdk/bin",
  "~/.local/bin",
  "~/.local/sbin",
]

$env.PATH = ($env.PATH | prepend $paths)

load-env (fnm env --shell bash | lines | str replace 'export ' '' | str replace -a '"' '' | split column '=' | rename name value | where name != "FNM_ARCH" and name != "PATH" | reduce -f {} {|it, acc| $acc | upsert $it.name $it.value })

$env.PATH = ($env.PATH | prepend $"($env.FNM_MULTISHELL_PATH)/bin")

alias code = ^open -b com.microsoft.VSCode
