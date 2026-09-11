function fish_greeting --description 'Show a themed system summary'
    set --local host_info (prompt_hostname)
    set --local system_info 'macOS '(command sw_vers -productVersion)' · '(command uname -m)
    set --local session_info 'fish '$version
    set --local uptime_info (__kc_uptime)
    set --local workdir_info (prompt_pwd)
    set --local now_info (command date '+%Y-%m-%d · %H:%M')

    if set -q TMUX; and type -q tmux
        set --local tmux_session (command tmux display-message -p '#S' 2>/dev/null)
        if test -n "$tmux_session"
            set session_info "$session_info · tmux $tmux_session"
        end
    end

    echo

    __kc_write muted 'Welcome back, '
    __kc_write highlight $USER
    __kc_write muted '.'
    echo

    __kc_write muted 'You are on '
    __kc_write accent $host_info
    __kc_write muted ', running '
    __kc_write value $system_info
    __kc_write muted '.'
    echo

    __kc_write muted 'This Mac has been up for '
    __kc_write value $uptime_info
    __kc_write muted ', and your session is '
    __kc_write value $session_info
    __kc_write muted '.'
    echo

    __kc_write muted 'You are working in '
    __kc_write accent $workdir_info
    __kc_write muted ' at '
    __kc_write value $now_info
    __kc_write muted '.'
    echo

    set_color normal
    echo
end
