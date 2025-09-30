{
  flake.modules.nixos.grancel.fileSystems."/run/media/valleria" = {
    device = "/dev/disk/by-label/valleria";
    fsType = "bcachefs";
    options = [
      "nofail"
      "defaults"
      "compression=lz4"
      "background=compression=lz4"
    ];
  };

  flake.modules.nixos.grancel.disko.devices.disk = {
    grancel = {
      device = "/dev/nvme0n1";
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
          data = {
            size = "1G";
            content = {
              type = "btrfs";
              subvolumes = {
                "/swap" = {
                  mountpoint = "/var/lib/swap";
                  swap.swapfile.size = "64G";
                };
                "/steam" = {
                  mountpoint = "/run/media/grancel-steam";
                  mountOptions = [
                    "defaults"
                    "compress=zstd"
                  ];
                };
              };
            };
          };
          nix = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "bcachefs";
              mountpoint = "/";
              mountOptions = [
                "defaults"
                "compression=lz4"
                "background=compression=lz4"
              ];
            };
          };
        };
      };
    };
    gdata2 = {
      device = "/dev/sda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          data = {
            size = "100%";
            content = {
              type = "btrfs";
              mountpoint = "/run/media/gdata2";
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
