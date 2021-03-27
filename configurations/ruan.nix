{ pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.useDHCP = false;
  networking.interfaces.enp37s0.useDHCP = true;
  networking.interfaces.wlp36s0.useDHCP = true;

  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

  networking.hosts = { "192.168.0.104" = [ "grancel" ]; };

  console.font = "Lat2-Terminus16";
  console.keyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";

  time.timeZone = "America/New_York";

  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  hardware.pulseaudio.support32Bit = true;

  services = {
    openssh.enable = true;
    openssh.ports = [ 24424 ];
    openssh.passwordAuthentication = false;

    miniflux.enable = true;
    miniflux.config.LISTEN_ADDR = "192.168.0.110:8080";
    # TODO
    miniflux.adminCredentialsFile = /etc/nixos/miniflux-admin-credentials;

    radicale.enable = false;
    #radicale.config = ''
    #'';
    #radicale.extraArgs = [];

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
  };

  nix = {
    #package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  networking.firewall.allowedTCPPorts = [
    24424
    9090
    9091
    51413
    8080
    8096
  ];
  networking.firewall.allowedUDPPorts = [
  ];

  security.sudo.wheelNeedsPassword = false;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.09"; # Did you read the comment?

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "uas" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/2f1cf9d8-5b5f-4d0f-89dc-ef52a1d0d174";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/2f1cf9d8-5b5f-4d0f-89dc-ef52a1d0d174";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/AB78-74B8";
      fsType = "vfat";
    };

  fileSystems."/var/lib/transmission" =
    { device = "/dev/disk/by-uuid/367ffdb7-bfaf-4409-9115-5ecbe4261bae";
      fsType = "btrfs";
      options = [ "subvol=transmission" ];
    };

  fileSystems."/media/steam" =
    { device = "/dev/disk/by-uuid/367ffdb7-bfaf-4409-9115-5ecbe4261bae";
      fsType = "btrfs";
      options = [ "subvol=steam" ];
    };

  fileSystems."/media/data" =
    { device = "/dev/disk/by-uuid/367ffdb7-bfaf-4409-9115-5ecbe4261bae";
      fsType = "btrfs";
    };

  hardware.video.hidpi.enable = true;
}