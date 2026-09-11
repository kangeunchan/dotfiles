function fish_prompt --description 'Detailed segmented prompt matching the terminal theme'
    set --local git_info (__kc_git_prompt_text)

    __kc_prompt_segment \
        $__kc_color_green \
        $__kc_color_background \
        "$USER@"(prompt_hostname)

    __kc_prompt_segment \
        $__kc_color_cyan \
        $__kc_color_background \
        (prompt_pwd)

    if test -n "$git_info"
        __kc_prompt_segment \
            $__kc_color_panel \
            $__kc_color_foreground \
            "$git_info"
    end

    set_color normal
    printf ' '
end
