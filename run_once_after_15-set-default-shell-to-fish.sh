#!/bin/sh
set -eu

if command -v brew >/dev/null 2>&1; then
    brew_path="$(command -v brew)"
elif [ -x /opt/homebrew/bin/brew ]; then
    brew_path=/opt/homebrew/bin/brew
elif [ -x /usr/local/bin/brew ]; then
    brew_path=/usr/local/bin/brew
elif [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
    brew_path=/home/linuxbrew/.linuxbrew/bin/brew
else
    echo "brew was not found; Fish cannot be configured as the login shell." >&2
    exit 1
fi

eval "$("$brew_path" shellenv)"

if ! command -v fish >/dev/null 2>&1; then
    echo "Fish was not installed by Homebrew." >&2
    exit 1
fi

fish_path="$(command -v fish)"
current_user="$(id -un)"

if ! grep -Fqx "$fish_path" /etc/shells; then
    if ! command -v sudo >/dev/null 2>&1; then
        echo "sudo is required to add $fish_path to /etc/shells." >&2
        exit 1
    fi

    printf '%s\n' "$fish_path" | sudo tee -a /etc/shells >/dev/null
fi

case "$(uname -s)" in
    Darwin)
        current_shell="$(dscl . -read "/Users/$current_user" UserShell | awk '{print $2}')"
        ;;
    *)
        current_shell="$(getent passwd "$current_user" | cut -d: -f7)"
        ;;
esac

if [ "$current_shell" != "$fish_path" ]; then
    sudo chsh -s "$fish_path" "$current_user"
fi
