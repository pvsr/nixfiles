{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/graphical.nix
    ../../modules/steam.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.nameservers = ["1.1.1.1" "1.0.0.1"];

  networking.hosts = {"192.168.0.110" = ["ruan"];};

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
    openssh.ports = [23232];
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
              target."/media/grancel-new/btrbk_backups/grancel" = {};
              target."ssh://ruan:24424/media/leiston/btrbk_backups/grancel/grancel" = {};
              subvolume = {
                home = {};
                root = {};
              };
            };
            "/media/gdata2" = {
              target."ssh://ruan:24424/media/leiston/btrbk_backups/grancel/gdata2" = {};
              subvolume = {
                home = {};
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

  hardware.bluetooth.enable = true;
  environment.etc = {
    "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
      bluez_monitor.properties = {
        ["bluez5.enable-sbc-xq"] = true,
        ["bluez5.enable-msbc"] = true,
        ["bluez5.enable-hw-volume"] = true,
        ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
      }
      bluez_monitor.rules = {
        matches = {
          {
            { "device.name", "matches", "bluez_card.*" },
          },
        },
        apply_properties = {
          ["bluez5.auto-connect"] = "[ hfp_hf hsp_hs a2dp_sink ]"
        }
      }
    '';
  };

  system.stateVersion = "21.05";
}
