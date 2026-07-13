# Port of oh-my-zsh's take/takeurl/takezip/takegit/takedir from lib/functions.zsh

function takedir --description "Create a directory (with parents) and cd into the last arg"
    # mirrors: mkdir -p $@ && cd ${@: $#}
    mkdir -p -- $argv; and cd -- $argv[-1]
end

function takeurl --description "Download a tar.* archive URL, extract, cd into first entry"
    set -l data (mktemp)
    curl -L -- "$argv[1]" > "$data"; or begin
        rm -f -- "$data"
        return 1
    end

    tar xf -- "$data"; or begin
        rm -f -- "$data"
        return 1
    end

    set -l thedir (tar tf -- "$data" | head -n 1)
    rm -f -- "$data"

    # upstream does: cd "$thedir"
    cd -- "$thedir"
end

function takezip --description "Download a zip URL, unzip, cd into top entry"
    set -l data (mktemp)
    curl -L -- "$argv[1]" > "$data"; or begin
        rm -f -- "$data"
        return 1
    end

    unzip -- "$data" -d "./"; or begin
        rm -f -- "$data"
        return 1
    end

    # upstream does:
    # thedir="$(unzip -l "$data" | awk 'NR==4 {print $4}' | sed 's/\/.*//')"
    set -l thedir (unzip -l -- "$data" | awk 'NR==4 {print $4}' | sed 's/\/.*//')
    rm -f -- "$data"

    cd -- "$thedir"
end

function takegit --description "Clone a git repo URL and cd into the repo directory"
    git clone -- "$argv[1]"; or return 1

    # upstream: cd "$(basename ${1%%.git})"
    # Fish-friendly: drop trailing slash, drop trailing .git, then basename
    set -l cleaned (string replace -r '/$' '' -- "$argv[1]")
    set -l cleaned (string replace -r '\.git$' '' -- "$cleaned")
    cd -- (basename -- "$cleaned")
end

function take --description "Oh-My-Zsh style: dir OR git clone OR download+extract (tar/zip)"
    if test (count $argv) -lt 1
        echo "usage: take <dir|git-url|archive-url>"
        return 2
    end

    set -l target "$argv[1]"

    # Matches the upstream dispatch logic/patterns in oh-my-zsh's lib/functions.zsh
    if string match -rq '^(https?|ftp).*\.(tar\.(gz|bz2|xz)|tgz)$' -- "$target"
        takeurl "$target"
    else if string match -rq '^(https?|ftp).*\.(zip)$' -- "$target"
        takezip "$target"
    else if string match -rq '^([A-Za-z0-9]+\+@|https?|git|ssh|ftps?|rsync).*\.(git)/?$' -- "$target"
        takegit "$target"
    else
        takedir $argv
    end
end
