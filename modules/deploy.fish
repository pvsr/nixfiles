#!/usr/bin/env fish
argparse -n deploy -X 1 'c/command=' 'f/flake=' -- $argv
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
and set commit (jj log -r 'heads(::@ ~ empty())' --no-graph -T commit_id)

if set -q argv[1]
    set host $argv[1]
    set args --target-host $host.ts.peterrice.xyz
else
    set host (hostname)
end
set -a args --no-reexec --sudo --flake $flake#$host
set -a args (printf $_flag_command; or printf switch)

nixos-rebuild $args --log-format internal-json --verbose &| nom --json

test $pipestatus[1] = 0
and set -q commit
and jj --color=always bookmark set $host -B -r $commit 2&>/dev/null
