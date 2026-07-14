$env.PNPM_HOME = $"($env.HOME)/Library/pnpm"
$env.ANDROID_HOME = $"($env.HOME)/Library/Android/sdk"

$env.GOPATH = $"($env.HOME)/go"

let $paths = [
  $env.PNPM_HOME,
  $"($env.PNPM_HOME)/bin",
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
  "~/.kimi-code/bin",
]

$env.PATH = ($env.PATH | prepend $paths)

alias code = ^open -b com.microsoft.VSCode
