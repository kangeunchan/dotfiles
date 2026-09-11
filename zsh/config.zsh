# ~/.config/zsh/config.zsh
# Responsibility-specific fragments are loaded in declaration order.
source "$HOME/.config/zsh/conf.d/theme.zsh"
source "$HOME/.config/zsh/conf.d/greeting.zsh"
source "$HOME/.config/zsh/conf.d/prompt.zsh"

# Open the Figma desktop app from the terminal.
figma() {
  open -a Figma "$@"
}

# Open the Notion desktop app from the terminal.
notion() {
  open -a Notion "$@"
}
