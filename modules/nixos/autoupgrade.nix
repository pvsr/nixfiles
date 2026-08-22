let
  flake = "github:pvsr/nixfiles";
in
{
  flake.modules.nixos.core.system.autoUpgrade = {
    enable = true;
    inherit flake;
    dates = "07:00";
    persistent = false;
  };

  local.desktops.grancel = { config, pkgs, ... }: {
    hjem.extraModules = [
      {
        systemd.services.rebuild-os = {
          path = [
            config.nix.package
            pkgs.nh
          ];
          serviceConfig.Type = "oneshot";
          serviceConfig.ExecStart = pkgs.writers.writeFish "rebuild-os" ''
            for branch in main update_flake_lock_action
              nh os build ${flake}/$branch
            end
          '';
        };
        systemd.timers.rebuild-os = {
          timerConfig = {
            OnCalendar = "Wed,Fri *-*-* 06:00";
            Persistent = true;
          };
          wantedBy = [ "timers.target" ];
        };
      }
    ];
  };
}
