{ inputs, lib, ... }:
{
  flake.modules.hjem.ruan.niri.extraConfig = ''output "HDMI-A-3" { scale 2.0; }'';

  local.desktops.ruan =
    { config, pkgs, ... }:
    {
      hjem.extraModules = [
        inputs.self.modules.hjem.desktop
        inputs.self.modules.hjem.firefox
      ];

      programs.steam.enable = true;

      boot.loader.systemd-boot.enable = true;
      boot.loader.systemd-boot.editor = false;
      boot.loader.efi.canTouchEfiVariables = true;

      hardware.enableRedistributableFirmware = true;

      services.btrbk.sshAccess = [
        {
          key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFmuZsWQaHVogdYsIYO1qtpKq+jkBp7k01qPh38Ls3UX";
          roles = [
            "info"
            "source"
            "target"
            "delete"
            "snapshot"
            "send"
            "receive"
          ];
        }
      ];
      services.btrbk.instances.btrbk = {
        onCalendar = "daily";
        settings = {
          snapshot_preserve_min = "latest";
          target_preserve_min = "no";
          target_preserve = "7d 3w";
          snapshot_dir = "btrbk_snapshots";
          volume = {
            "/run/media/nixos" = {
              target = "/run/media/leiston/btrbk_backups/ruan/nixos";
              subvolume = {
                home = { };
                persist = { };
                nix = { };
                tmp_root = { };
              };
            };
          };
        };
      };

      age.secrets."dns-token" = {
        file = ./secrets/dns-token.age;
      };
      systemd.services.caddy.serviceConfig.EnvironmentFile = config.age.secrets."dns-token".path;

      environment.persistence.data.enable = config.local.persistence.enable;

      services.komga.enable = true;
      services.komga.settings.server.port = 19191;
      networking.firewall.interfaces.ygg0.allowedTCPPorts = [
        19191
      ];
      environment.persistence.nixos.directories = [ "/var/lib/komga" ];

      system.stateVersion = "24.05";
    };
}
