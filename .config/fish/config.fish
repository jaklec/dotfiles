if status is-interactive
    # Commands to run in interactive sessions can go here
    fzf_key_bindings

    set -gx FZF_DEFAULT_COMMAND 'rg --files'
    set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
    set -gx FZF_ALT_C_COMMAND "fd --type directory . $HOME"
    set -gx FZF_ALT_C_OPTS "--preview 'tree -C {} | head -200'"
    set -gx FZF_CTRL_T_OPTS "--preview 'highlight -O ansi -l {} 2> /dev/null'"

    source ~/.aliases

    #fnm env | source

    if test (tty) = /dev/tty1
        sway
    end
end
