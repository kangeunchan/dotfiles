# ~/.config/bash/config.bash
# Responsibility-specific fragments are loaded in declaration order.
[[ $- == *i* ]] || return

# Hide macOS's legacy Bash migration notice.
export BASH_SILENCE_DEPRECATION_WARNING=1

source "$HOME/.config/bash/conf.d/theme.bash"
source "$HOME/.config/bash/conf.d/greeting.bash"
source "$HOME/.config/bash/conf.d/prompt.bash"
