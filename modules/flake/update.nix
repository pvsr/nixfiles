{
  flake.modules.hjem.grancel =
    { pkgs, ... }:
    {
      systemd = {
        services.update-flake.path = with pkgs; [
          lix
          jujutsu
          git
          openssh
        ];
        services.update-flake.serviceConfig = {
          Type = "oneshot";
          ExecStart = pkgs.writers.writeFish "update-flake" ''
            test -d /etc/nixos; or exit 0
            cd /etc/nixos
            jj root; or exit 0

            jj new --quiet
            set restore (jj log --no-graph -r @- -T 'change_id.shortest(8)')
            echo Will restore $restore

            set remote github
            echo Fetching remote $remote
            jj git fetch --remote $remote
            jj new main@$remote

            echo Starting flake update
            git config set --local user.name 'Peter Rice (automated)'
            git config set --local user.email noreply@pvsr.dev
            nix flake update --commit-lock-file
            git config unset --local user.name
            git config unset --local user.email

            set bookmark flake-update
            jj bookmark set -B -r "@- ~ main@$remote" $bookmark
            and jj git push --remote $remote --bookmark $bookmark

            jj edit $restore
          '';
        };
        timers.update-flake = {
          timerConfig = {
            OnCalendar = "Fri *-*-* 06:00";
            Persistent = true;
          };
          wantedBy = [ "timers.target" ];
        };
      };
    };
}
