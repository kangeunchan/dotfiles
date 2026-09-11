__kc_git_prompt_text() {
    local branch suffix

    branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null) || return
    [[ -n "$(git status --porcelain --untracked-files=no 2>/dev/null)" ]] && suffix=' *'

    printf 'git:%s%s' "$branch" "$suffix"
}

__kc_prompt_segment() {
    local background=$1
    local foreground=$2
    local text=$3

    printf '\\[\\e[1;38;2;%s;48;2;%sm\\] %s ' "$foreground" "$background" "$text"
}

__kc_update_prompt() {
    local host_info=${HOSTNAME%%.*}
    local workdir_info=${PWD/#$HOME/\~}
    local git_info=$(__kc_git_prompt_text)

    PS1=$(__kc_prompt_segment "$KC_RGB_GREEN" "$KC_RGB_BACKGROUND" "$USER@$host_info")
    PS1+=$(__kc_prompt_segment "$KC_RGB_CYAN" "$KC_RGB_BACKGROUND" "$workdir_info")

    if [[ -n "$git_info" ]]; then
        PS1+=$(__kc_prompt_segment "$KC_RGB_PANEL" "$KC_RGB_FOREGROUND" "$git_info")
    fi

    PS1+='\[\e[0m\]  '
}

case ";${PROMPT_COMMAND:-};" in
    *';__kc_update_prompt;'*) ;;
    *) PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }__kc_update_prompt" ;;
esac

__kc_update_prompt
