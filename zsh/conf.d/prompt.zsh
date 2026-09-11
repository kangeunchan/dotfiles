__kc_git_prompt_text() {
    local branch suffix

    branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null) || return
    [[ -n "$(git status --porcelain --untracked-files=no 2>/dev/null)" ]] && suffix=' *'

    print -nr -- "git:${branch}${suffix}"
}

__kc_update_prompt() {
    local identity_segment path_segment git_segment git_info

    identity_segment="%B%F{$KC_COLOR_BACKGROUND}%K{$KC_COLOR_GREEN} %n@%m "
    path_segment="%F{$KC_COLOR_BACKGROUND}%K{$KC_COLOR_CYAN} %~ "
    git_info=$(__kc_git_prompt_text)

    if [[ -n "$git_info" ]]; then
        git_segment="%F{$KC_COLOR_FOREGROUND}%K{$KC_COLOR_PANEL} ${git_info} "
    fi

    PROMPT="${identity_segment}${path_segment}${git_segment}%f%k%b  "
}

setopt prompt_subst
autoload -Uz add-zsh-hook
add-zsh-hook precmd __kc_update_prompt
__kc_update_prompt
