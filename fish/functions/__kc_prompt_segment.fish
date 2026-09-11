function __kc_prompt_segment --description 'Render one colored prompt segment' \
        --argument-names background foreground text
    set_color --bold $foreground --background $background
    printf ' %s ' "$text"
end
