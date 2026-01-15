argparse -n deploy -X 1 c/command= r/revision= R/remote -- $argv
or return

if test -e ./flake.nix
    set flake .
else if test -e /etc/nixos/flake.nix
    set flake /etc/nixos
else
    set flake git+ssh://grancel.ygg.pvsr.dev:/etc/nixos/
end

test -d $flake; and type -q jj
and test (realpath $flake) = "$(jj root 2>/dev/null)"
and begin
    set revision (printf $_flag_revision; or printf 'heads(::@ ~ empty())')
    set commit (jj log -r $revision --no-graph -T commit_id)
    or return

    type -q git; and git rev-parse &>/dev/null
    and set flake "$flake?rev=$commit&ref=$commit"
end

if set -q argv[1]
    set host $argv[1]
    set host_url (string replace incus (hostname) $host).ygg.pvsr.dev
    set args --target-host $host_url
    if set -q _flag_remote
        set -a args --build-host $host_url
    end
else
    set host (hostname)
end

set -a args --no-reexec --sudo --flake $flake#$host

set -a args (printf $_flag_command; or printf switch)

if not set -q _flag_remote; and test -d ~/.local/share/nix/gcroots
    set result (nix build \
        $flake#nixosConfigurations.\"$host\".config.system.build.toplevel \
        --print-out-paths --log-format internal-json --verbose 2>| nom --json)
    test $pipestatus[1] = 0; or return
end

nixos-rebuild $args --log-format internal-json --verbose 2>| nom --json
test $pipestatus[1] = 0; or return

set -q commit
and jj --color=always bookmark set $host -B -r $commit &>/dev/null

set -q result
and nix-store --realise $result \
    --add-root ~/.local/share/nix/gcroots/$host &>/dev/null
