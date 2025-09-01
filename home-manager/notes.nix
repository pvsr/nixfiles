{
  flake.modules.homeManager.grancel =
    { lib, pkgs, ... }:
    {
      programs.fish.shellAbbrs.notes = {
        expansion = "hx ~/notes/%";
        setCursor = true;
      };
      systemd.user = {
        services.commit-notes.Service = {
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
          Timer = {
            OnCalendar = "daily";
            Persistent = true;
          };
          Install.WantedBy = [ "timers.target" ];
        };
      };
    };
}
