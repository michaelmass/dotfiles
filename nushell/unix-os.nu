$env.PATH = ($env.PATH | append "/opt/homebrew/bin")
$env.PATH = ($env.PATH | append "/opt/homebrew/sbin")
$env.PATH = ($env.PATH | append "/opt/homebrew/opt/openjdk/bin")
$env.PATH = ($env.PATH | append "~/.nvm/versions/node/v18.12.1/bin")
$env.PATH = ($env.PATH | append "~/.cargo/bin")
$env.PATH = ($env.PATH | append "/usr/local/bin")
$env.PATH = ($env.PATH | append "~/.knode/bin")
$env.PATH = ($env.PATH | append "~/.kit/bin")
$env.PATH = ($env.PATH | append "~/.kenv/bin")
$env.PATH = ($env.PATH | append "~/.deno/bin")

alias code = ^open -b com.microsoft.VSCode
