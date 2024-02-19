$env.PNPM_HOME = $"($env.LOCALAPPDATA)/pnpm"

$env.Path = ($env.Path | append $env.PNPM_HOME)
$env.Path = ($env.Path | append "~/.deno/bin")
