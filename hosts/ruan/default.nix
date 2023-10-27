{
  config,
  pkgs,
  flake,
  ...
}: let
  zemuriaAddress = "100.64.0.3";
in {
  imports = [
    ./hardware-configuration.nix
    ./miniflux.nix
    ./podcasts.nix
    ./transmission.nix
    ../../modules/graphical.nix
    ../../modules/steam.nix
    flake.inputs.weather.nixosModules.default
    flake.inputs.podcasts.nixosModules.default
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.useDHCP = false;
  networking.interfaces.enp37s0.useDHCP = true;
  networking.interfaces.wlp36s0.useDHCP = true;

  networking.hostName = "ruan";
  networking.nameservers = ["1.1.1.1" "1.0.0.1"];

  console.keyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";

  time.timeZone = "America/New_York";

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
    openssh.settings.PasswordAuthentication = false;
    openssh.settings.AcceptEnv = "TERMINFO COLORTERM";

    radicale.enable = true;
    radicale.settings = {
      server.hosts = ["${zemuriaAddress}:52032"];
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

    weather.enable = true;
    weather.bind = "${zemuriaAddress}:15658";

    komga = {
      enable = true;
      port = 19191;
      openFirewall = true;
    };

    jellyfin.enable = true;
    jellyfin.user = "peter";
    jellyfin.group = "users";
    jellyfin.openFirewall = true; # 8096 only

    nitter = {
      enable = true;
      server.port = 7775;
      server.hostname = "${zemuriaAddress}:7775";
      preferences.replaceTwitter = "ruan:7775";
      preferences.hlsPlayback = true;
      preferences.theme = "Twitter Dark";
    };

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
  systemd.services.radicale.after = ["tailscaled.service"];
  systemd.services.weather.after = ["tailscaled.service"];
  systemd.services.nitter.after = ["tailscaled.service"];

  networking.firewall.allowedTCPPorts = [
    24424
    8080
    52032
    15658
    7775
  ];
  networking.firewall.allowedUDPPorts = [
  ];

  system.stateVersion = "20.09";
}
