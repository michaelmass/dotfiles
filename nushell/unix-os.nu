$env.PNPM_HOME = $"($env.HOME)/Library/pnpm"
$env.ANDROID_HOME = $"($env.HOME)/Library/Android/sdk"

load-env (/opt/homebrew/bin/fnm env --shell bash | lines | str replace 'export ' '' | str replace -a '"' '' | split column = | rename name value | where name != "FNM_ARCH" and name != "PATH" | reduce -f {} {|it, acc| $acc | upsert $it.name $it.value })

let $paths = [
  $env.PNPM_HOME,
  "/opt/homebrew/bin",
  "/opt/homebrew/sbin",
  "/opt/homebrew/opt/openjdk/bin",
  "~/.cargo/bin",
  "~/.kit/bin",
  "~/.deno/bin",
  "/usr/local/bin",
  $"($env.FNM_MULTISHELL_PATH)/bin",
]

$env.PATH = ($env.PATH | prepend $paths)

alias code = ^open -b com.microsoft.VSCode
