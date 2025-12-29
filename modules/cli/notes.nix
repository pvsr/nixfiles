{
  flake.modules.hjem.grancel =
    { lib, pkgs, ... }:
    {
      fish.interactiveShellInit = "abbr --add --set-cursor -- notes 'hx ~/notes/%'";
      systemd = {
        services.commit-notes.serviceConfig = {
          Type = "oneshot";
          ExecStart = pkgs.writers.writeFish "commit-notes" ''
            test -d notes; or exit 0
            cd notes
            set diff (${pkgs.jujutsu}/bin/jj diff)
            test -n "$diff"; or exit 0
            ${pkgs.jujutsu}/bin/jj commit --message "daily autocommit"
          '';
        };
        timers.commit-notes = {
          timerConfig = {
            OnCalendar = "daily";
            Persistent = true;
          };
          wantedBy = [ "timers.target" ];
        };
      };
    };
}
