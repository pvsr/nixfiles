{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./miniflux.nix
    ./podcasts.nix
    ./transmission.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.useDHCP = false;
  networking.interfaces.enp37s0.useDHCP = true;
  networking.interfaces.wlp36s0.useDHCP = true;

  networking.nameservers = ["1.1.1.1" "1.0.0.1"];

  networking.hosts = {"192.168.0.104" = ["grancel"];};

  console.keyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";

  time.timeZone = "America/New_York";

  hardware.video.hidpi.enable = true;
  hardware.enableRedistributableFirmware = true;
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [agenix];

  age.secrets."radicale-users" = {
    file = ./secrets/radicale-users.age;
    owner = "radicale";
    group = "radicale";
  };
  services = {
    openssh.enable = true;
    openssh.ports = [24424];
    openssh.passwordAuthentication = false;
    openssh.extraConfig = "AcceptEnv=TERMINFO";

    radicale.enable = true;
    radicale.settings = {
      server.hosts = ["0.0.0.0:52032" "[::]:52032"];
      auth = {
        type = "htpasswd";
        htpasswd_filename = config.age.secrets."radicale-users".path;
        htpasswd_encryption = "bcrypt";
      };
    };

    # mpd.enable = true;
    # mpd.startWhenNeeded = true;

    samba.enable = false;
    # samba.syncPasswordsByPam = true;
    samba.shares = {
      public = {
        path = "/home/peter/annex";
        "read only" = true;
        browsable = "yes";
      };
    };

    jellyfin.enable = false;
    jellyfin.user = "peter";
    jellyfin.group = "users";

    btrbk = {
      sshAccess = [
        {
          key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFmuZsWQaHVogdYsIYO1qtpKq+jkBp7k01qPh38Ls3UX";
          roles = ["info" "source" "target" "delete" "snapshot" "send" "receive"];
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
                home = {};
                root = {};
              };
            };
          };
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    24424
    8080
    52032
  ];
  networking.firewall.allowedUDPPorts = [
  ];

  system.stateVersion = "20.09";
}
