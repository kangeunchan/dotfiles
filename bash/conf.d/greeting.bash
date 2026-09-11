__kc_uptime() {
    local boot_epoch total_seconds days hours minutes
    local parts=()

    boot_epoch=$(sysctl -n kern.boottime | sed -E 's/^\{ sec = ([0-9]+),.*/\1/')
    if [[ -z "$boot_epoch" || "$boot_epoch" == *[^0-9]* ]]; then
        printf 'unknown\n'
        return
    fi

    total_seconds=$(( $(date '+%s') - boot_epoch ))
    days=$(( total_seconds / 86400 ))
    hours=$(( total_seconds % 86400 / 3600 ))
    minutes=$(( total_seconds % 3600 / 60 ))

    (( days > 0 )) && parts+=("${days}d")
    (( hours > 0 )) && parts+=("${hours}h")
    parts+=("${minutes}m")

    printf '%s\n' "${parts[*]}"
}

__kc_write() {
    local role=$1
    local text=$2

    case "$role" in
        muted)     printf '%s' "$KC_ANSI_MUTED" ;;
        value)     printf '%s' "$KC_ANSI_VALUE" ;;
        accent)    printf '%s' "$KC_ANSI_ACCENT" ;;
        highlight) printf '%s' "$KC_ANSI_HIGHLIGHT" ;;
        *)         printf '%s' "$KC_ANSI_RESET" ;;
    esac

    printf '%s' "$text"
}

__kc_greeting() {
    local host_info=${HOSTNAME%%.*}
    local system_info="macOS $(sw_vers -productVersion) · $(uname -m)"
    local session_info="bash ${BASH_VERSION%%(*}"
    local uptime_info=$(__kc_uptime)
    local workdir_info=${PWD/#$HOME/\~}
    local now_info=$(date '+%Y-%m-%d · %H:%M')
    local tmux_session

    if [[ -n "$TMUX" ]] && command -v tmux >/dev/null 2>&1; then
        tmux_session=$(tmux display-message -p '#S' 2>/dev/null)
        [[ -n "$tmux_session" ]] && session_info+=" · tmux $tmux_session"
    fi

    printf '\n'

    __kc_write muted 'Welcome back, '
    __kc_write highlight "$USER"
    __kc_write muted '.'
    printf '\n'

    __kc_write muted 'You are on '
    __kc_write accent "$host_info"
    __kc_write muted ', running '
    __kc_write value "$system_info"
    __kc_write muted '.'
    printf '\n'

    __kc_write muted 'This Mac has been up for '
    __kc_write value "$uptime_info"
    __kc_write muted ', and your session is '
    __kc_write value "$session_info"
    __kc_write muted '.'
    printf '\n'

    __kc_write muted 'You are working in '
    __kc_write accent "$workdir_info"
    __kc_write muted ' at '
    __kc_write value "$now_info"
    __kc_write muted '.'
    printf '\n%s\n\n' "$KC_ANSI_RESET"
}

__kc_greeting
