{
  flake.modules.nixos.jurai.fileSystems."/media/nixos".neededForBoot = true;

  flake.modules.nixos.jurai.local.impermanence = {
    enable = true;
    device = "/dev/disk/by-partlabel/disk-root-root";
    persist = "/media/nixos/persist";
  };

  flake.modules.nixos.jurai.disko.devices.disk.root = {
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
              "/" = {
                mountpoint = "/media/nixos";
                mountOptions = [ "compress=zstd" ];
              };
              "/tmp_root" = {
                mountpoint = "/";
                mountOptions = [ "compress=zstd" ];
              };
              "/home" = {
                mountpoint = "/home";
                mountOptions = [ "compress=zstd" ];
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
              "/persist" = { };
            };
          };
        };
      };
    };
  };
}
