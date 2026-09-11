function __kc_uptime --description 'Format the macOS system uptime'
    set --local boot_epoch \
        (string match --regex --groups-only 'sec = ([0-9]+)' \
            (command sysctl -n kern.boottime))

    if test -z "$boot_epoch"
        echo unknown
        return
    end

    set --local total_seconds (math (command date '+%s') - $boot_epoch)
    set --local days (math "floor($total_seconds / 86400)")
    set --local hours (math "floor(($total_seconds % 86400) / 3600)")
    set --local minutes (math "floor(($total_seconds % 3600) / 60)")
    set --local parts

    test $days -gt 0; and set --append parts $days'd'
    test $hours -gt 0; and set --append parts $hours'h'
    set --append parts $minutes'm'

    string join ' ' $parts
end
