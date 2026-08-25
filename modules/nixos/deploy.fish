argparse -n deploy c/command= r/revision= R/remote -- $argv
or return

if test -e ./flake.nix
    set flake .
else if test -e /etc/nixos/flake.nix
    set flake /etc/nixos
else
    set flake git+ssh://$grancel:/etc/nixos/
end

test -d $flake; and type -q jj
and test (realpath $flake) = "$(jj root 2>/dev/null)"
and type -q git; and git rev-parse &>/dev/null
and begin
    set revision (printf $_flag_revision; or printf 'heads(::@ ~ empty())')
    set commit (jj log -r $revision --no-graph -T commit_id)
    or return
    set flake "$flake?rev=$commit&ref=$commit"
end

set highlight (set_color -o brmagenta)
set reset (set_color normal)
function _deploy_success -a seed -a dest
    random (echo -n $seed | sum | cut -d' ' -f1)
    set icon (random choice 🌸 🌼 🌻 🌺 🌷 🍄 🍀 🌳)
    echo \nDeployed $icon$highlight$dest$reset$icon
end

function _deploy_one -a host
    set host (string replace .$domain '' $host)
    set host_url $host.$domain
    set args -e passwordless --diff never $flake
    set -a args --hostname $host --target-host $host_url
    if set -q _flag_remote
        set -a args --build-host $host_url
    end

    set root ~/.local/share/nix/gcroots/$host
    if not set -q _flag_remote; and test -d ~/.local/share/nix/gcroots
        set -a args --out-link $root
    end

    set command (printf $_flag_command; or printf switch)
    nh os $command $args
    or return

    set -q commit
    and jj --color=always bookmark set $host -B -r $commit &>/dev/null

    _deploy_success $host $host_url
end

function _deploy_router
    nix run $flake#deploy-router
    and _deploy_success router router.$domain
end

if not set -q argv[1]
    set argv (hostname -f)
end
for arg in $argv
    if test $arg = router
        _deploy_router
    else
        _deploy_one $arg
    end
end

functions -e _deploy_one _deploy_router _deploy_success
