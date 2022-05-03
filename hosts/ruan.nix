{ config, pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.useDHCP = false;
  networking.interfaces.enp37s0.useDHCP = true;
  networking.interfaces.wlp36s0.useDHCP = true;

  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

  networking.hosts = { "192.168.0.104" = [ "grancel" ]; };

  #console.font = "Lat2-Terminus16";
  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
  console.keyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";

  time.timeZone = "America/New_York";

  hardware.video.hidpi.enable = true;
  hardware.enableRedistributableFirmware = true;
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [ agenix ];

  age.secrets."radicale-users" = {
    file = ../secrets/radicale-users.age;
    owner = "radicale";
    group = "radicale";
  };
  services = {
    openssh.enable = true;
    openssh.ports = [ 24424 ];
    openssh.passwordAuthentication = false;

    radicale.enable = true;
    radicale.settings = {
      server.hosts = [ "0.0.0.0:52032" "[::]:52032" ];
      auth = {
        type = "htpasswd";
        htpasswd_filename = "/run/secrets/radicale-users";
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
      sshAccess = [{
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFmuZsWQaHVogdYsIYO1qtpKq+jkBp7k01qPh38Ls3UX";
        roles = [ "info" "source" "target" "delete" "snapshot" "send" "receive" ];
      }];
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

  nix = {
    #package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  networking.firewall.allowedTCPPorts = [
    24424
    8080
    52032
  ];
  networking.firewall.allowedUDPPorts = [
  ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.09"; # Did you read the comment?

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "uas" "sd_mod" ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/2f1cf9d8-5b5f-4d0f-89dc-ef52a1d0d174";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/2f1cf9d8-5b5f-4d0f-89dc-ef52a1d0d174";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/AB78-74B8";
      fsType = "vfat";
    };

  fileSystems."/var/lib/transmission" =
    {
      device = "/dev/disk/by-uuid/367ffdb7-bfaf-4409-9115-5ecbe4261bae";
      fsType = "btrfs";
      options = [ "subvol=transmission" ];
    };

  fileSystems."/media/steam" =
    {
      device = "/dev/disk/by-uuid/367ffdb7-bfaf-4409-9115-5ecbe4261bae";
      fsType = "btrfs";
      options = [ "subvol=steam" ];
    };

  fileSystems."/media/data" =
    {
      device = "/dev/disk/by-uuid/367ffdb7-bfaf-4409-9115-5ecbe4261bae";
      fsType = "btrfs";
    };
}
