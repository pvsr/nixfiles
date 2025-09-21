{ inputs, ... }:
{
  local.hosts.ruan = { };

  flake.modules.nixos.ruan =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      waitForTailscale = lib.mkIf config.services.tailscale.enable {
        after = [ "tailscaled.service" ];
        wants = [ "tailscaled.service" ];
      };
    in
    {
      imports = [
        inputs.self.modules.nixos.desktop
        inputs.self.modules.nixos.gateway
        inputs.weather.nixosModules.default
        inputs.podcasts.nixosModules.default
      ];

      programs.steam.enable = true;

      boot.loader.systemd-boot.enable = true;
      boot.loader.systemd-boot.editor = false;
      boot.loader.efi.canTouchEfiVariables = true;

      hardware.enableRedistributableFirmware = true;
      nixpkgs.config.allowUnfree = true;

      age.secrets."radicale-users" = {
        file = ./secrets/radicale-users.age;
        owner = "radicale";
        group = "radicale";
      };
      age.secrets."dns-token" = {
        file = ./secrets/dns-token.age;
      };
      services = {
        radicale.enable = true;
        radicale.settings = {
          server.hosts = [ "${config.local.tailscale.ip}:52032" ];
          auth = {
            type = "htpasswd";
            htpasswd_filename = config.age.secrets."radicale-users".path;
            htpasswd_encryption = "bcrypt";
          };
        };

        weather.enable = true;
        weather.bind = "${config.local.tailscale.ip}:15658";

        komga = {
          enable = true;
          openFirewall = true;
          settings.server.port = 19191;
        };

        btrbk = {
          sshAccess = [
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
          instances.btrbk = {
            onCalendar = "daily";
            settings = {
              snapshot_preserve_min = "latest";
              target_preserve_min = "no";
              target_preserve = "7d 3w";
              snapshot_dir = "btrbk_snapshots";
              volume = {
                "/media/nixos" = {
                  target = "/media/leiston/btrbk_backups/ruan/nixos";
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
        };
      };

      systemd.services.radicale = waitForTailscale;
      systemd.services.weather = waitForTailscale;

      systemd.services.caddy.serviceConfig.EnvironmentFile = config.age.secrets."dns-token".path;

      networking.firewall.allowedTCPPorts = [
        15658 # weather
        52032 # radicale
      ];

      system.stateVersion = "24.05";
      services.postgresql.package = pkgs.postgresql_16;

      local.persistence = {
        enable = true;
        rootDevice = "/dev/disk/by-label/nixos";
      };
      environment.persistence.nixos = {
        hideMounts = true;
        persistentStoragePath = "/media/nixos/persist";
        directories = [
          "/var/lib/komga"
          "/var/lib/postgresql"
          "/var/lib/private/radicale"
        ];
      };
      environment.persistence.data = {
        hideMounts = true;
        persistentStoragePath = "/media/data/persist";
      };
    };
}
