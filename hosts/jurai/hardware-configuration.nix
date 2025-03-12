{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
let
  onMacos = pkgs.stdenv.hostPlatform.system == "aarch64-linux";
in
{
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  imports = [ "${modulesPath}/profiles/qemu-guest.nix" ];

  boot.initrd.availableKernelModules = [ "xhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/media/host" = lib.mkIf onMacos {
    device = "share";
    fsType = "virtiofs";
  };
  fileSystems."/media/nixos".neededForBoot = true;

  disko.devices = {
    disk.root = {
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
  };
}
