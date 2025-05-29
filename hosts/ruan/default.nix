{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  serverAddress = if config.services.tailscale.enable then config.local.tailscale.ip else "0.0.0.0";
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
  age.secrets."tandoor-key" = {
    file = ./secrets/tandoor-key.age;
  };
  services = {
    radicale.enable = true;
    radicale.settings = {
      server.hosts = [ "${serverAddress}:52032" ];
      auth = {
        type = "htpasswd";
        htpasswd_filename = config.age.secrets."radicale-users".path;
        htpasswd_encryption = "bcrypt";
      };
    };

    weather.enable = true;
    weather.bind = "${serverAddress}:15658";

    komga = {
      enable = true;
      port = 19191;
      openFirewall = true;
    };

    tandoor-recipes = {
      enable = true;
      address = serverAddress;
      port = 36597;
      extraConfig.SECRET_KEY_FILE = config.age.secrets."tandoor-key".path;
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
  systemd.services.tandoor-recipes = waitForTailscale;

  local.caddy-gateway = {
    enable = true;
    reverseProxies = {
      "grafana.peterrice.xyz:80" = "localhost:10508";
    };
  };

  local.metrics.enable = true;
  local.metrics.grafana.address = "127.0.0.1";
  local.metrics.grafana.port = 10508;

  networking.firewall.allowedTCPPorts = [
    15658 # weather
    36597 # tandoor
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
      "/var/lib/private/tandoor-recipes"
      "/var/lib/private/radicale"
    ];
  };
}
