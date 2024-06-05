{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
    ./hardware-configuration.nix
    ../../modules/graphical.nix
    ../../modules/steam.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "grancel";
  networking.nameservers = ["1.1.1.1" "1.0.0.1"];

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
    openssh.ports = [22 23232];
    openssh.settings.PasswordAuthentication = false;
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
              target."ssh://ruan:24424/media/leiston/btrbk_backups/grancel/grancel" = {};
              subvolume = {
                home = {};
                nix = {};
                persist = {};
              };
            };
          };
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    23232
  ];

  system.stateVersion = "23.11";

  users.mutableUsers = false;
  users.users.root.hashedPasswordFile = "/media/grancel/persist/passwords/root";
  users.users.peter.hashedPasswordFile = "/media/grancel/persist/passwords/peter";
  environment.persistence."/media/grancel/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/machines"
      "/var/lib/nixos"
      "/var/lib/systemd"
      "/var/lib/tailscale"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };
}
