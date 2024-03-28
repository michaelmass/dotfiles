$env.PNPM_HOME = $"($env.HOME)/Library/pnpm"

$env.ANDROID_HOME = $"($env.HOME)/Library/Android/sdk"

let $paths = [
  $env.PNPM_HOME,
  "/opt/homebrew/bin",
  "/opt/homebrew/sbin",
  "/opt/homebrew/opt/openjdk/bin",
  "~/.nvm/versions/node/v18.12.1/bin",
  "~/.cargo/bin",
  "~/.knode/bin",
  "~/.kit/bin",
  "~/.deno/bin",
  "/usr/local/bin",
]

$env.PATH = ($env.PATH | prepend $paths)

alias code = ^open -b com.microsoft.VSCode
