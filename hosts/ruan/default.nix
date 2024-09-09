{
  config,
  pkgs,
  inputs,
  ...
}:
let
  tailscaleAddress = "100.64.0.3";
  requireTailscale = {
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
    ../../modules/graphical.nix
    ../../modules/steam.nix
    ../../modules/impermanence.nix
    inputs.srvos.nixosModules.desktop
    inputs.weather.nixosModules.default
    inputs.podcasts.nixosModules.default
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "ruan";
  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
  ];
  networking.useDHCP = true;

  console.keyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";

  time.timeZone = "America/New_York";

  hardware.enableRedistributableFirmware = true;
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [ agenix ];

  age.secrets."radicale-users" = {
    file = ./secrets/radicale-users.age;
    owner = "radicale";
    group = "radicale";
  };
  age.secrets."tandoor-key" = {
    file = ./secrets/tandoor-key.age;
  };
  services = {
    openssh.enable = true;
    openssh.ports = [
      22
      24424
    ];

    radicale.enable = true;
    radicale.settings = {
      server.hosts = [ "${tailscaleAddress}:52032" ];
      auth = {
        type = "htpasswd";
        htpasswd_filename = config.age.secrets."radicale-users".path;
        htpasswd_encryption = "bcrypt";
      };
    };

    weather.enable = true;
    weather.bind = "${tailscaleAddress}:15658";

    komga = {
      enable = true;
      port = 19191;
      openFirewall = true;
    };

    tandoor-recipes = {
      enable = true;
      address = tailscaleAddress;
      port = 36597;
      extraConfig.SECRET_KEY_FILE = config.age.secrets."tandoor-key".path;
    };

    jellyfin.enable = true;
    jellyfin.user = "peter";
    jellyfin.group = "users";
    jellyfin.openFirewall = true; # 8096 only

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
  systemd.services.radicale = requireTailscale;
  systemd.services.weather = requireTailscale;
  systemd.services.tandoor-recipes = requireTailscale;

  networking.firewall.allowedTCPPorts = [
    24424 # sshd
    15658 # weather
    36597 # tandoor
  ];

  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [
    22
    52032 # radicale
    47808 # dev
  ];

  system.stateVersion = "24.05";
  services.postgresql.package = pkgs.postgresql_16;

  impermanence = {
    enable = true;
    device = "/dev/disk/by-label/nixos";
    persist = "/media/nixos/persist";
    directories = [
      "/var/lib/jellyfin"
      "/var/lib/komga"
      "/var/lib/postgresql"
      "/var/lib/private/shiori"
      "/var/lib/private/tandoor-recipes"
      "/var/lib/private/radicale"
    ];
  };
}
