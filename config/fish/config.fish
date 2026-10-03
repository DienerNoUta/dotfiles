set -g fish_greeting

function fish_prompt
    echo -n ' '
    set_color d787ff
    echo -n '>'
    set_color normal
    echo -n ' '
end

# Variables globales
set -gx EDITOR micro
set -gx VISUAL micro
set -gx XDG_SESSION_TYPE wayland
set -gx NO_AT_BRIDGE 1

# Aliases
alias update="paru -Syu"
alias trash='rm -rf ~/.local/share/Trash/files/* ~/.local/share/Trash/info/*'

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

set -Ux fish_user_paths $HOME/.cargo/bin $fish_user_paths

#
function extract
    if test (count $argv) -lt 1
        echo "📦 Usage: extract <archive> [destination]"
        return 1
    end

    set file $argv[1]

    if test (count $argv) -ge 2
        set dest $argv[2]
    else
        set dest .
    end

    if not test -f "$file"
        echo "❌ File does not exist: $file"
        return 1
    end

    mkdir -p "$dest"

    echo "📦 Extracting: $file"
    echo "📁 Destination: $dest"

    7z x "$file" "-o$dest" -bsp1

    if test $status -eq 0
        echo "✅ Extraction completed successfully!"
    else
        echo "❌ Extraction failed!"
        return 1
    end
end

function debloat
    set orphans (pacman -Qtdq)

    if test (count $orphans) -gt 0
        sudo pacman -Rns $orphans
    else
        echo "nothing to debloat"
    end
end

function backup
    set backup_dir "$HOME/.backup"
    mkdir -p "$backup_dir"

    read -P "Backup name: " filename

    if test -z "$filename"
        echo "No backup name specified."
        return 1
    end

    set filepath "$backup_dir/$filename"

    xbps-query -l | awk '{print $2}' | sed -E 's/-[0-9][0-9A-Za-z._-]*$//' | sort -u > "$filepath"

    echo "Package list saved to $filepath"
end


function restore
    set backup_dir "$HOME/.backup"

    if not test -d "$backup_dir"
        echo "Backup directory not found: $backup_dir"
        return 1
    end

    echo "Available backups:"
    echo ""

    for file in $backup_dir/*
        if test -f "$file"
            basename "$file"
        end
    end

    echo ""

    read -P "Backup name: " filename

    if test -z "$filename"
        echo "No backup name specified."
        return 1
    end

    set backup_file "$backup_dir/$filename"
    set current_file "$backup_dir/.current"

    if not test -f "$backup_file"
        echo "Backup not found: $backup_file"
        return 1
    end

    echo "Saving current package list..."

    xbps-query -l | awk '{print $2}' | sed -E 's/-[0-9][0-9A-Za-z._-]*$//' | sort -u > "$current_file"

    set to_install (comm -23 "$backup_file" "$current_file")
    set to_remove (comm -13 "$backup_file" "$current_file")

    echo ""
    echo "Packages to install:"

    if test (count $to_install) -gt 0
        printf '  %s\n' $to_install
    else
        echo "  None"
    end

    echo ""
    echo "Packages to remove:"

    if test (count $to_remove) -gt 0
        printf '  %s\n' $to_remove
    else
        echo "  None"
    end

    echo ""

    read -P "Continue? [y/N] " confirm

    if test "$confirm" != y
        rm -f "$current_file"
        echo "Cancelled."
        return 0
    end

    if test (count $to_install) -gt 0
        echo "Installing packages..."
        sudo xbps-install -y $to_install
    end

    if test (count $to_remove) -gt 0
        echo "Removing packages..."
        sudo xbps-remove -y $to_remove
    end

    rm -f "$current_file"

    echo ""
    echo "Restore complete."
end
