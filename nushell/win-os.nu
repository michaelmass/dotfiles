$env.PNPM_HOME = $"($env.LOCALAPPDATA)/pnpm"

$env.PATH = ($env.PATH | append $env.PNPM_HOME)
$env.PATH = ($env.PATH | append "~/.deno/bin")
