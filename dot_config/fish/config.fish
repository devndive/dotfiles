# Disable mise auto-activation (must be set before conf.d files load)
set -gx MISE_FISH_AUTO_ACTIVATE 0

if status is-interactive
    # Commands to run in interactive sessions can go here

    starship init fish | source

    # Add mise shims to PATH for fast tool access
    set -gx PATH $HOME/.local/share/mise/shims $PATH

    # Lazy load full mise shell integration when needed
    function mise --description "Lazy load mise"
        functions -e mise  # Remove this wrapper function
        /opt/homebrew/opt/mise/bin/mise activate fish | source  # Activate mise properly
        mise $argv  # Run the original command
    end
end

# pnpm
set -gx PNPM_HOME "/Users/yannduval/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
