function __kc_write --description 'Write greeting text using a semantic color' \
        --argument-names role text
    switch $role
        case muted
            set_color $__kc_color_muted
        case value
            set_color $__kc_color_foreground
        case accent
            set_color --bold $__kc_color_cyan
        case highlight
            set_color --bold $__kc_color_yellow
        case '*'
            set_color normal
    end

    printf '%s' "$text"
end
