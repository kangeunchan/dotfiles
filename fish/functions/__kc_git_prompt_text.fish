function __kc_git_prompt_text --description 'Build Git information for the prompt'
    set --local branch (command git symbolic-ref --quiet --short HEAD 2>/dev/null)
    test -n "$branch"; or return

    set --local suffix
    set --local changes (command git status --porcelain --untracked-files=no 2>/dev/null)
    if test (count $changes) -gt 0
        set suffix ' *'
    end

    printf 'git:%s%s' $branch $suffix
end
