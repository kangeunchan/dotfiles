# >>> mise:activate >>> managed by mise — do not edit between markers
mise activate fish | source
# <<< mise:activate <<<

# Open the Figma desktop app from the terminal.
function figma
    open -a Figma $argv
end

# Open the Notion desktop app from the terminal.
function notion
    open -a Notion $argv
end

# Open the Slack desktop app from the terminal.
function slack
    open -a Slack $argv
end

# Open the Claude desktop app from the terminal.
function claude
    open -a Claude $argv
end

# Open the Rectangle desktop app from the terminal.
function rectangle
    open -a Rectangle $argv
end

# Open the 1Password desktop app from the terminal.
function onepassword
    open -a 1Password $argv
end

# Open the Wireguard desktop app from the terminal.
function wireguard
    sudo /opt/homebrew/bin/bash /opt/homebrew/bin/wg-quick $argv
end