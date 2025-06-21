{
  config,
  lib,
  pkgs,
  inputs,
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
    ./hardware-configuration.nix
    ./miniflux.nix
    ./podcasts.nix
    ./transmission.nix
    inputs.srvos.nixosModules.desktop
    inputs.weather.nixosModules.default
    inputs.podcasts.nixosModules.default
  ];

  programs.steam.enable = true;
  local.niri.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
  ];
  networking.useDHCP = lib.mkDefault true;

  console.keyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";

  time.timeZone = "America/New_York";

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
                root = { };
              };
            };
          };
        };
      };
    };
  };

  systemd.services.radicale = waitForTailscale;
  systemd.services.weather = waitForTailscale;

  local.caddy-gateway = {
    enable = true;
    internalProxies = {
      "grafana.peterrice.xyz" = "localhost:10508";
    };
  };

  systemd.services.caddy.serviceConfig.EnvironmentFile = config.age.secrets."dns-token".path;

  local.metrics.enable = true;
  local.metrics.grafana.address = "127.0.0.1";
  local.metrics.grafana.port = 10508;

  networking.firewall.allowedTCPPorts = [
    15658 # weather
    52032 # radicale
  ];

  system.stateVersion = "24.05";
  services.postgresql.package = pkgs.postgresql_16;

  local.impermanence = {
    enable = true;
    device = "/dev/disk/by-label/nixos";
    persist = "/media/nixos/persist";
    directories = [
      "/var/lib/komga"
      "/var/lib/postgresql"
      "/var/lib/private/radicale"
    ];
  };
}
