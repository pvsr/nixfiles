{ config, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/graphical.nix
    ../../modules/steam.nix
    ../../modules/impermanence.nix
    inputs.srvos.nixosModules.desktop
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "grancel";
  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
  ];
  networking.useDHCP = true;

  console.font = "Lat2-Terminus16";
  console.keyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";

  time.timeZone = "America/New_York";

  nixpkgs.config.allowUnfree = true;

  age.secrets."btrbk.id_ed25519" = {
    file = ./secrets/btrbk.id_ed25519.age;
    owner = "btrbk";
    group = "btrbk";
  };

  services = {
    openssh.enable = true;
    openssh.ports = [
      22
      23232
    ];
    btrbk = {
      instances.btrbk = {
        onCalendar = "daily";
        settings = {
          snapshot_preserve_min = "latest";
          target_preserve_min = "no";
          target_preserve = "7d 3w";
          snapshot_dir = "btrbk_snapshots";
          ssh_identity = config.age.secrets."btrbk.id_ed25519".path;
          ssh_user = "btrbk";
          volume = {
            "/media/grancel" = {
              target."ssh://ruan:24424/media/leiston/btrbk_backups/grancel/grancel" = { };
              subvolume = {
                home = { };
                persist = { };
              };
            };
          };
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 23232 ];

  system.stateVersion = "24.05";

  impermanence = {
    enable = true;
    device = "/dev/disk/by-label/grancel";
    persist = "/media/grancel/persist";
  };
}
