{
  local.desktops.jurai.fileSystems."/run/media/persist".neededForBoot = true;

  local.desktops.jurai.local.persistence = {
    enable = true;
    rootDevice = "/dev/disk/by-partlabel/disk-root-root";
  };
  local.desktops.jurai.environment.persistence.nixos = {
    hideMounts = true;
    persistentStoragePath = "/run/media/persist";
  };

  local.desktops.jurai.disko.devices.disk.root = {
    device = "/dev/vda";
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
}
