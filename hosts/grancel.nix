{ config, pkgs, ... }: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.useDHCP = false;
  networking.interfaces.enp6s0.useDHCP = true;
  # networking.interfaces.wlp5s0.useDHCP = true;

  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

  networking.hosts = { "192.168.0.110" = [ "ruan" ]; };

  console.font = "Lat2-Terminus16";
  console.keyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";

  time.timeZone = "America/New_York";

  hardware.enableRedistributableFirmware = true;
  nixpkgs.config.allowUnfree = true;

  age.secrets."btrbk.id_ed25519" = {
    file = ../secrets/btrbk.id_ed25519.age;
    owner = "btrbk";
    group = "btrbk";
  };

  services = {
    openssh.enable = true;
    openssh.ports = [ 23232 ];
    openssh.passwordAuthentication = false;
    btrbk = {
      instances.btrbk = {
        onCalendar = "daily";
        settings = {
          snapshot_preserve_min = "1d";
          snapshot_preserve = "2d";
          target_preserve_min = "no";
          target_preserve = "7d 3w";
          snapshot_dir = "btrbk_snapshots";
          ssh_identity = config.age.secrets."btrbk.id_ed25519".path;
          ssh_user = "btrbk";
          volume = {
            "/media/nixos" = {
              target = "ssh://ruan:24424/media/leiston/btrbk_backups/grancel/nixos";
              subvolume = {
                root = { };
                home = { };
              };
            };
            "/media/gdata2" = {
              target = "ssh://ruan:24424/media/leiston/btrbk_backups/grancel/gdata2";
              subvolume = {
                home = { };
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

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  hardware.bluetooth.enable = true;
  services.pipewire = {
    media-session.config.bluez-monitor.rules = [
      {
        # Matches all cards
        matches = [{ "device.name" = "~bluez_card.*"; }];
        actions = {
          "update-props" = {
            "bluez5.auto-connect" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
          };
        };
      }
      {
        matches = [
          # Matches all sources
          { "node.name" = "~bluez_input.*"; }
          # Matches all outputs
          { "node.name" = "~bluez_output.*"; }
        ];
        actions = {
          "node.pause-on-idle" = false;
        };
      }
      {
        matches = [{ "device.name" = "bluez_card.DC:E5:5B:22:D5:D8"; }];
        actions = {
          "update-props" = {
            "bluez5.auto-connect" = [ "hfp_ag" "hsp_ag" "a2dp_source" ];
            "bluez5.a2dp-source-role" = "input";
          };
        };
      }
    ];
  };

  system.stateVersion = "21.05";

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/e1e91f6c-0c5a-407e-b784-f28431839036";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/e1e91f6c-0c5a-407e-b784-f28431839036";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

  fileSystems."/media/nixos" =
    {
      device = "/dev/disk/by-uuid/e1e91f6c-0c5a-407e-b784-f28431839036";
      fsType = "btrfs";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/A253-A1F7";
      fsType = "vfat";
    };

  fileSystems."/media/gdata2" =
    {
      device = "/dev/disk/by-uuid/b29448d8-fe2b-4b80-8a27-2987665ddde6";
      fsType = "btrfs";
    };

  fileSystems."/media/arch" =
    {
      device = "/dev/disk/by-uuid/0b865d88-2a0e-438a-96e8-bb3035d0b488";
      fsType = "ext4";
    };

}
