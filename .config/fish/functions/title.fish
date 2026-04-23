function title -d "Set the terminal window title"
    if test (count $argv) -eq 0
        set -e _custom_title
    else
        set -g _custom_title "$argv"
    end
end
