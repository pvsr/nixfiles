{ ... }:
{

  local.desktops.ruan = {
    local.persistence.enable = true;
    local.persistence.rootDevice = "/dev/disk/by-partlabel/disk-nixos-root";

    environment.persistence.nixos = {
      hideMounts = true;
      persistentStoragePath = "/run/media/persist";
    };
    fileSystems."/run/media/persist".neededForBoot = true;

    environment.persistence.data = {
      hideMounts = true;
      persistentStoragePath = "/run/media/data/persist";
    };
  };

  local.desktops.ruan.disko.devices.disk = {
    nixos = {
      device = "/dev/disk/by-uuid/2f1cf9d8-5b5f-4d0f-89dc-ef52a1d0d174";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            type = "EF00";
            size = "512M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          root = {
            size = "100%";
            content = {
              type = "btrfs";
              mountpoint = "/run/media/nixos";
              subvolumes = {
                "/tmp_root" = {
                  mountpoint = "/";
                  mountOptions = [
                    "defaults"
                    "compress=zstd"
                  ];
                };
                "/home" = {
                  mountpoint = "/home";
                  mountOptions = [
                    "defaults"
                    "compress=zstd"
                  ];
                };
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "noatime"
                    "defaults"
                    "compress=zstd"
                  ];
                };
                "/swap" = {
                  mountpoint = "/var/lib/swap";
                  swap.swapfile.size = "8G";
                };
                "/persist" = {
                  mountpoint = "/run/media/persist";
                  mountOptions = [
                    "defaults"
                    "compress=zstd"
                  ];
                };
              };
            };
          };
        };
      };
    };
    data = {
      device = "/dev/disk/by-uuid/367ffdb7-bfaf-4409-9115-5ecbe4261bae";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          data = {
            size = "100%";
            content = {
              type = "btrfs";
              mountpoint = "/run/media/data";
              mountOptions = [
                "defaults"
                "compress=zstd"
              ];
            };
          };
        };
      };
    };
    leiston = {
      device = "/dev/disk/by-uuid/c76abfad-5b5a-478f-a85e-dde18ffe202f";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          leiston = {
            size = "100%";
            content = {
              type = "btrfs";
              mountpoint = "/run/media/leiston";
              mountOptions = [
                "nofail"
                "defaults"
                "compress=zstd"
              ];
            };
          };
        };
      };
    };
  };
}
