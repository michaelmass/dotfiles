$env.PNPM_HOME = $"($env.LOCALAPPDATA)/pnpm"

$env.GOPATH = $"($env.HOME)/go"

$env.Path = ($env.Path | append $env.PNPM_HOME)
$env.Path = ($env.Path | append "~/.deno/bin")
$env.Path = ($env.Path | append $"($env.GOPATH)/bin")
