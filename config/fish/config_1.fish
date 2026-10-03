if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -g fish_greeting

function fish_prompt
    echo -n ' '  # Espacio inicial
    set_color d787ff  # Color similar a 38;5;177 en Bash
    echo -n '>'
    set_color normal
    echo -n ' '  # Espacio final
end


export EDITOR=micro
cat ~/.config/wpg/sequences &

alias debloat='sudo xbps-remove -o && flatpak uninstall --unused'
#alias debloat='sudo xbps-remove -Rnso'
alias trash='sudo rm -rf /home/diener/.local/share/Trash'
# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
alias update='sudo xbps-install -Su && flatpak update'

export NO_AT_BRIDGE=1

set -Ux fish_user_paths $HOME/.cargo/bin $fish_user_paths

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /home/diener/.lmstudio/bin

fish_add_path /home/diener/.spicetify

if status is-interactive
    fastfetch
end
