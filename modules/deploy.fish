#!/usr/bin/env fish
argparse -n deploy -X 1 c/command= r/remote -- $argv
or return

if test -e ./flake.nix
    set flake .
else if test -e /etc/nixos
    set flake /etc/nixos
else
    set flake git+ssh://grancel:/etc/nixos/
end

test -d "$flake"
and type -q jj
and test (realpath "$flake") = "$(jj root 2>/dev/null)"
and set change (jj log -r 'heads(::@ ~ empty())' --no-graph -T change_id)

if set -q argv[1]
    set host $argv[1]
    set args --target-host $host.ts.peterrice.xyz
    if set -q _flag_remote
        set -a args --build-host $host.ts.peterrice.xyz
    end
else
    set host (hostname)
end
set -a args --no-reexec --sudo --flake $flake#$host
set -a args (printf $_flag_command; or printf switch)

nixos-rebuild $args --log-format internal-json --verbose &| nom --json

test $pipestatus[1] = 0
and set -q change
and jj --color=always bookmark set $host -B -r $change 2&>/dev/null
